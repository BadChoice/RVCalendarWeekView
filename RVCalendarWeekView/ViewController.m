//
//  ViewController.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 22/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "ViewController.h"
#import "MSEvent.h"
#import "NSDate+Easy.h"
#import "NSArray+Collection.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupWeekData];
}

- (void)setupWeekData{
    
    self.decoratedWeekView = [MSWeekViewDecoratorFactory make:self.weekView
                                                      features:(MSDragableEventFeature|MSNewEventFeature|MSInfiniteFeature|MSPinchableFeature|MSShortPressNewEventFeature)
                                                  andDelegate:self];
    
    
    MSEvent* event1 = [MSEvent make:NSDate.now
                              title:@"Title"
                           subtitle:@"Central perk"];
    
    MSEvent* event2 = [MSEvent make:[NSDate.now addMinutes:10]
                           duration:60*3
                              title:@"Title 2"
                           subtitle:@"Central perk"];
    
    MSEvent* event3 = [MSEvent make:[NSDate.tomorrow addMinutes:10]
                           duration:60*3
                              title:@"Title 3"
                           subtitle:@"Central perk"];
    
    MSEvent* event4 = [MSEvent make:[NSDate.nextWeek addHours:7]
                           duration:60*3
                              title:@"Title 4"
                           subtitle:@"Central perk"];
    
    _weekView.delegate                      = self;
    _weekView.weekFlowLayout.show24Hours    = YES;
    _weekView.daysToShowOnScreen            = 7;
    _weekView.daysToShow                    = 30;
    _weekView.weekFlowLayout.hourHeight     = 50;
    _weekView.events = @[event1,event2,event3,event4];
}

//=========================================
#pragma mark - Week View delegate
//=========================================
-(void)weekView:(id)sender eventSelected:(MSEventCell*)eventCell{
    NSLog(@"Event selected: %@",eventCell.event.title);
    //[_weekView removeEvent:event];
}

//=========================================
#pragma mark - Week View Decorator Dragable delegate
//=========================================
-(void)weekView:(MSWeekView *)weekView event:(MSEvent *)event moved:(NSDate *)date{
    NSLog(@"Event moved");
}

-(BOOL)weekView:(MSWeekView*)weekView canStartMovingEvent:(MSEvent*)event{
    return YES;
}

-(BOOL)weekView:(MSWeekView *)weekView canMoveEvent:(MSEvent *)event to:(NSDate *)date{
    return YES;
    
    //Example on how to return YES/NO from an async function (for example an alert)
    /*NSCondition* condition = [NSCondition new];
    BOOL __block shouldMove;
    
    RVAlertController* a = [RVAlertController alert:@"Move"
                                            message:@"Do you want to move";
    
    
    [a showAlertWithCompletion:^(NSInteger buttonIndex) {
        shouldMove = (buttonIndex == RVALERT_OK);
        [condition signal];
    }];
    
    [condition lock];
    [condition wait];
    [condition unlock];
    
    return shouldMove;*/
}

//=========================================
#pragma mark - Week View Decorator New event delegate
//=========================================
-(void)weekView:(MSWeekView*)weekView onLongPressAt:(NSDate*)date{
    NSLog(@"Long pressed at: %@", date);
    MSEvent *newEvent = [MSEvent make:date title:@"New Event" subtitle:@"Platinium stadium"];
    [_weekView addEvent:newEvent];
}

-(void)weekView:(MSWeekView*)weekView onTapAt:(NSDate*)date{
    NSLog(@"Short pressed at: %@", date);
}


//=========================================
#pragma mark - Week View Decorator Infinite delegate
//=========================================
-(BOOL)weekView:(MSWeekView*)weekView newDaysLoaded:(NSDate*)startDate to:(NSDate*)endDate{
    NSLog(@"New days loaded: %@ - %@", startDate, endDate);
    
    MSEvent* newEvent = [MSEvent make:[startDate addHours:7]
                           duration:60*3
                              title:@"New event"
                           subtitle:@"Batcave"];
    
    MSEvent* lastEvent = [MSEvent make:[endDate addHours:-7]
                             duration:60*3
                                title:@"Last event"
                             subtitle:@"Fantastic tower"];
    
    [weekView addEvents:@[newEvent,lastEvent]];
    return YES;
}

@end
