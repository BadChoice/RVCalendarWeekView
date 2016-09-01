//
//  MSWeekViewDecoratorInfinite.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorInfinite.h"

@interface MSWeekView()
-(void)groupEventsByDays;
@end

@implementation MSWeekViewDecoratorInfinite


+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView{
    MSWeekViewDecoratorInfinite * weekViewDecorator = [super makeWith:weekView];
    return weekViewDecorator;
}

//======================================================
#pragma mark - INFINITE SCROLL
//======================================================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];

    NSInteger currentOffset = scrollView.contentOffset.x;
    NSInteger maximumOffset = scrollView.contentSize.width - scrollView.frame.size.width;
    
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0 && !mLoading /*&& mShouldLoadMore*/) {
        //[self methodThatAddsDataAndReloadsTableView];
        NSLog(@"Load more if necessary");
        [self loadNextDays];
        //[self loadNextOrdersForDate:mCurrentDate];
    }
}

-(void)loadNextDays{
    mLoading = true;
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.baseWeekView.daysToShow += self.baseWeekView.daysToShow;
        [self.baseWeekView groupEventsByDays];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.baseWeekView forceReload];
        });
        mLoading = false;
    });    
}


@end
