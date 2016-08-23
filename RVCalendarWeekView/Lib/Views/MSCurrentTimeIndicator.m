//
//  MSCurrentTimeIndicator.m
//  Example
//
//  Created by Eric Horacek on 2/27/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MSCurrentTimeIndicator.h"

#define MAS_SHORTHAND
#import "Masonry.h"
#import "UIColor+HexString.h"

#import "NSDate+Easy.h"

@interface MSCurrentTimeIndicator ()

@property (nonatomic, strong) UILabel *time;
@property (nonatomic, retain) NSTimer *minuteTimer;

@end

@implementation MSCurrentTimeIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor    = [UIColor whiteColor];
        self.time               = [UILabel new];
        self.time.font          = [UIFont boldSystemFontOfSize:10.0];
        self.time.textColor     = [UIColor colorWithHexString:@"fd3935"];
        [self addSubview:self.time];
        
        [self.time makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerY);
            make.right  .equalTo(self.right).offset(-5.0);
        }];
        
        self.minuteTimer = [[NSTimer alloc] initWithFireDate:NSDate.nextMinute interval:60
                                                      target:self
                                                    selector:@selector(minuteTick:)
                                                    userInfo:nil
                                                     repeats:YES];
        [NSRunLoop.currentRunLoop addTimer:self.minuteTimer forMode:NSDefaultRunLoopMode];
        
        [self updateTime];
    }
    return self;
}

#pragma mark - MSCurrentTimeIndicator
- (void)minuteTick:(id)sender{
    [self updateTime];
}

- (void)updateTime
{
    self.time.text = [NSDate.now format:@"h:mm aa" timezone:@"device"];
    [self.time sizeToFit];
}

@end
