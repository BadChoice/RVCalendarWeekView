//
//  ViewController.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWeekViewDecoratorFactory.h"

@interface ViewController : UIViewController <MSWeekViewDelegate, MSWeekViewDragableDelegate,MSWeekViewNewEventDelegate, MSWeekViewInfiniteDelegate>{
    NSArray* unavailableHours;
}

/**
 * Base weekView with only selected event feature
 */
@property (weak, nonatomic) IBOutlet MSWeekView *weekView;

/**
 * Strong reference since it is what adds the features to the weekView
 */
@property (strong, nonatomic) MSWeekView *decoratedWeekView;

@end

