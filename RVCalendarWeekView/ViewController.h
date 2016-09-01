//
//  ViewController.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWeekViewDecoratorDragable.h"
#import "MSWeekViewDecoratorInfinite.h"
#import "MSWeekViewDecoratorNewEvent.h"

@interface ViewController : UIViewController <MSWeekViewDelegate, MSWeekViewDragableDelegate,MSWeekViewNewEventDelegate>

@property (weak, nonatomic) IBOutlet MSWeekView *weekView;

@property (strong, nonatomic) MSWeekView *decoratedWeekView;

@end

