//
//  MSWeekViewDecoratorUnavailableHours.h
//  RVCalendarWeekView
//
//  Created by Badchoice on 4/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecorator.h"

@protocol MSWeekViewDecoratorUnavailableHoursDelegate <NSObject>
/**
 Should return an array of DTTimePeriod
 */
-(NSArray*)weekView:(MSWeekView*)weekView unavailableHoursFor:(NSDate*)date;
@end

@interface MSWeekViewDecoratorUnavailableHours : MSWeekViewDecorator

@property (weak, nonatomic) id<MSWeekViewDecoratorUnavailableHoursDelegate> unavailableHoursDelegate;


+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewDecoratorUnavailableHoursDelegate>)delegate;

@end
