//
//  MSHourPerdiod.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 4/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSHourPerdiod.h"
#import "NSString+Collection.h"

@implementation MSHourPerdiod

+(MSHourPerdiod*)make:(NSString*)start end:(NSString*)end{
    MSHourPerdiod* hourPerdiod  = [self.class new];
    hourPerdiod.start           = start;
    hourPerdiod.end             = end;
    return hourPerdiod;
}

-(int)startHour{
    if(!mStartHour){
        mStartHour = @([[self.start explode:@":"].firstObject intValue]);
    }
    return mStartHour.intValue;
}

-(int)endHour{
    return [[self.end explode:@":"].firstObject intValue];
}

-(int)startMinute{
    return [[self.start explode:@":"].lastObject intValue];
}

-(int)endMinute{
    return [[self.start explode:@":"].lastObject intValue];
}

-(float)startTimeWithMinutesPercentage{
    if(!mStartTimeWithPercentage){
        int hour = self.startHour;
        float percentage = self.startMinute / 60.f;
        mStartTimeWithPercentage = @( hour + percentage );
    }
    return mStartTimeWithPercentage.floatValue;
}

-(float)duration{
    if(!mDuration){
        float endTimeInMinutes   = self.endHour     * 60 + self.endMinute;
        float startTimeInMinutes = self.startHour   * 60 + self.startMinute;
        mDuration = @((endTimeInMinutes - startTimeInMinutes) / 60);
    }
    return mDuration.floatValue;
}
@end
