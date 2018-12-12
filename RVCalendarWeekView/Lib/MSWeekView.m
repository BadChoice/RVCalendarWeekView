//
//  RVWeekView.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekView.h"

#import "NSDate+Easy.h"
#import "RVCollection.h"

#define MAS_SHORTHAND
#import "Masonry.h"

// Collection View Reusable Views
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import "MSUnavailableHour.h"
#import "MSWeekendBackground.h"

#define MSEventCellReuseIdentifier        @"MSEventCellReuseIdentifier"
#define MSDayColumnHeaderReuseIdentifier  @"MSDayColumnHeaderReuseIdentifier"
#define MSTimeRowHeaderReuseIdentifier    @"MSTimeRowHeaderReuseIdentifier"

@implementation MSWeekView

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
    
    self.daysToShowOnScreen = 6;
    self.daysToShow         = 30;
    self.weekFlowLayout     = [MSCollectionViewCalendarLayout new];
    self.weekFlowLayout.delegate = self;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.weekFlowLayout];
    self.collectionView.dataSource                      = self;
    self.collectionView.delegate                        = self;
    self.collectionView.directionalLockEnabled          = YES;
    self.collectionView.showsVerticalScrollIndicator    = NO;
    self.collectionView.showsHorizontalScrollIndicator  = NO;
    /*if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.collectionView.pagingEnabled = YES;
    }*/
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
    }];
    
    self.weekFlowLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
    self.collectionView.backgroundColor   = [UIColor whiteColor];
    
    [self setupSupplementaryViewClasses];
    [self registerSupplementaryViewClasses];
}

-(void)setupSupplementaryViewClasses{
    self.eventCellClass                 = MSEventCell.class;
    self.dayColumnHeaderClass           = MSDayColumnHeader.class;
    self.timeRowHeaderClass             = MSTimeRowHeader.class;
    
    self.currentTimeIndicatorClass      = MSCurrentTimeIndicator.class;
    self.currentTimeGridlineClass       = MSCurrentTimeGridline.class;
    self.verticalGridlineClass          = MSGridline.class;
    self.horizontalGridlineClass        = MSGridline.class;
    self.timeRowHeaderBackgroundClass   = MSTimeRowHeaderBackground.class;
    self.dayColumnHeaderBackgroundClass = MSDayColumnHeaderBackground.class;
    self.unavailableHourClass           = MSUnavailableHour.class;
    self.weekendBackgroundClass         = MSWeekendBackground.class;
}

-(void)registerSupplementaryViewClasses{
    [self.collectionView registerClass:self.eventCellClass forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:self.dayColumnHeaderClass forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:self.timeRowHeaderClass forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.weekFlowLayout registerClass:self.currentTimeIndicatorClass       forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.weekFlowLayout registerClass:self.currentTimeGridlineClass        forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.weekFlowLayout registerClass:self.verticalGridlineClass           forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.weekFlowLayout registerClass:self.horizontalGridlineClass         forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.weekFlowLayout registerClass:self.timeRowHeaderBackgroundClass    forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.weekFlowLayout registerClass:self.dayColumnHeaderBackgroundClass  forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
    [self.weekFlowLayout registerClass:self.unavailableHourClass            forDecorationViewOfKind:MSCollectionElementKindUnavailableHour];
    [self.weekFlowLayout registerClass:self.weekendBackgroundClass          forDecorationViewOfKind:MSCollectionElementKindWeekendBackground];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.weekFlowLayout.sectionWidth = self.layoutSectionWidth;
}

-(void)forceReload:(BOOL)reloadEvents{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(reloadEvents)
            [self groupEventsBySection];
        [self.weekFlowLayout invalidateLayoutCache];
        [self.collectionView reloadData];
    });
}

- (CGFloat)layoutSectionWidth{
    return (self.frame.size.width - 50) / self.daysToShowOnScreen;
}

