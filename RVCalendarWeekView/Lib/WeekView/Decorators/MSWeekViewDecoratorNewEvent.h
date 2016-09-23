//
//  MSWeekViewDecoratorNewEvent.h
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecorator.h"

@protocol MSWeekViewNewEventDelegate <NSObject>
@optional
-(void)weekView:(MSWeekView*)weekView onLongPressAt:(NSDate*)date;
-(void)weekView:(MSWeekView*)weekView onTapAt:(NSDate*)date;
@end

@interface MSWeekViewDecoratorNewEvent : MSWeekViewDecorator

@property(weak,nonatomic) id<MSWeekViewNewEventDelegate> createEventDelegate;
@property(nonatomic) BOOL shortPress;

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewNewEventDelegate>)delegate shortPress:(BOOL)shortPress;
@end
