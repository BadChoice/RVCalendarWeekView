//
//  AKEvent.m
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import "AKEvent.h"

@implementation AKEvent


- (NSDate *)day
{
    return [[NSCalendar currentCalendar] startOfDayForDate:self.start];
}
@end