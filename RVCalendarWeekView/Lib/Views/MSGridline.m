//
//  MSGridlineCollectionReusableView.m
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import "MSGridline.h"
#import "UIColor+HexString.h"
@implementation MSGridline

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
        self.border.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        [self addSubview:self.border];
    }
    return self;
}

-(void)layoutSubviews{
    if(self.frame.size.width > 5 && self.frame.size.height > 5 ){
        self.backgroundColor = [UIColor colorWithHexString:@"F3F3F3"];
    }
    else{
        self.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    }
}

@end
