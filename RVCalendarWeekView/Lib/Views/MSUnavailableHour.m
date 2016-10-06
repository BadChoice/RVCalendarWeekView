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
        self.backgroundColor = [UIColor colorWithHexString:@"FaFaFa"];
    }
    return self;
}

//http://stackoverflow.com/questions/39182041/how-to-fill-a-uiview-with-an-alternating-stripe-pattern-programmatically-using-s
/*-(void)drawRect:(CGRect)rect{
    
    //// Set pattern tile colors width and height; adjust the color width to adjust pattern.
    UIColor* color1         = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.2f];
    CGFloat color1Width     = 5;
    CGFloat color1Height    = 5;
    
    UIColor* color2         = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:254/255.0f alpha:0];
    CGFloat color2Width     = 10;
    CGFloat color2Height    = 10;
    
    //// Set pattern tile orientation vertical.
    CGFloat patternWidth  = color1Width + color2Width;
    CGFloat patternHeight = MIN(color1Height, color2Height);
    
    //// Set pattern tile size.
    CGSize patternSize = CGSizeMake(patternWidth, patternHeight);
    
    //// Draw pattern tile
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsBeginImageContextWithOptions(patternSize, false, 0.0);
    
    UIBezierPath* color1Path = [UIBezierPath bezierPathWithRect:CGRectMake(0,0,color1Width,color1Height)];
    [color1 setFill];
    [color1Path fill];
    
    UIBezierPath* color2Path = [UIBezierPath bezierPathWithRect:CGRectMake(color1Width,0,color2Width,color2Height)];
    [color2 setFill];
    [color2Path fill];
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //// Draw pattern in view
    [[UIColor colorWithPatternImage:image] setFill];
    CGContextFillRect(context, rect);
}*/


@end
