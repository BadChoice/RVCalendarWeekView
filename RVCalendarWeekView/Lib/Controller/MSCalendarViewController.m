//
//  MSCalendarViewController.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MSCalendarViewController.h"
#import "MSCollectionViewCalendarLayout.h"
#import "MSEvent.h"
#import "AKSection.h"
#import "AKEvent.h"
// Collection View Reusable Views
#import "MSGridline.h"
#import "MSTimeRowHeaderBackground.h"
#import "MSDayColumnHeaderBackground.h"
#import "MSEventCell.h"
#import "MSDayColumnHeader.h"
#import "MSTimeRowHeader.h"
#import "MSCurrentTimeIndicator.h"
#import "MSCurrentTimeGridline.h"
#import <CoreData/CoreData.h>

NSString * const MSEventCellReuseIdentifier = @"MSEventCellReuseIdentifier";
NSString * const MSDayColumnHeaderReuseIdentifier = @"MSDayColumnHeaderReuseIdentifier";
NSString * const MSTimeRowHeaderReuseIdentifier = @"MSTimeRowHeaderReuseIdentifier";

@interface MSCalendarViewController () <MSCollectionViewDelegateCalendarLayout, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) MSCollectionViewCalendarLayout *collectionViewCalendarLayout;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableArray *sectionsArr;
@property (nonatomic, readonly) CGFloat layoutSectionWidth;

@end

@implementation MSCalendarViewController

- (id)init
{
    self.collectionViewCalendarLayout = [[MSCollectionViewCalendarLayout alloc] init];
    self.collectionViewCalendarLayout.delegate = self;
    self = [super initWithCollectionViewLayout:self.collectionViewCalendarLayout];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.collectionViewCalendarLayout.sectionLayoutType = MSSectionLayoutTypeHorizontalTile;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:MSEventCell.class forCellWithReuseIdentifier:MSEventCellReuseIdentifier];
    [self.collectionView registerClass:MSDayColumnHeader.class forSupplementaryViewOfKind:MSCollectionElementKindDayColumnHeader withReuseIdentifier:MSDayColumnHeaderReuseIdentifier];
    [self.collectionView registerClass:MSTimeRowHeader.class forSupplementaryViewOfKind:MSCollectionElementKindTimeRowHeader withReuseIdentifier:MSTimeRowHeaderReuseIdentifier];
    
    self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
    
    // These are optional. If you don't want any of the decoration views, just don't register a class for them.
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeIndicator.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeIndicator];
    [self.collectionViewCalendarLayout registerClass:MSCurrentTimeGridline.class forDecorationViewOfKind:MSCollectionElementKindCurrentTimeHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindVerticalGridline];
    [self.collectionViewCalendarLayout registerClass:MSGridline.class forDecorationViewOfKind:MSCollectionElementKindHorizontalGridline];
    [self.collectionViewCalendarLayout registerClass:MSTimeRowHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindTimeRowHeaderBackground];
    [self.collectionViewCalendarLayout registerClass:MSDayColumnHeaderBackground.class forDecorationViewOfKind:MSCollectionElementKindDayColumnHeaderBackground];
    
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.collectionViewCalendarLayout scrollCollectionViewToClosetSectionToCurrentTimeAnimated:NO];
}

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    // Ensure that collection view properly rotates between layouts
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.collectionViewCalendarLayout.sectionWidth = self.layoutSectionWidth;
        
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.collectionView reloadData];
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - MSCalendarViewController

