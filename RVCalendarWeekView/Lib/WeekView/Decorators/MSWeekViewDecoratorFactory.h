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


typedef NS_OPTIONS(NSUInteger, MSWeekViewFeatures) {
    MSDragableEventFeature  = (1 << 0), // => 00000001
    MSNewEventFeature       = (1 << 1), // => 00000010
    MSInfiniteFeature       = (1 << 2)  // => 00000100
};

@interface MSWeekViewDecoratorFactory : NSObject


/**
 * This adds the decorations to the baseView
 * Using this constructor the delegate should implement all the protocols fore each feature defined in `features`
 */
+(MSWeekView*)make:(MSWeekView*)baseView features:(NSInteger)features andDelegate:(id)delegate;

@end
