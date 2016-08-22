//
//  RVWeekView.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "RVWeekView.h"

// Collection View Reusable Views
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"

#define MSEventCellReuseIdentifier        @"MSEventCellReuseIdentifier"
#define MSDayColumnHeaderReuseIdentifier  @"MSDayColumnHeaderReuseIdentifier"
#define MSTimeRowHeaderReuseIdentifier    @"MSTimeRowHeaderReuseIdentifier"

@implementation RVWeekView

//================================================
#pragma mark - Init
//================================================
-(id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    
    self.weekFlowLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.weekFlowLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.weekFlowLayout];
    self.collectionView.dataSource = self;
    [self addSubview:self.collectionView];
    
        
    self.weekFlowLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    
    self.weekFlowLayout.sectionWidth = self.layoutSectionWidth;
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.weekFlowLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.weekFlowLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.weekFlowLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.weekFlowLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.weekFlowLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.weekFlowLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
    
    //[self loadData];
}

- (CGFloat)layoutSectionWidth
{
    // Default to 254 on iPad.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 254.0;
    }
    
    // Otherwise, on iPhone, fit-to-width.
    CGFloat width               = CGRectGetWidth(self.collectionView.bounds);
    CGFloat timeRowHeaderWidth  = self.weekFlowLayout.timeRowHeaderWidth;
    CGFloat rightMargin         = self.weekFlowLayout.contentMargin.right;
    
    return (width - timeRowHeaderWidth - rightMargin);
}


//================================================
#pragma mark - CollectionView Datasource
//================================================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.days.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AKSection *sect = [self.days objectAtIndex:section];
    return sect.events.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    
    AKSection *sect = [self.days objectAtIndex:indexPath.section];
    AKEvent *ev = [sect.events objectAtIndex:indexPath.row];
    cell.akEvent = ev;
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.weekFlowLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.weekFlowLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.weekFlowLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}


//================================================
#pragma mark - Week Flow Delegate
//================================================
- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    AKSection *sect = [self.days objectAtIndex:section];
    AKEvent *ev     = [sect.events firstObject];
    return ev.day;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AKSection *sect = [self.days objectAtIndex:indexPath.section];
    AKEvent *ev     = [sect.events objectAtIndex:indexPath.row];
    return ev.start;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AKSection *sect = [self.days objectAtIndex:indexPath.section];
    AKEvent *ev     = [sect.events objectAtIndex:indexPath.row];
    return [ev.start dateByAddingTimeInterval:(60 * 60 * 3)];
    return nil;
    
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout
{
    return NSDate.date;
}

//================================================
#pragma mark - Dealloc
//================================================
-(void)dealloc{
    self.collectionView.dataSource  = nil;
    self.collectionView.delegate    = nil;
    self.collectionView             = nil;
    self.weekFlowLayout.delegate    = nil;
    self.weekFlowLayout             = nil;
    self.days                       = nil;
}

@end
