//
//  MSWeekViewDecoratorDragable.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorDragable.h"
#import "NSDate+Easy.h"
#import "RVCollection.h"
#import "NSDate+DateTools.h"

@implementation MSWeekViewDecoratorDragable


-(void)setup{
    [super setup];
    
    UIGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [lpgr setCancelsTouchesInView:NO];  //To didSelectCell still works
    [self.weekView.collectionView addGestureRecognizer:lpgr];
}

-(void)onLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint cp          = [gestureRecognizer locationInView:self.weekView.collectionView];
        CGPoint finalPoint  = CGPointMake(cp.x - 40, cp.y - 20); //Why 40 / 20?
        NSDate* date        = [self dateForPoint:finalPoint];
        
        if(date.minute > 15 && date.minute < 45)    date = [date withMinute:30];
        else if(date.minute > 45)                   date = [[date addHour] withMinute:0];
        else                                        date = [date withMinute:0];
        
        if(self.dragDelegate) [self.dragDelegate MSWeekView:self onLongPressAt:date];
    }
}

//================================================
#pragma mark - CollectionView Datasource
//================================================
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell         = (MSEventCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    UIGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onEventCellLongPress:)];
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

//================================================
#pragma mark - Drag & Drop
//================================================
-(void)onEventCellLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    MSEventCell* eventCell = (MSEventCell*)gestureRecognizer.view;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"Long press began: %@",eventCell.akEvent.title);
        mDragableEvent = [MSDragableEvent makeWithEventCell:eventCell andOffset:self.weekView.collectionView.contentOffset];
        [self.superview.superview addSubview:mDragableEvent];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint cp = [gestureRecognizer locationInView:self.superview];
        
        [UIView animateWithDuration:0.1 animations:^{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                float xOffset = -13;
                if([self isPortrait]){
                    xOffset = 5;
                }
                float x = [self round:cp.x toNearest:self.weekView.weekFlowLayout.sectionWidth] + xOffset
                - ((int)self.weekView.collectionView.contentOffset.x % (int)self.weekView.weekFlowLayout.sectionWidth);
                [mDragableEvent setCenter:CGPointMake(x, cp.y)];
            }
            else{
                [mDragableEvent setCenter:CGPointMake(cp.x, cp.y)];
            }
        }];
        
        NSDate* date = [self dateForDragable];
        mDragableEvent.timeLabel.text = [date format:@"HH:mm" timezone:@"device"];
        
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        //NSLog(@"Long press ended: %@",eventCell.akEvent.title);
        [self onDragEnded:eventCell];
    }
}

-(CGFloat)round:(float)number toNearest:(float)pivot{
    return pivot * floor((number/pivot)+0.5);
}

-(void)onDragEnded:(MSEventCell*)eventCell{
    
    NSDate* newStartDate = [self dateForDragable];
    
    if([self canMoveToNewDate:eventCell.akEvent newDate:newStartDate]){
        int duration = eventCell.akEvent.durationInSeconds;
        eventCell.akEvent.StartDate = newStartDate;
        eventCell.akEvent.EndDate = [eventCell.akEvent.StartDate dateByAddingSeconds:duration];
        [self forceReload];
        if(self.dragDelegate){
            [self.dragDelegate MSWeekView:self event:eventCell.akEvent moved:newStartDate];
        }
    }
    
    [mDragableEvent removeFromSuperview];
    mDragableEvent = nil;
}


//=========================================================
#pragma mark - Get XX for Point
//=========================================================
-(NSDate*)dateForPoint:(CGPoint)point{
    NSDate* firstDay = [self.weekView.weekFlowLayout dateForDayColumnHeaderAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDate* date = [firstDay addDays    :[self getDayIndexForX:point.x] ];
    date         = [date withHour       :[self getHourForY    :point.y] timezone:@"device"];
    date         = [date withMinute     :[self getMinuteForY  :point.y] ];
    return date;
}

-(int)getHourForY:(float)y{
    int earliestHour    = (int)self.weekView.weekFlowLayout.earliestHour;
    int hour            = y/self.weekView.weekFlowLayout.hourHeight - 1;
    return hour + earliestHour;
}

-(int)getMinuteForY:(float)y{
    int hours          = (y / self.weekView.weekFlowLayout.hourHeight);
    int minute         = (y / self.weekView.weekFlowLayout.hourHeight - hours ) * 60;
    int minuteRounded  = [self round:minute toNearest:5];
    return minuteRounded == 60 ? 55 : minuteRounded;
}

-(int)getDayIndexForX:(float)x{
    return x / self.weekView.weekFlowLayout.sectionWidth;
}

-(NSDate*)dateForDragable{
    CGPoint point = CGPointMake(mDragableEvent.frame.origin.x + self.weekView.collectionView.contentOffset.x,
                                mDragableEvent.frame.origin.y + self.weekView.collectionView.contentOffset.y - 30);  //Why 60?
    return [self dateForPoint:point];
}

//=========================================================
#pragma mark - Can move to new date?
//=========================================================
-(BOOL)canMoveToNewDate:(MSEvent*)event newDate:(NSDate*)newDate{
    if (! self.dragDelegate) return true;
    return [self.dragDelegate MSWeekView:self canMoveEvent:event to:newDate];
}

-(BOOL)isPortrait{
    return (UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait || UIDevice.currentDevice.orientation == UIDeviceOrientationFaceUp);
}


//======================================================
#pragma mark - INFINITE SCROLL
//======================================================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    NSLog(@"Load more!");
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0 /*&& !mLoading && mShouldLoadMore*/) {
        //[self methodThatAddsDataAndReloadsTableView];
        NSLog(@"Load more if necessary");
        //[self loadNextOrdersForDate:mCurrentDate];
    }
}


@end
