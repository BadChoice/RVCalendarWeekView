//
//  RVWeekView.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDragable.h"

#import "NSDate+Easy.h"
#import "RVCollection.h"
#import "NSDate+DateTools.h"

#define MAS_SHORTHAND
#import "Masonry.h"


// Collection View Reusable Views
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"

#define MSEventCellReuseIdentifier        @"MSEventCellReuseIdentifier"
#define MSDayColumnHeaderReuseIdentifier  @"MSDayColumnHeaderReuseIdentifier"
#define MSTimeRowHeaderReuseIdentifier    @"MSTimeRowHeaderReuseIdentifier"


// To call private super setup
@interface MSWeekView ()
- (void) setup;
@end


@implementation MSWeekViewDragable

-(void)setup{
    [super setup];
    
    UIGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [lpgr setCancelsTouchesInView:NO];  //To didSelectCell still works
    [self.collectionView addGestureRecognizer:lpgr];
}

-(void)onLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint cp          = [gestureRecognizer locationInView:self.collectionView];
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
        mDragableEvent = [MSDragableEvent makeWithEventCell:eventCell andOffset:self.collectionView.contentOffset];
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
    NSDate* firstDay = [self.weekFlowLayout dateForDayColumnHeaderAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSDate* date = [firstDay addDays    :[self getDayIndexForX:point.x] ];
    date         = [date withHour       :[self getHourForY    :point.y] timezone:@"device"];
    date         = [date withMinute     :[self getMinuteForY  :point.y] ];
    return date;
}

-(int)getHourForY:(float)y{
    int earliestHour    = self.weekFlowLayout.earliestHour;
    int hour            = y/self.weekFlowLayout.hourHeight - 1;
    return hour + earliestHour;
}

-(int)getMinuteForY:(float)y{
    int hours          = (y / self.weekFlowLayout.hourHeight);
    int minute         = (y / self.weekFlowLayout.hourHeight - hours ) * 60;    
    int minuteRounded  = [self round:minute toNearest:5];
    return minuteRounded == 60 ? 55 : minuteRounded;
}

-(int)getDayIndexForX:(float)x{
    return x / self.weekFlowLayout.sectionWidth;
}

-(NSDate*)dateForDragable{
    CGPoint point = CGPointMake(mDragableEvent.frame.origin.x + self.collectionView.contentOffset.x,
                                mDragableEvent.frame.origin.y + self.collectionView.contentOffset.y - 30);  //Why 60?
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
