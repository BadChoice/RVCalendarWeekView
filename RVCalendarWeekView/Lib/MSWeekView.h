//
//  RVWeekView.h
//  RVCalendarWeekView
//
//  Created by Badchoice on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCollectionViewCalendarLayout.h"
#import "MSDragableEvent.h"
#import "MSEvent.h"


@protocol MSWeekViewDelegate <NSObject>
-(void)weekView:(id)sender eventSelected:(MSEventCell*)eventCell;
@end

@interface MSWeekView : UIView <UICollectionViewDataSource, UICollectionViewDelegate,MSCollectionViewDelegateCalendarLayout>
{
    NSArray             * mEvents;
}

@property(strong,nonatomic) UICollectionView* collectionView;
@property(strong,nonatomic) MSCollectionViewCalendarLayout* weekFlowLayout;

@property(nonatomic) int daysToShowOnScreen;
@property(nonatomic) int daysToShow;
@property(strong,nonatomic) NSArray* events;

@property(weak,nonatomic) id<MSWeekViewDelegate> delegate;


/** Base property for storing each even on its sections, by default the key is the day
  but you can customize to put anything there*/
@property(strong,nonatomic) NSMutableDictionary* eventsBySection;

/**
 * Changes these in subclass's registerClasses before calling [super registerClasses];
 */
@property(nonatomic) Class eventCellClass;
@property(nonatomic) Class dayColumnHeaderClass;
@property(nonatomic) Class timeRowHeaderClass;

/**
 * These are optional. If you don't want any of the decoration views, just set them to nil.
 */
@property(nonatomic) Class currentTimeIndicatorClass;
@property(nonatomic) Class currentTimeGridlineClass;
@property(nonatomic) Class verticalGridlineClass;
@property(nonatomic) Class horizontalGridlineClass;
@property(nonatomic) Class timeRowHeaderBackgroundClass;
@property(nonatomic) Class dayColumnHeaderBackgroundClass;

/**
 * Override this function to customize the views you want to use
 * Just change the classes that you will use
 */
-(void)setupSupplementaryViewClasses;

/**
 * Call this function to reload (when
 */
-(void)forceReload:(BOOL)reloadEvents;

-(void)addEvent   :(MSEvent*)event;
-(void)addEvents  :(NSArray*)events;
-(void)removeEvent:(MSEvent*)event;

-(NSDate*)firstDay;

@end