-(NSDate*)firstDay{
    return [self.weekFlowLayout dateForDayColumnHeaderAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

//================================================
#pragma mark - Set Events
//================================================
-(void)setEvents:(NSArray *)events{
    mEvents = events;
    [self forceReload:YES];
}

-(void)addEvent:(MSEvent *)event{
    [self addEvents:@[event]];
}

-(void)addEvents:(NSArray*)events{
    self.events = [mEvents arrayByAddingObjectsFromArray:events];
    [self forceReload:YES];
}

-(void)removeEvent:(MSEvent*)event{
    self.events = [mEvents reject:^BOOL(MSEvent* arrayEvent) {
        return [arrayEvent isEqual:event];;
    }];
    [self forceReload:YES];
}

/**
 * Note that in the standard calendar, each section is a day"
 */
- (void)groupEventsBySection {

//    NSDate* date = [NSDate today:@"device"];                                      //Why does it crash on some configurations?
    NSDate *date =
        [NSDate parse:NSDate.today.toDateTimeString timezone:@"device"];  //If it crashes here, comment the previous line and uncomment this one

    _eventsBySection = NSMutableDictionary.new;

    for (int i = 0; i < self.daysToShow; i++) {
        [_eventsBySection setObject:[self eventsByDate:date] forKey:date.toDeviceTimezoneDateString];
        date = [date addDay];
    }
}

- (NSArray *)eventsByDate:(NSDate *)date {
    return [mEvents filter_:@selector(isInDay:) withObject:date];
}

//================================================
#pragma mark - CollectionView Datasource
//================================================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{   
    return _eventsBySection.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString* day = [_eventsBySection.allKeys.sort objectAtIndex:section];
    return [_eventsBySection[day] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    NSString* day      = [_eventsBySection.allKeys.sort objectAtIndex:indexPath.section];
    cell.event         = [_eventsBySection[day] objectAtIndex:indexPath.row];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day                 = [self.weekFlowLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay          = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.weekFlowLayout];
        
        NSDate *startOfDay          = [NSCalendar.currentCalendar startOfDayForDate:day];
        NSDate *startOfCurrentDay   = [NSCalendar.currentCalendar startOfDayForDate:currentDay];
        
        dayColumnHeader.day         = day;
        dayColumnHeader.currentDay  = [startOfDay isEqualToDate:startOfCurrentDay];
        
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
    NSString* day = [_eventsBySection.allKeys.sort objectAtIndex:section];
    return [NSDate parse:day timezone:@"device"];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *day = [_eventsBySection.allKeys.sort objectAtIndex:indexPath.section];
    MSEvent *ev = [_eventsBySection[day] objectAtIndex:indexPath.row];

    if ([ev.StartDate.toDeviceTimezoneDateString isEqualToString:day])
        return ev.StartDate;

    else return [NSDate parse:str(@"%@ 00:00:00", day) timezone:@"device"];
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *day = [_eventsBySection.allKeys.sort objectAtIndex:indexPath.section];
    MSEvent *ev = [_eventsBySection[day] objectAtIndex:indexPath.row];

    if ([ev.EndDate.toDeviceTimezoneDateString isEqualToString:day])
        return ev.EndDate;

    else return [NSDate parse:str(@"%@ 23:59:59", day) timezone:@"device"];
}

-(NSArray*)unavailableHoursPeriods:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewLayout section:(int)section{
    if([self.delegate respondsToSelector:@selector(weekView:unavailableHoursPeriods:)]){
        NSDate* date = [self collectionView:collectionView layout:collectionViewLayout dayForSection:section];
        return [self.delegate weekView:self unavailableHoursPeriods:date];
    }
    return @[];
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout
{
    return NSDate.date;
}


//================================================
#pragma mark - Collection view delegate
//================================================
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate){
        MSEventCell* cell = (MSEventCell*)[collectionView cellForItemAtIndexPath:indexPath];
        [self.delegate weekView:self eventSelected:cell];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

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
    _eventsBySection                = nil;
}

@end
