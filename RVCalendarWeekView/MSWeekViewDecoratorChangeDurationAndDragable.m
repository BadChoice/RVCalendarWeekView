#import "MSWeekViewDecoratorChangeDurationAndDragable.h"
#import "MSWeekViewDecoratorChangeDuration.h"
#import "NSDate+Easy.h"
#import "MSWeekViewDecoratorDragable.h"

@implementation MSWeekViewDecoratorChangeDurationAndDragable

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id)delegate{
    MSWeekViewDecoratorChangeDurationAndDragable * weekViewDecorator   = [super makeWith:weekView];
    weekViewDecorator.changeDurationDelegate          = delegate;
    weekViewDecorator.dragDelegate                    = delegate;
    return weekViewDecorator;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSEventCell *cell                   = (MSEventCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];

    if (! [self isGestureAlreadyAdded:cell]){
        UILongPressGestureRecognizer* lpgr  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onEventCellLongPress:)];
        lpgr.delegate                       = self;
        [cell addGestureRecognizer:lpgr];
    }

    return cell;
}

- (void)onEventCellLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    MSEventCell* eventCell = (MSEventCell*)gestureRecognizer.view;
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self startDrag:eventCell touchOffset:[gestureRecognizer locationInView:gestureRecognizer.view]];
        [self addChangeDurationIndicators:mDragableEvent];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        [self dragEvent:gestureRecognizer];

    }

    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        //NSLog(@"Long press ended: %@",eventCell.akEvent.title);
        [self onDragEnded:eventCell];
    }
}

-(void)startDrag:(MSEventCell*)eventCell touchOffset:(CGPoint)touchOffset{
    NSLog(@"Star drag: %@", eventCell.event.title);
    mDragableEvent = [MSDragableEvent makeWithEventCell:eventCell andOffset:self.weekView.collectionView.contentOffset touchOffset:touchOffset];
    [self.baseWeekView addSubview:mDragableEvent];
}

- (void)dragEvent:(UILongPressGestureRecognizer *)gestureRecognizer {
    CGPoint cp = [gestureRecognizer locationInView:self.baseWeekView];

    CGPoint newOrigin;
    float xOffset   = ((int) self.collectionView.contentOffset.x % (int) self.weekFlowLayout.sectionWidth) - self.weekFlowLayout.timeRowHeaderWidth;
    cp.x           += xOffset;
    float x         = [self round:cp.x toLowest:self.weekFlowLayout.sectionWidth] - xOffset;
    newOrigin       = CGPointMake(x, cp.y);
    newOrigin       = CGPointMake(newOrigin.x /*+ mDragableEvent.touchOffset.x*/,
            newOrigin.y - mDragableEvent.touchOffset.y);

    [UIView animateWithDuration:0.1 animations:^{
        mDragableEvent.frame = (CGRect) { .origin = newOrigin, .size = mDragableEvent.frame.size };
    }];

    NSDate* date                  = [self dateForDragable];
    mDragableEvent.timeLabel.text = [date format:@"HH:mm" timezone:@"device"];
}

-(void)onDragEnded:(MSEventCell*)eventCell{
    NSDate* newStartDate = [self dateForDragable];
    if ([self canMoveToNewDate:eventCell.event newDate:newStartDate]){
        int duration = eventCell.event.durationInSeconds;
        eventCell.event.StartDate = newStartDate;
        eventCell.event.EndDate = [eventCell.event.StartDate dateByAddingSeconds:duration];
        [self.baseWeekView forceReload:YES];
        if (self.dragDelegate){
            [self.dragDelegate weekView:self.baseWeekView event:eventCell.event moved:newStartDate];
        }
    }

    [mDragableEvent removeFromSuperview];
    mDragableEvent = nil;
    [self readdChangeDurationIndicators:eventCell.event];
}

- (void)readdChangeDurationIndicators:(MSEvent *)event {
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        MSEventCell* cell = [self cellForEvent:event];
        [cell setSelected:YES];
        [self addChangeDurationIndicators:cell];
    });
}


