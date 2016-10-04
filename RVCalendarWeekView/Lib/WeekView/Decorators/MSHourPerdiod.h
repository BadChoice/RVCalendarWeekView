//
//  MSHourPerdiod.h
//  RVCalendarWeekView
//
//  Created by Badchoice on 4/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSHourPerdiod : NSObject{
    NSNumber *mDuration;
    NSNumber *mStartHour;
    NSNumber *mStartTimeWithPercentage;
}

@property(strong, nonatomic) NSString* start;
@property(strong, nonatomic) NSString* end;


/**
 * Create with time strings like @"9:99" ,@"18:25"..
 */
+(MSHourPerdiod*)make:(NSString*)start end:(NSString*)end;

-(int)startHour;
-(int)startMinute;
-(float)duration;
-(float)startTimeWithMinutesPercentage;


@end
