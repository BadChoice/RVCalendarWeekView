//
//  MSWeekViewDecorator.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSWeekView.h"

@interface MSWeekViewDecorator : NSObject <UICollectionViewDataSource>

@property (strong,nonatomic) MSWeekView * weekView;

-(void)setup;

@end
