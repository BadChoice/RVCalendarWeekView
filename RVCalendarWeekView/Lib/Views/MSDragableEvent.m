//
//  MSDragableEvent.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 23/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSDragableEvent.h"

#define MAS_SHORTHAND
#import "Masonry.h"

@implementation MSDragableEvent


-(id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        CGFloat borderWidth = 2.0;
        UIEdgeInsets contentPadding = UIEdgeInsetsMake(1.0, (borderWidth + 4.0), 1.0, 4.0);
        
        self.timeLabel           = [UILabel new];
        self.timeLabel.font      = [UIFont systemFontOfSize:12];
        self.timeLabel.textColor = UIColor.whiteColor;
        [self addSubview:self.timeLabel];
        
        [self.timeLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).offset(contentPadding.top);
            make.left.equalTo(self.left).offset(contentPadding.left);
            make.right.equalTo(self.right).offset(-contentPadding.right);
        }];        
        
        self.timeLabel.text = @"--";
    }
    return self;
}

/*-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //_originalPosition   = self.center;
    //_touchOffset        = CGPointMake(self.center.x-position.x,self.center.y - position.y);
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch* mTouch = [touches anyObject];
    CGPoint cp = [mTouch locationInView:self.superview];
    [self setCenter:CGPointMake(cp.x, cp.y)];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

}*/

@end
