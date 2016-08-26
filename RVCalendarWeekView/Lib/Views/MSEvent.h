//
//  AKEvent.h
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTTimePeriod.h"

@interface MSEvent : DTTimePeriod

@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *location;

+(MSEvent*)make:(NSDate*)start title:(NSString*)title location:(NSString*)location;
+(MSEvent*)make:(NSDate*)start end:(NSDate*)end title:(NSString*)title location:(NSString*)location;

+(MSEvent*)make:(NSDate*)start duration:(int)minutes title:(NSString*)title location:(NSString*)location;

- (NSDate *)day;

@end