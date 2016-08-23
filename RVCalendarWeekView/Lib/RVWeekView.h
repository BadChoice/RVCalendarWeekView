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
#import "AKEvent.h"


@protocol RVWeekViewDelegate <NSObject>
-(void)RVWeekView:(id)sender eventSelected:(AKEvent*)event;
@end

@interface RVWeekView : UIView <UICollectionViewDataSource, UICollectionViewDelegate,MSCollectionViewDelegateCalendarLayout>
{
    NSArray             * mEvents;
    NSMutableDictionary * mDays;
    MSDragableEvent     * mDragableEvent;
}

@property(strong,nonatomic) UICollectionView* collectionView;
@property(strong,nonatomic) MSCollectionViewCalendarLayout* weekFlowLayout;

@property(nonatomic) int daysToShowOnScreen;
@property(nonatomic) int daysToShow;
@property(strong,nonatomic) NSArray* events;

@property(weak,nonatomic) id<RVWeekViewDelegate> delegate;

-(void)forceReload;

@end
