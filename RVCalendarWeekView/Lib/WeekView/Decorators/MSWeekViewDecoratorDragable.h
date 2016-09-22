//
//  MSWeekViewDecoratorDragable.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecorator.h"
#import "MSDragableEvent.h"

@protocol MSWeekViewDragableDelegate <NSObject>
-(BOOL)weekView:(MSWeekView*)weekView canMoveEvent:(MSEvent*)event to:(NSDate*)date;
-(void)weekView:(MSWeekView*)weekView event:(MSEvent*)event moved:(NSDate*)date;
@end


@interface MSWeekViewDecoratorDragable : MSWeekViewDecorator{    
    MSDragableEvent     * mDragableEvent;
}

@property(weak,nonatomic) id<MSWeekViewDragableDelegate> dragDelegate;

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewDragableDelegate>)delegate;

@end
