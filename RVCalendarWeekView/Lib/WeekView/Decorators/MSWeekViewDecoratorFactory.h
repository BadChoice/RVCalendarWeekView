//
//  MSWeekViewDecoratorFactory.h
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSWeekViewDecoratorDragable.h"
#import "MSWeekViewDecoratorNewEvent.h"
#import "MSWeekViewDecoratorInfinite.h"
#import "MSWeekViewDecoratorPinchable.h"
#import "MSWeekViewDecoratorChangeDuration.h"


typedef NS_OPTIONS(NSUInteger, MSWeekViewFeatures) {
    MSDragableEventFeature          = (1 << 0), // => 00000001
    MSNewEventFeature               = (1 << 1), // => 00000010
    MSInfiniteFeature               = (1 << 2), // => 00000100
    MSPinchableFeature              = (1 << 3), // => 00001000
    MSShortPressNewEventFeature     = (1 << 4), // => 00010000
    MSChangeDurationFeature       = (1 << 5), // => 00100000
};

@interface MSWeekViewDecoratorFactory : NSObject


/**
 * This adds the decorations to the baseView
 * Using this constructor the delegate should implement all the protocols fore each feature defined in `features`
 */
+(MSWeekView*)make:(MSWeekView*)baseView features:(NSUInteger)features andDelegate:(id)delegate;


/**
 * Recursive function to set minutesPrecision to all decorators 
 */
+(void)setMinutesPrecisionToAllDecorators:(MSWeekView*)weekViewWithDecorators minutesPrecision:(int)minutesPrecision;
@end
