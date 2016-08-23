//
//  ViewController.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RVWeekViewDragable.h"

@interface ViewController : UIViewController <RVWeekViewDragableDelegate>

@property (weak, nonatomic) IBOutlet RVWeekViewDragable *weekView;

@end

