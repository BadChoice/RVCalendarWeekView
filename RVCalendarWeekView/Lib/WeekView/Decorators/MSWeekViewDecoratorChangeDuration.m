//
//  MSWeekViewDecoratorChangeDuration.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 7/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorChangeDuration.h"
#import "MSEventCell.h"
#import "RVCollection.h"
#import "NSDate+Easy.h"

@interface MSWeekViewDecoratorChangeDuration () <UIGestureRecognizerDelegate>

@end

@implementation MSWeekViewDecoratorChangeDuration

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewChangeDurationDelegate>)delegate{
    MSWeekViewDecoratorChangeDuration * weekViewDecorator   = [super makeWith:weekView];
    weekViewDecorator.changeDurationDelegate                = delegate;
    return weekViewDecorator;
}

//=========================================================
#pragma mark - Add long press gesture recognizer
//=========================================================
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MSEventCell *cell                   = (MSEventCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    if (! [self isGestureAlreadyAdded:cell]) {
        UILongPressGestureRecognizer* lpgr  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onEventCellLongPress:)];
        lpgr.minimumPressDuration = 0.2;
        lpgr.delegate             = self;
        [cell addGestureRecognizer:lpgr];
    }
    
    return cell;
}

-(void)onEventCellLongPress:(UIGestureRecognizer*)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan){
        NSLog(@"Change Duration start");
        MSEventCell* cell   = (MSEventCell*)gestureRecognizer.view;
        [self addDurationIndicators:cell];
    }
}

- (void)addDurationIndicators:(MSEventCell *)cell {
    mStartY = cell.frame.origin.y;
    mStartHeight = cell.frame.size.height;
    mStartIndicator = [MSDurationChangeIndicator makeForStartWithCell:cell andDelegate:self];
    mEndIndicator = [MSDurationChangeIndicator makeForEndWithCell:cell andDelegate:self];
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
        if(self.changeDurationDelegate){
            [self.changeDurationDelegate weekView:self.weekView event:sender.eventCell.event durationChanged:startDate endDate:endDate];
        }
    }
    [self.baseWeekView forceReload:YES];
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
