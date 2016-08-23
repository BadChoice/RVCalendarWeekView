//
//  RVWeekView.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "RVWeekView.h"

#import "NSDate+Easy.h"
#import "RVCollection.h"
#import "NSDate+DateTools.h"

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
    self.collectionView.dataSource                      = self;
    self.collectionView.delegate                        = self;
    self.collectionView.directionalLockEnabled          = YES;
    self.collectionView.showsVerticalScrollIndicator    = NO;
    self.collectionView.showsHorizontalScrollIndicator  = NO;
    
    [self addSubview:self.collectionView];
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.height);
        make.width.equalTo(self.width);
        make.left.equalTo(self.left);
        make.top.equalTo(self.top);
    }];
    
        
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
}

-(void)forceReload{
    [self groupEventsByDays];
    [self.weekFlowLayout invalidateLayoutCache];
    [self.collectionView reloadData];
}

- (CGFloat)layoutSectionWidth
{
    // Default to 254 on iPad.
    //TODO: Days to show
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
#pragma mark - Set Events
//================================================
-(void)setEvents:(NSArray *)events{
    mEvents = events;
    [self groupEventsByDays];
}

-(void)groupEventsByDays{
    mDays = [mEvents groupBy:@"StartDate.toDateString"];
}

//================================================
#pragma mark - CollectionView Datasource
//================================================
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{   
    return mDays.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString* day = [mDays.allKeys.sort objectAtIndex:section];
    return [mDays[day] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell   = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    NSString* day       = [mDays.allKeys.sort objectAtIndex:indexPath.section];
    cell.akEvent        = [mDays[day] objectAtIndex:indexPath.row];
    
    
    UIGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [cell addGestureRecognizer:lpgr];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day                 = [self.weekFlowLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay          = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.weekFlowLayout];
        
        NSDate *startOfDay          = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay   = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
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
    NSString* day   = [mDays.allKeys.sort objectAtIndex:section];
    AKEvent* ev     = [mDays[day] firstObject];
    return ev.day;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* day   = [mDays.allKeys.sort objectAtIndex:indexPath.section];
    AKEvent* ev     = [mDays[day] objectAtIndex:indexPath.row];
    
    return ev.StartDate;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* day   = [mDays.allKeys.sort objectAtIndex:indexPath.section];
    AKEvent* ev     = [mDays[day] objectAtIndex:indexPath.row];
    return ev.EndDate;
}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout
{
    return NSDate.date;
}


//================================================
#pragma mark - Collection view delegate
//================================================
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    MSEventCell* cell = (MSEventCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSLog(@"Event selected: %@ / %@ ", cell.akEvent.title, cell.akEvent.StartDate);
}

//================================================
#pragma mark - Drag & Drop
//================================================
-(void)onLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    MSEventCell* eventCell = (MSEventCell*)gestureRecognizer.view;
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"Long press began: %@",eventCell.akEvent.title);
        
        CGPoint offset = self.collectionView.contentOffset;
        CGRect  newFrame = CGRectMake(eventCell.frame.origin.x - offset.x, eventCell.frame.origin.y - offset.y, eventCell.frame.size.width, eventCell.frame.size.height);
        
        mDragableEvent = [[MSDragableEvent alloc] initWithFrame:newFrame];
        mDragableEvent.backgroundColor = UIColor.greenColor;
        [self.superview.superview addSubview:mDragableEvent];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint cp = [gestureRecognizer locationInView:self.superview];
        [mDragableEvent setCenter:CGPointMake(cp.x, cp.y)];
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"Long press began: %@",eventCell.akEvent.title);
        [self onDragEnded:eventCell];
    }
}

-(void)onDragEnded:(MSEventCell*)eventCell{
    
    int hoursDiff = [self getHoursDiff:eventCell.akEvent newHour:[self getHourForDragable]];
    int daysDiff  = [self getDaysDiff:eventCell.akEvent  newDayIndex:[self getDayIndexForDragable]];
    
    eventCell.akEvent.StartDate = [[eventCell.akEvent.StartDate addHours:hoursDiff] addDays:daysDiff];
    eventCell.akEvent.EndDate   = [[eventCell.akEvent.EndDate   addHours:hoursDiff] addDays:daysDiff];
    
    [self forceReload];
    
    [mDragableEvent removeFromSuperview];
    mDragableEvent = nil;
}

-(int)getHourForDragable{
    int y               = mDragableEvent.frame.origin.y + self.collectionView.contentOffset.y;
    int earliestHour    = self.weekFlowLayout.earliestHour;
    int hour            = y/self.weekFlowLayout.hourHeight - 1;
    return hour + earliestHour;
}

-(int)getDayIndexForDragable{
    int x  = mDragableEvent.frame.origin.x + self.collectionView.contentOffset.x;
    return x / self.weekFlowLayout.sectionWidth;
}

-(int)getHoursDiff:(AKEvent*)event newHour:(int)newHour{
    int eventHour = event.StartDate.hour;
    return newHour - eventHour;
}

-(int)getDaysDiff:(AKEvent*)event newDayIndex:(int)newDayIndex{
    int __block eventDayOffset = 0;
    [mDays.allKeys.sort eachWithIndex:^(NSString* day, int index, BOOL *stop) {
        if([mDays[day] containsObject:event]){
            eventDayOffset = index;
            *stop = TRUE;
        }
    }];
    return newDayIndex - eventDayOffset;
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
    mDays                           = nil;
}

@end
