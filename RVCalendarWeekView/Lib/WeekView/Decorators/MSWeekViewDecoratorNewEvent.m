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

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewNewEventDelegate>)delegate{
    MSWeekViewDecoratorNewEvent * weekViewDecorator = [super makeWith:weekView];
    weekViewDecorator.createEventDelegate = delegate;
    return weekViewDecorator;
}

-(void)setup{
    [super setup];
    
    UIGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [lpgr setCancelsTouchesInView:NO];  //To didSelectCell still works
    [self.weekView.collectionView addGestureRecognizer:lpgr];
}

-(void)onLongPress:(UILongPressGestureRecognizer*)gestureRecognizer{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint cp          = [gestureRecognizer locationInView:self.weekView.collectionView];
        CGPoint finalPoint  = CGPointMake(cp.x - 40, cp.y - 20); //Why 40 / 20?
        NSDate* date        = [self dateForPoint:finalPoint];
        
        if(date.minute > 15 && date.minute < 45)    date = [date withMinute:30];
        else if(date.minute > 45)                   date = [[date addHour] withMinute:0];
        else                                        date = [date withMinute:0];
        
        if(self.createEventDelegate)
            [self.createEventDelegate MSWeekView:self onLongPressAt:date];
    }
}


@end
