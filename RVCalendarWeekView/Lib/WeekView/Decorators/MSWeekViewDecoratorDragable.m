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

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewDragableDelegate>)delegate{
    MSWeekViewDecoratorDragable * weekViewDecorator = [super makeWith:weekView];
    weekViewDecorator.dragDelegate = delegate;
    return weekViewDecorator;
}

//=========================================================
#pragma mark - Collection view datasource
//=========================================================
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell         = (MSEventCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    UIGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onEventCellLongPress:)];
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

//=========================================================
#pragma mark - Drag & Drop
//=========================================================
-(void)onEventCellLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    MSEventCell* eventCell = (MSEventCell*)gestureRecognizer.view;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        //NSLog(@"Long press began: %@",eventCell.akEvent.title);
        mDragableEvent = [MSDragableEvent makeWithEventCell:eventCell andOffset:self.weekView.collectionView.contentOffset];
        [self.baseWeekView addSubview:mDragableEvent];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint cp = [gestureRecognizer locationInView:self.collectionView];
        
        [UIView animateWithDuration:0.1 animations:^{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                float xOffset = -13;
                if([self isPortrait]){
                    xOffset = 5;
                }
                float x = [self round:cp.x toNearest:self.weekFlowLayout.sectionWidth] + xOffset
                - ((int)self.collectionView.contentOffset.x % (int)self.weekFlowLayout.sectionWidth);
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

-(void)onDragEnded:(MSEventCell*)eventCell{
    
    NSDate* newStartDate = [self dateForDragable];
    
    if([self canMoveToNewDate:eventCell.akEvent newDate:newStartDate]){
        int duration = eventCell.akEvent.durationInSeconds;
        eventCell.akEvent.StartDate = newStartDate;
        eventCell.akEvent.EndDate = [eventCell.akEvent.StartDate dateByAddingSeconds:duration];
        [self.baseWeekView forceReload:YES];
        if(self.dragDelegate){
            [self.dragDelegate MSWeekView:self.baseWeekView event:eventCell.akEvent moved:newStartDate];
        }
    }
    
    [mDragableEvent removeFromSuperview];
    mDragableEvent = nil;
}


-(NSDate*)dateForDragable{
    CGPoint point = CGPointMake(mDragableEvent.frame.origin.x + self.collectionView.contentOffset.x,
                                mDragableEvent.frame.origin.y + self.collectionView.contentOffset.y - self.weekFlowLayout.dayColumnHeaderHeight - 20);  //5 is the section margin
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


@end
