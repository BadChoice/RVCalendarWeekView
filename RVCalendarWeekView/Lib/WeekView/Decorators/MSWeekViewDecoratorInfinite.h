//
//  MSWeekViewDecoratorInfinite.h
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecorator.h"


@protocol MSWeekViewInfiniteDelegate <NSObject>
-(void)MSWeekView:(MSWeekView*)weekView newDaysLoaded:(NSDate*)startDate to:(NSDate*)endDate;
@end

@interface MSWeekViewDecoratorInfinite : MSWeekViewDecorator{
    BOOL mLoading;
}

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewInfiniteDelegate>)delegate;

@property(weak,nonatomic) id<MSWeekViewInfiniteDelegate> infiniteDelegate;

@end
