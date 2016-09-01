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
-(void)MSWeekView:(id)sender eventSelected:(MSEvent*)event;
@end

@interface MSWeekView : UIView <UICollectionViewDataSource, UICollectionViewDelegate,MSCollectionViewDelegateCalendarLayout>
{
    NSArray             * mEvents;
    NSMutableDictionary * mDays;
}

@property(strong,nonatomic) UICollectionView* collectionView;
@property(strong,nonatomic) MSCollectionViewCalendarLayout* weekFlowLayout;

@property(nonatomic) int daysToShowOnScreen;
@property(nonatomic) int daysToShow;
@property(strong,nonatomic) NSArray* events;

@property(weak,nonatomic) id<MSWeekViewDelegate> delegate;

-(void)forceReload;

-(void)addEvent   :(MSEvent*)event;
-(void)removeEvent:(MSEvent*)event;

@end
