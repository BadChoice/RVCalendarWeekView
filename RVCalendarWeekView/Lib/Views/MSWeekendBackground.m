//
//  MSWeekendBackground.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 6/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekendBackground.h"
#import "UIColor+HexString.h"

@implementation MSWeekendBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    }
    return self;
}

@end
