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

@interface RVWeekView : UIView <UICollectionViewDataSource, UICollectionViewDelegate,MSCollectionViewDelegateCalendarLayout>
{
    NSArray             * mEvents;
    NSMutableDictionary * mDays;
    MSDragableEvent     * mDragableEvent;
}

@property(strong,nonatomic) UICollectionView* collectionView;
@property(strong,nonatomic) MSCollectionViewCalendarLayout* weekFlowLayout;

@property(strong,nonatomic) NSArray* events;

-(void)forceReload;

@end