- (void)loadData
{
    
    NSDate *dt = [NSDate date];
    AKEvent * event1 = [AKEvent new];
    [event1 setRemoteID:@(0)];
    [event1 setStart:dt];
    [event1 setTitle:@"Help me"];
    [event1 setLocation:@"Great example"];
    [event1 setTimeToBeDecided:@(2)];
    [event1 setDateToBeDecided:@(3)];
    
    
    AKEvent * event2 = [AKEvent new];
    [event2 setRemoteID:@(0)];
    [event2 setStart:dt];
    [event2 setTitle:@"Help me"];
    [event2 setLocation:@"Great example"];
    [event2 setTimeToBeDecided:@(2)];
    [event2 setDateToBeDecided:@(3)];
    
    NSMutableArray<AKEvent *> *events1 = [[NSMutableArray alloc] init];
    [events1 addObject:event1];
    [events1 addObject:event2];
    AKSection *section = [AKSection new];
    [section setTitle:@"Court 1"];
    [section setEventsArr:events1];
    self.sectionsArr = [[NSMutableArray alloc]init];
    [self.sectionsArr addObject:section];
}

- (CGFloat)layoutSectionWidth
{
    // Default to 254 on iPad.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 254.0;
    }
    
    // Otherwise, on iPhone, fit-to-width.
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    CGFloat timeRowHeaderWidth = self.collectionViewCalendarLayout.timeRowHeaderWidth;
    CGFloat rightMargin = self.collectionViewCalendarLayout.contentMargin.right;
    
    return (width - timeRowHeaderWidth - rightMargin);
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionViewCalendarLayout invalidateLayoutCache];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sectionsArr count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AKSection *sect = [self.sectionsArr objectAtIndex:section];
    return [sect.eventsArr count];

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MSEventCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MSEventCellReuseIdentifier forIndexPath:indexPath];
    
    AKSection *sect = [self.sectionsArr objectAtIndex:indexPath.section];
    AKEvent *ev = [sect.eventsArr objectAtIndex:indexPath.row];
    cell.akEvent = ev;

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view;
    if (kind == MSCollectionElementKindDayColumnHeader) {
        MSDayColumnHeader *dayColumnHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSDayColumnHeaderReuseIdentifier forIndexPath:indexPath];
        NSDate *day = [self.collectionViewCalendarLayout dateForDayColumnHeaderAtIndexPath:indexPath];
        NSDate *currentDay = [self currentTimeComponentsForCollectionView:self.collectionView layout:self.collectionViewCalendarLayout];
        
        NSDate *startOfDay = [[NSCalendar currentCalendar] startOfDayForDate:day];
        NSDate *startOfCurrentDay = [[NSCalendar currentCalendar] startOfDayForDate:currentDay];
        
        dayColumnHeader.day = day;
        dayColumnHeader.currentDay = [startOfDay isEqualToDate:startOfCurrentDay];
        
        view = dayColumnHeader;
    } else if (kind == MSCollectionElementKindTimeRowHeader) {
        MSTimeRowHeader *timeRowHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:MSTimeRowHeaderReuseIdentifier forIndexPath:indexPath];
        timeRowHeader.time = [self.collectionViewCalendarLayout dateForTimeRowHeaderAtIndexPath:indexPath];
        view = timeRowHeader;
    }
    return view;
}

#pragma mark - MSCollectionViewCalendarLayout

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout dayForSection:(NSInteger)section
{
    AKSection *sect = [self.sectionsArr objectAtIndex:section];
    AKEvent *ev = [sect.eventsArr firstObject];
    return ev.day;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout startTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AKSection *sect = [self.sectionsArr objectAtIndex:indexPath.section];
    AKEvent *ev = [sect.eventsArr objectAtIndex:indexPath.row];
    return ev.start;
}

- (NSDate *)collectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout endTimeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AKSection *sect = [self.sectionsArr objectAtIndex:indexPath.section];
    AKEvent *ev = [sect.eventsArr objectAtIndex:indexPath.row];
    return [ev.start dateByAddingTimeInterval:(60 * 60 * 3)];
    return nil;

}

- (NSDate *)currentTimeComponentsForCollectionView:(UICollectionView *)collectionView layout:(MSCollectionViewCalendarLayout *)collectionViewCalendarLayout
{
    return [NSDate date];
}

@end