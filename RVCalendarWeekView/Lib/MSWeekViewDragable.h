//
//  RVWeekViewDragable.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 23/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekView.h"
#import "MSEvent.h"

@protocol MSWeekViewDragableDelegate <NSObject>

-(BOOL)MSWeekView:(MSWeekView*)weekView canMoveEvent:(MSEvent*)event to:(NSDate*)date;
-(void)MSWeekView:(MSWeekView*)weekView event:(MSEvent*)event moved:(NSDate*)date;
-(void)MSWeekView:(MSWeekView*)weekView onLongPressAt:(NSDate*)date;

@end

@interface MSWeekViewDragable : MSWeekView{
    MSDragableEvent     * mDragableEvent;
}

@property(weak,nonatomic) id<MSWeekViewDragableDelegate> dragDelegate;

@end
