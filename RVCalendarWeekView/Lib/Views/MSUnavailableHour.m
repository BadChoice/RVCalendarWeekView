//
//  MSUnavailableHour.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 4/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSUnavailableHour.h"

@implementation MSUnavailableHour

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.alpha           = 0.2;
    }
    
    return self;
}

@end
