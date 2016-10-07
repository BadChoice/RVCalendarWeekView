//
//  MSWeekViewDecoratorFactory.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorFactory.h"


@implementation MSWeekViewDecoratorFactory

+(MSWeekView*)make:(MSWeekView*)baseView features:(NSUInteger)features andDelegate:(id)delegate{
    
    MSWeekView* decoratedView = baseView;
    

    
    if ( (features & MSInfiniteFeature) != 0 ){ // => true
        decoratedView = [MSWeekViewDecoratorInfinite makeWith:decoratedView andDelegate:delegate];
    }
    
    if ( (features & MSNewEventFeature) != 0 ){ // => true
        decoratedView = [MSWeekViewDecoratorNewEvent makeWith:decoratedView andDelegate:delegate shortPress:NO];
    }
    
    if ( (features & MSDragableEventFeature) != 0 ){ // => true
        decoratedView = [MSWeekViewDecoratorDragable makeWith:decoratedView andDelegate:delegate];
    }
    
    if ( (features & MSPinchableFeature) != 0 ){    // => true
        decoratedView = [MSWeekViewDecoratorPinchable makeWith:decoratedView];
    }
    
    if ( (features & MSShortPressNewEventFeature) != 0 ){    // => true
        decoratedView = [MSWeekViewDecoratorNewEvent makeWith:decoratedView andDelegate:delegate shortPress:YES];
    }
    
    if ( (features & MSChangeDurationFeature) != 0 ){    // => true
        decoratedView = [MSWeekViewDecoratorChangeDuration makeWith:decoratedView andDelegate:delegate];
    }
    
    return decoratedView;
}

+(void)setMinutesPrecisionToAllDecorators:(MSWeekView*)weekViewWithDecorators minutesPrecision:(int)minutesPrecision{
    
    if([weekViewWithDecorators isKindOfClass:MSWeekViewDecorator.class]){
        MSWeekViewDecorator* decorator = (MSWeekViewDecorator*)weekViewWithDecorators;
        decorator.minutesPrecision= minutesPrecision;
        [self.class setMinutesPrecisionToAllDecorators:decorator.weekView minutesPrecision:minutesPrecision];
    }
}

@end
