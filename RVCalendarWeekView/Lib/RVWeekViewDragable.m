//
//  RVWeekView.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "RVWeekViewDragable.h"

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

@implementation RVWeekViewDragable


//================================================
#pragma mark - CollectionView Datasource
//================================================
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell   = (MSEventCell*)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    
    UIGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

//================================================
#pragma mark - Drag & Drop
//================================================
-(void)onLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    MSEventCell* eventCell = (MSEventCell*)gestureRecognizer.view;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        //NSLog(@"Long press began: %@",eventCell.akEvent.title);
        CGPoint offset   = self.collectionView.contentOffset;
        CGRect  newFrame = CGRectMake(eventCell.frame.origin.x - offset.x,
                                      eventCell.frame.origin.y - offset.y,
                                      eventCell.frame.size.width, eventCell.frame.size.height);
        
        mDragableEvent = [[MSDragableEvent alloc] initWithFrame:newFrame];
        mDragableEvent.backgroundColor = [eventCell backgroundColorHighlighted:YES];
        
        [self.superview.superview addSubview:mDragableEvent];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint cp = [gestureRecognizer locationInView:self.superview];
        
        
        //[mDragableEvent setCenter:CGPointMake([self round:cp.x + self.collectionView.contentOffset.x toNearest:self.weekFlowLayout.sectionWidth], cp.y)];
        
        [mDragableEvent setCenter:CGPointMake(cp.x, cp.y)];
        
        int hour        = [self getHourForDragable];
        int minute      = [self getMinuteForDragable];
        NSDate* date    = [[NSDate.today withHour:hour] withMinute:minute];
        mDragableEvent.timeLabel.text = [date format:@"HH:mm"];
        
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
    
    int hoursDiff = [self getHoursDiff:eventCell.akEvent newHour    :[self getHourForDragable]];
    int daysDiff  = [self getDaysDiff:eventCell.akEvent  newDayIndex:[self getDayIndexForDragable]];
    int minute    = [self getMinuteForDragable];
    
    /*NSLog(@"------------");
    NSLog(@"Date: %@", eventCell.akEvent.StartDate);
    NSLog(@"Days diff: %d",daysDiff);
    NSLog(@"HoursDiff: %d",hoursDiff);
    NSLog(@"Minute: %d",minute);*/
    
    NSDate* newStartDate = [[[eventCell.akEvent.StartDate addHours:hoursDiff] addDays:daysDiff] withMinute:minute];
    NSDate* newEndDate   = [[[eventCell.akEvent.EndDate   addHours:hoursDiff] addDays:daysDiff] withMinute:minute];
    
    if([self canMoveToNewDate:eventCell.akEvent newDate:newStartDate]){
        eventCell.akEvent.StartDate = newStartDate;
        eventCell.akEvent.EndDate   = newEndDate;
        [self forceReload];
        if(self.dragDelegate){
            [self.dragDelegate RVWeekView:self event:eventCell.akEvent moved:newStartDate];
        }
    }
    
    [mDragableEvent removeFromSuperview];
    mDragableEvent = nil;
}

-(int)getHourForDragable{
    int y               = mDragableEvent.frame.origin.y + self.collectionView.contentOffset.y - 40;
    int earliestHour    = self.weekFlowLayout.earliestHour;
    int hour            = y/self.weekFlowLayout.hourHeight - 1;
    return hour + earliestHour;
}

-(int)getMinuteForDragable{
    int y              = mDragableEvent.frame.origin.y + self.collectionView.contentOffset.y - 40;
    int hours          = (y / self.weekFlowLayout.hourHeight);
    return (y / self.weekFlowLayout.hourHeight - hours ) * 60;
}

-(int)getDayIndexForDragable{
    int x  = mDragableEvent.frame.origin.x + self.collectionView.contentOffset.x;
    return x / self.weekFlowLayout.sectionWidth;
}

-(int)getHoursDiff:(AKEvent*)event newHour:(int)newHour{
    int eventHour = event.StartDate.hour;
    return newHour - eventHour;
}

-(int)getDaysDiff:(AKEvent*)event newDayIndex:(int)newDayIndex{
    int __block eventDayOffset = 0;
    [mDays.allKeys.sort eachWithIndex:^(NSString* day, int index, BOOL *stop) {
        if([mDays[day] containsObject:event]){
            eventDayOffset = index;
            *stop = TRUE;
        }
    }];
    return newDayIndex - eventDayOffset;
}

-(BOOL)canMoveToNewDate:(AKEvent*)event newDate:(NSDate*)newDate{
    if (! self.dragDelegate) return true;
    return [self.dragDelegate RVWeekView:self canMoveEvent:event to:newDate];    
}


@end
