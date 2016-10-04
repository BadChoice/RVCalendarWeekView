//
//  MSUnavailableHour.m
//  RVCalendarWeekView
//
//  Created by Badchoice on 4/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSUnavailableHour.h"
#import "UIColor+HexString.h"

@implementation MSUnavailableHour

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F1F1F1"];
    }
    
    return self;
}

@end