- (void)addChangeDurationIndicators:(MSEventCell*)cell{
    mStartY         = cell.frame.origin.y;
    mStartHeight    = cell.frame.size.height;
    mStartIndicator = [MSDurationChangeIndicator makeForStartWithCell:cell andDelegate:self];
    mEndIndicator   = [MSDurationChangeIndicator makeForEndWithCell:cell andDelegate:self];
}

-(NSDate*)dateForDragable{
    CGPoint dropPoint = CGPointMake(mDragableEvent.frame.origin.x + mDragableEvent.touchOffset.x, mDragableEvent.frame.origin.y);
    return [self dateForPoint:dropPoint];
}

-(BOOL)canMoveToNewDate:(MSEvent*)event newDate:(NSDate*)newDate{
    if (! self.dragDelegate) return true;
    return [self.dragDelegate weekView:self canMoveEvent:event to:newDate];
}
//=========================================================
#pragma mark - On indicators dragged
//=========================================================
-(void)durationIndicatorStartUpdated:(MSDurationChangeIndicator*)sender y:(int)y{
    sender.eventCell.frame = CGRectMake(
            sender.eventCell.frame.origin.x,
            sender.eventCell.frame.origin.y + y,
            sender.eventCell.frame.size.width,
            sender.eventCell.frame.size.height - y);
    [mEndIndicator updatePosition];
    mStartIndicator.timeLabel.text = [[self startDateFor:sender.eventCell] format:@"HH:mm" timezone:@"device"];
}

-(void)durationIndicatorEndUpdated:(MSDurationChangeIndicator*)sender y:(int)y{
    sender.eventCell.frame = CGRectMake(
            sender.eventCell.frame.origin.x,
            sender.eventCell.frame.origin.y,
            sender.eventCell.frame.size.width,
            y);

    mEndIndicator.timeLabel.text = [[self endDateFor:sender.eventCell] format:@"HH:mm" timezone:@"device"];
}

-(void)durationIndicatorEnded:(MSDurationChangeIndicator*)sender{
    NSDate* startDate = [self startDateFor:sender.eventCell];
    NSDate* endDate   = [self endDateFor:sender.eventCell];

    if([self canChangeDuration:sender.eventCell.event startDate:startDate endDate:endDate]){
        sender.eventCell.event.StartDate = startDate;
        sender.eventCell.event.EndDate   = endDate;
        if (self.changeDurationDelegate){
            [self.changeDurationDelegate weekView:self.weekView event:sender.eventCell.event durationChanged:startDate endDate:endDate];
        }
    }
    [self.baseWeekView forceReload:YES];
    [self readdChangeDurationIndicators:sender.eventCell.event];
}

-(NSDate*)startDateFor:(MSEventCell*)eventCell{
    return [self dateForPoint:CGPointMake(
            eventCell.frame.origin.x - self.collectionView.contentOffset.x + 5,
            eventCell.frame.origin.y - self.collectionView.contentOffset.y)];
}

-(NSDate*)endDateFor:(MSEventCell*)eventCell{
    return [self dateForPoint:CGPointMake(
            eventCell.frame.origin.x - self.collectionView.contentOffset.x + 5,
            eventCell.frame.origin.y - self.collectionView.contentOffset.y + eventCell.frame.size.height )];
}

//=========================================================
#pragma mark - Can move to new date?
//=========================================================
-(BOOL)canChangeDuration:(MSEvent*)event startDate:(NSDate*)startDate endDate:(NSDate*)endDate{
    if (! self.changeDurationDelegate) return true;
    return [self.changeDurationDelegate weekView:self canChangeDuration:event startDate:startDate endDate:endDate];
}

//=========================================================
#pragma mark - Indicator stop dragged
//=========================================================
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer  shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer  *)otherGestureRecognizer
{
    return otherGestureRecognizer.view == gestureRecognizer.view;
}
@end