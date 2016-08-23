//
//  ViewController.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "ViewController.h"
#import "AkEvent.h"
#import "NSDate+Easy.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWeekData];
}

- (void)setupWeekData{
    
    
    AKEvent* event1 = [AKEvent make:NSDate.now
                              title:@"Title"
                           location:@"Central perk"];
    
    AKEvent* event2 = [AKEvent make:[NSDate.now addMinutes:10]
                           duration:60*3
                              title:@"Title 2"
                           location:@"Central perk"];
    
    AKEvent* event3 = [AKEvent make:[NSDate.tomorrow addMinutes:10]
                           duration:60*3
                              title:@"Title 3"
                           location:@"Central perk"];
    
    AKEvent* event4 = [AKEvent make:[NSDate.nextWeek addHours:7]
                           duration:60*3
                              title:@"Title 4"
                           location:@"Central perk"];
    
    _weekView.dragDelegate = self;
    _weekView.weekFlowLayout.show24Hours = YES;
    _weekView.events = @[event1,event2,event3,event4];
}

//=========================================
#pragma mark - Week View Dragable delegate
//=========================================
-(void)RVWeekView:(RVWeekView *)weekView event:(AKEvent *)event moved:(NSDate *)date{
    NSLog(@"Event moved");
}

-(BOOL)RVWeekView:(RVWeekView *)weekView canMoveEvent:(AKEvent *)event to:(NSDate *)date{
    return YES;
}



@end
