//
//  MSWeekViewDecoratorInfinite.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorInfinite.h"

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
    NSLog(@"Scroll at infinite");
    [super scrollViewDidScroll:scrollView];
    
    return;
    //[super scrollViewDidScroll:scrollView];
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    NSLog(@"Load more!");
    // Change 10.0 to adjust the distance from bottom
    if (maximumOffset - currentOffset <= 10.0 /*&& !mLoading && mShouldLoadMore*/) {
        //[self methodThatAddsDataAndReloadsTableView];
        NSLog(@"Load more if necessary");
        //[self loadNextOrdersForDate:mCurrentDate];
    }
}


@end
