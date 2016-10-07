//
//  MSDurationChangeIndicator.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 7/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSDurationChangeIndicator.h"
#define INDICATOR_SIZE 10

@implementation MSDurationChangeIndicator

+(MSDurationChangeIndicator*)makeForStartWithCell:(MSEventCell*)eventCell andDelegate:(id<MSDurationIndicatorDelegate>)delegate{
    MSDurationChangeIndicator* durationChange   = [[MSDurationChangeIndicator alloc] initWithFrame:
                                                   CGRectMake(INDICATOR_SIZE*0.5,
                                                              -INDICATOR_SIZE*0.5,
                                                              INDICATOR_SIZE,
                                                              INDICATOR_SIZE)];
    [durationChange setup:YES eventCell:eventCell andDelegate:delegate];
    return durationChange;
}

+(MSDurationChangeIndicator*)makeForEndWithCell:(MSEventCell*)eventCell andDelegate:(id<MSDurationIndicatorDelegate>)delegate{
    MSDurationChangeIndicator* durationChange   = [[MSDurationChangeIndicator alloc] initWithFrame:
                                                   CGRectMake(eventCell.frame.size.width  - INDICATOR_SIZE * 2,
                                                              eventCell.frame.size.height - INDICATOR_SIZE,
                                                              INDICATOR_SIZE,
                                                              INDICATOR_SIZE)];
    [durationChange setup:NO eventCell:eventCell andDelegate:delegate];
    return durationChange;
}

-(void)setup:(BOOL)isStart eventCell:(MSEventCell*)eventCell andDelegate:(id<MSDurationIndicatorDelegate>)delegate{
    mIsStart = isStart;
    self.backgroundColor      = [UIColor whiteColor];
    self.layer.masksToBounds  = YES;
    self.layer.cornerRadius   = self.frame.size.width * 0.5;
    self.delegate             = delegate;
    self.eventCell            = eventCell;
    [eventCell addSubview:self];
    [self addDragGestureRecognizer];
}

-(void)addDragGestureRecognizer{
    UILongPressGestureRecognizer* lpgr  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onPress:)];
    [self addGestureRecognizer:lpgr];
}

-(void)onPress:(UIGestureRecognizer*)gestureRecognizer{
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGPoint cp = [gestureRecognizer locationInView:self.superview];
        if(self.delegate){
            if(mIsStart)
                [self.delegate durationIndicatorStartUpdated:self y:cp.y];
            else
                self.frame = CGRectMake(self.frame.origin.x, cp.y, INDICATOR_SIZE, INDICATOR_SIZE);
                [self.delegate durationIndicatorEndUpdated:self   y:cp.y + INDICATOR_SIZE*0.5];
        }
    }
}
@end
