//
//  MSDurationChangeIndicator.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 7/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSDurationChangeIndicator.h"
#define INDICATOR_TOUCH_SIZE 30
#define INDICATOR_SIZE 10
#define Y_MARGIN 5

@implementation MSDurationChangeIndicator

+(MSDurationChangeIndicator*)makeForStartWithCell:(MSEventCell*)eventCell andDelegate:(id<MSDurationIndicatorDelegate>)delegate{
    MSDurationChangeIndicator* durationChange   = [[MSDurationChangeIndicator alloc] initWithFrame:[self.class getFrameFor:eventCell start:YES]];
    [durationChange setup:YES eventCell:eventCell andDelegate:delegate];
    return durationChange;
}

+(MSDurationChangeIndicator*)makeForEndWithCell:(MSEventCell*)eventCell andDelegate:(id<MSDurationIndicatorDelegate>)delegate{
    MSDurationChangeIndicator* durationChange   = [[MSDurationChangeIndicator alloc] initWithFrame:[self.class getFrameFor:eventCell start:NO]];
    [durationChange setup:NO eventCell:eventCell andDelegate:delegate];
    return durationChange;
}

+(CGRect)getFrameFor:(MSEventCell*)cell start:(BOOL)start{
    if(start){
        return CGRectMake(cell.frame.size.width  - INDICATOR_TOUCH_SIZE - Y_MARGIN * 2,
                          Y_MARGIN,
                          INDICATOR_TOUCH_SIZE,
                          INDICATOR_TOUCH_SIZE);
    }
    else{
        return CGRectMake(Y_MARGIN,
                          cell.frame.size.height - INDICATOR_TOUCH_SIZE - Y_MARGIN,
                          INDICATOR_TOUCH_SIZE,
                          INDICATOR_TOUCH_SIZE);
    }
}

-(void)updatePosition{
    self.frame = [self.class getFrameFor:self.eventCell start:mIsStart];
}

-(void)setup:(BOOL)isStart eventCell:(MSEventCell*)eventCell andDelegate:(id<MSDurationIndicatorDelegate>)delegate{
    mIsStart = isStart;
    self.backgroundColor      = [UIColor clearColor];
    self.delegate             = delegate;
    self.eventCell            = eventCell;
    [eventCell addSubview:self];
    [self addWhiteBall];
    [self addDragGestureRecognizer];
    //[self addTimeLabel];
}

-(void)addWhiteBall{
    UIView* ball;
    if(mIsStart){
        ball = [[UIView alloc] initWithFrame:CGRectMake(20, 0, INDICATOR_SIZE, INDICATOR_SIZE)];
    }else{
        ball = [[UIView alloc] initWithFrame:CGRectMake(0, 16, INDICATOR_SIZE, INDICATOR_SIZE)];
    }
    ball.backgroundColor      = [UIColor whiteColor];
    ball.layer.masksToBounds  = YES;
    ball.layer.cornerRadius   = ball.frame.size.width * 0.5;
    ball.layer.borderColor    = [UIColor darkGrayColor].CGColor;
    ball.layer.borderWidth    = 1.0;
    [self addSubview:ball];
}

-(void)addTimeLabel{
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    self.timeLabel.text = @"--";
    [self addSubview:_timeLabel];
}

-(void)addDragGestureRecognizer{
    UILongPressGestureRecognizer* lpgr  = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onPress:)];
    lpgr.minimumPressDuration = 0.01;
    [self addGestureRecognizer:lpgr];
}

-(void)onPress:(UIGestureRecognizer*)gestureRecognizer{
    if(!self.delegate) return;
    
    if(gestureRecognizer.state == UIGestureRecognizerStateChanged){
        if(mIsStart){
            CGPoint cp = [gestureRecognizer locationInView:self];
            [self.delegate durationIndicatorStartUpdated:self y:cp.y];
        }
        else{
            CGPoint cp = [gestureRecognizer locationInView:self.superview];
            self.frame = CGRectMake(self.frame.origin.x, cp.y - INDICATOR_TOUCH_SIZE - Y_MARGIN, INDICATOR_TOUCH_SIZE, INDICATOR_TOUCH_SIZE);
            [self.delegate durationIndicatorEndUpdated:self y:cp.y];
        }
    }
    else if(gestureRecognizer.state == UIGestureRecognizerStateEnded){
        [self.delegate durationIndicatorEnded:self];
    }
}
@end
