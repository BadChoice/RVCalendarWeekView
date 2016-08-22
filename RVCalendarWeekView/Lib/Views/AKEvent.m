//
//  AKEvent.m
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import "AKEvent.h"
#import "NSDate+Easy.h"

@implementation AKEvent

+(AKEvent*)make:(NSDate*)start title:(NSString*)title location:(NSString*)location{
    return [self.class make:start duration:60 title:title location:location];
}

+(AKEvent*)make:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location{
    AKEvent* event = [AKEvent new];
    event.StartDate = start;
    event.EndDate   = end;
    event.title     = title;
    event.location  = location;
    return event;
}

+(AKEvent*)make:(NSDate*)start duration:(int)minutes title:(NSString*)title location:(NSString*)location{
    AKEvent* event  = [AKEvent new];
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