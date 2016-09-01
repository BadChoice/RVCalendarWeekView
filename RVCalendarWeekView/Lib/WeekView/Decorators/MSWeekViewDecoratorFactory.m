//
//  MSWeekViewDecoratorFactory.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorFactory.h"


@implementation MSWeekViewDecoratorFactory

+(MSWeekView*)make:(MSWeekView*)baseView features:(NSInteger)features andDelegate:(id)delegate{
    
    MSWeekView* decoratedView = baseView;
    

    
    if ( (features & MSInfiniteFeature) != 0 ){ // => true
        decoratedView = [MSWeekViewDecoratorInfinite makeWith:decoratedView andDelegate:delegate];
    }
    
    if ( (features & MSNewEventFeature) != 0 ){ // => true
        decoratedView = [MSWeekViewDecoratorNewEvent makeWith:decoratedView andDelegate:delegate];
    }
    
    if ( (features & MSDragableEventFeature) != 0 ){ // => true
        decoratedView = [MSWeekViewDecoratorDragable makeWith:decoratedView andDelegate:delegate];
    }

    
    return decoratedView;
}

@end
