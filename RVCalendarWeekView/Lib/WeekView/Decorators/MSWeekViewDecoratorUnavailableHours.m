//
//  MSWeekViewDecoratorUnavailableHours.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 4/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorUnavailableHours.h"

@implementation MSWeekViewDecoratorUnavailableHours

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewDecoratorUnavailableHoursDelegate>)delegate{
    MSWeekViewDecoratorUnavailableHours * weekViewDecorator = [super makeWith:weekView];
    weekViewDecorator.unavailableHoursDelegate              = delegate;
    return weekViewDecorator;
}




@end
