//
//  RVWeekView.h
//  RVCalendarWeekView
//
//  Created by Badchoice on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSCollectionViewCalendarLayout.h"
#import "AKSection.h"

@interface RVWeekView : UIView <UICollectionViewDataSource, UICollectionViewDelegate,MSCollectionViewDelegateCalendarLayout>

@property(strong,nonatomic) UICollectionView* collectionView;
@property(strong,nonatomic) MSCollectionViewCalendarLayout* weekFlowLayout;

@property(strong,nonatomic) NSMutableArray* days;

@end
