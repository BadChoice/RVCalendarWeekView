//
//  AKEvent.m
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import "MSEvent.h"
#import "NSDate+Easy.h"

@implementation MSEvent

+(MSEvent*)make:(NSDate*)start title:(NSString*)title location:(NSString*)location{
    return [self.class make:start duration:60 title:title location:location];
}

+(MSEvent*)make:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location{
    MSEvent* event = [MSEvent new];
    event.StartDate = start;
    event.EndDate   = end;
    event.title     = title;
    event.location  = location;
    return event;
}

+(MSEvent*)make:(NSDate*)start duration:(int)minutes title:(NSString*)title location:(NSString*)location{
    MSEvent* event  = [MSEvent new];
    event.StartDate = start;
    event.EndDate   = [start addMinutes:minutes];
    event.title     = title;
    event.location  = location;
    return event;
}

- (NSDate *)day{
    return [[NSCalendar currentCalendar] startOfDayForDate:self.StartDate];
}
@end