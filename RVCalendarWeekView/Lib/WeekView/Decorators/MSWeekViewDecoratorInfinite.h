//
//  MSWeekViewDecoratorInfinite.h
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecorator.h"


@protocol MSWeekViewInfiniteDelegate <NSObject>

/**
 * Return YES if new events are added, or NO if not to improve performance
 */
-(BOOL)weekView:(MSWeekView*)weekView newDaysLoaded:(NSDate*)startDate to:(NSDate*)endDate;
@end

@interface MSWeekViewDecoratorInfinite : MSWeekViewDecorator{
    BOOL mLoading;
}

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewInfiniteDelegate>)delegate;

@property(weak,nonatomic) id<MSWeekViewInfiniteDelegate> infiniteDelegate;

@end
