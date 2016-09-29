//
//  MSWeekViewDecorator.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecorator.h"
#import "NSDate+Easy.h"
#import "NSDate+DateTools.h"

@implementation MSWeekViewDecorator

//=========================================================
#pragma mark - Init
//=========================================================
+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView{
    MSWeekViewDecorator* weekViewDecorator  = [self.class new];
    weekViewDecorator.weekView              = weekView;
    weekViewDecorator.minutesPrecision      = 5;
    weekView.collectionView.dataSource      = weekViewDecorator;
    weekView.collectionView.delegate        = weekViewDecorator;
    weekView.weekFlowLayout.delegate        = weekViewDecorator;
    [weekViewDecorator setup];
    return weekViewDecorator;
}

-(void)setup{
    
}

-(MSWeekView*)baseWeekView{
   if( [self.weekView isKindOfClass:MSWeekViewDecorator.class])
    return [(MSWeekViewDecorator*)self.weekView baseWeekView];
   else
    return self.weekView;
}

//=========================================================
#pragma mark - Get Overrides
//=========================================================
-(UICollectionView*)collectionView{
    return self.baseWeekView.collectionView;
}

-(MSCollectionViewCalendarLayout*)weekFlowLayout{
    return self.baseWeekView.weekFlowLayout;
}

//=========================================================
#pragma mark - Collection view datasource
//=========================================================
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_weekView collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_weekView collectionView:collectionView cellForItemAtIndexPath:indexPath];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_weekView numberOfSectionsInCollectionView:collectionView];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return [_weekView collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

//=========================================================
#pragma mark - Collection view delegate
//=========================================================
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [_weekView collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_weekView scrollViewDidScroll:scrollView];
}

//================================================
#pragma mark - Week Flow Delegate
//================================================
- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section{
    return [_weekView collectionView:collectionView layout:collectionViewCalendarLayout dayForSection:section];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_weekView collectionView:collectionView layout:collectionViewCalendarLayout startTimeForItemAtIndexPath:indexPath];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_weekView collectionView:collectionView layout:collectionViewCalendarLayout endTimeForItemAtIndexPath:indexPath];
}

//=========================================================
#pragma mark - Get XX for Point
//=========================================================
-(NSDate*)dateForPoint:(CGPoint)point{
    NSDate* firstDay = [self.baseWeekView firstDay];
    NSDate* date = [firstDay addDays    :[self getDayIndexForX:point.x] ];
    date         = [date withHour       :[self getHourForY    :point.y] timezone:@"device"];
    date         = [date withMinute     :[self getMinuteForY  :point.y] ];
    return date;
}

-(int)getHourForY:(float)y{
    y = [self viewYToContentY:y];
    int earliestHour    = (int)self.weekFlowLayout.earliestHour;
    int hour            = y/self.weekFlowLayout.hourHeight;
    return MAX(0, MIN(23, hour + earliestHour));
}

-(int)getMinuteForY:(float)y{
    y = [self viewYToContentY:y];
    int hours          = (y / self.weekFlowLayout.hourHeight);
    int minute         = (y / self.weekFlowLayout.hourHeight - hours ) * 60;
    int minuteRounded  = [self round:minute toNearest:self.minutesPrecision];
    return MAX(0, minuteRounded == 60 ? 60-self.minutesPrecision : minuteRounded);
}

-(int)getDayIndexForX:(float)x{
    x = [self viewXToContentX:x];
    return x / (self.weekFlowLayout.sectionMargin.left + self.weekFlowLayout.sectionWidth + self.weekFlowLayout.sectionMargin.right);
}

-(float)viewXToContentX:(float)x{
    return x - self.weekFlowLayout.timeRowHeaderWidth + self.collectionView.contentOffset.x - self.weekFlowLayout.contentMargin.left;
}

-(float)viewYToContentY:(float)y{
    return y - self.weekFlowLayout.dayColumnHeaderHeight + self.collectionView.contentOffset.y - self.weekFlowLayout.contentMargin.top - self.weekFlowLayout.sectionMargin.top;
}

-(CGFloat)round:(float)number toNearest:(float)pivot{
    return pivot * floor((number/pivot)+0.5);
}

-(CGFloat)round:(float)number toLowest:(float)pivot{
    return pivot * floor(number/pivot);
}

@end
