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
    
    NSDate *dt = [NSDate date];
    AKEvent * event1 = [AKEvent new];
    [event1 setStart:dt];
    [event1 setTitle:@"Help me"];
    [event1 setLocation:@"Great example"];

        
    AKEvent * event2 = [AKEvent new];
    [event2 setStart:[dt addMinutes:10]];
    [event2 setTitle:@"Help me"];
    [event2 setLocation:@"Great example"];
    
    NSMutableArray<AKEvent *> *events1 = [[NSMutableArray alloc] init];
    [events1 addObject:event1];
    [events1 addObject:event2];
    
    AKSection *section = [AKSection new];
    [section setTitle:@"Court 1"];
    [section setEvents:events1];
    _weekView.days = [[NSMutableArray alloc]init];
    [_weekView.days addObject:section];
}

@end
