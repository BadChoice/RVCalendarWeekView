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
        CGPoint cp = [gestureRecognizer locationInView:self.baseWeekView];
        
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
    
    if([self canMoveToNewDate:eventCell.event newDate:newStartDate]){
        int duration = eventCell.event.durationInSeconds;
        eventCell.event.StartDate = newStartDate;
        eventCell.event.EndDate = [eventCell.event.StartDate dateByAddingSeconds:duration];
        [self.baseWeekView forceReload:YES];
        if(self.dragDelegate){
            [self.dragDelegate weekView:self.baseWeekView event:eventCell.event moved:newStartDate];
        }
    }
    
    [mDragableEvent removeFromSuperview];
    mDragableEvent = nil;
}


-(NSDate*)dateForDragable{
    return [self dateForPoint:mDragableEvent.frame.origin];
}

//=========================================================
#pragma mark - Can move to new date?
//=========================================================
-(BOOL)canMoveToNewDate:(MSEvent*)event newDate:(NSDate*)newDate{
    if (! self.dragDelegate) return true;
    return [self.dragDelegate weekView:self canMoveEvent:event to:newDate];
}

-(BOOL)isPortrait{
    return (UIDevice.currentDevice.orientation == UIDeviceOrientationPortrait || UIDevice.currentDevice.orientation == UIDeviceOrientationFaceUp);
}


@end
