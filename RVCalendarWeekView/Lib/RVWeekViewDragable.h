//
//  RVWeekViewDragable.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 23/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "RVWeekView.h"
#import "AKEvent.h"

@protocol RVWeekViewDragableDelegate <NSObject>

-(BOOL)RVWeekView:(RVWeekView*)weekView canMoveEvent:(AKEvent*)event to:(NSDate*)date;

-(void)RVWeekView:(RVWeekView*)weekView event:(AKEvent*)event moved:(NSDate*)date;

@end

@interface RVWeekViewDragable : RVWeekView

@property(weak,nonatomic) id<RVWeekViewDragableDelegate> dragDelegate;

@end
