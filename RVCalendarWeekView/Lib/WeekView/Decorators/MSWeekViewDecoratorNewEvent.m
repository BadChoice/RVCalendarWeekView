//
//  MSWeekViewDecoratorNewEvent.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorNewEvent.h"
#import "NSDate+DateTools.h"
#import "NSDate+Easy.h"

@implementation MSWeekViewDecoratorNewEvent

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewNewEventDelegate>)delegate shortPress:(BOOL)shortPress{
    MSWeekViewDecoratorNewEvent * weekViewDecorator = [super makeWith:weekView];
    weekViewDecorator.shortPress                    = shortPress;
    weekViewDecorator.createEventDelegate           = delegate;
    return weekViewDecorator;
}

-(void)setShortPress:(BOOL)shortPress{
    _shortPress = shortPress;
    UIGestureRecognizer* gr;
    if (self.shortPress) {
        gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    } else {
        gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    }
    [gr setCancelsTouchesInView:NO];  //To didSelectCell still works
    [self.collectionView addGestureRecognizer:gr];
}

-(void)onTap:(UIGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized) {
        NSDate* date = [self dateForGesture:gestureRecognizer];
        
        if(self.createEventDelegate)
            [self.createEventDelegate weekView:self.baseWeekView onTapAt:date];
    }
}

-(void)onLongPress:(UIGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSDate* date = [self dateForGesture:gestureRecognizer];
        
        if(self.createEventDelegate)
            [self.createEventDelegate weekView:self.baseWeekView onLongPressAt:date];
    }
}

-(NSDate*)dateForGesture:(UIGestureRecognizer*)gestureRecognizer{
    CGPoint cp          = [gestureRecognizer locationInView:self.baseWeekView];
    NSDate* date        = [self dateForPoint:cp];
    
    if(date.minute > 15 && date.minute < 45)    date = [date withMinute:30];
    else if(date.minute > 45)                   date = [[date addHour] withMinute:0];
    else                                        date = [date withMinute:0];
    
    return date;
}


@end
