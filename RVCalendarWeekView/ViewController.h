//
//  ViewController.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSWeekViewDragable.h"

@interface ViewController : UIViewController <MSWeekViewDelegate, MSWeekViewDragableDelegate>

@property (weak, nonatomic) IBOutlet MSWeekViewDragable *weekView;

@end

