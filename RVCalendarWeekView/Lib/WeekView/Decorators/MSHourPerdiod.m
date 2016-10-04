//
//  MSHourPerdiod.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 4/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSHourPerdiod.h"

@implementation MSHourPerdiod

+(MSHourPerdiod*)make:(NSString*)start end:(NSString*)end{
    MSHourPerdiod* hourPerdiod = [[self.class alloc] init];
    hourPerdiod.start   = start;
    hourPerdiod.end     = end;
    return hourPerdiod;
}
@end
