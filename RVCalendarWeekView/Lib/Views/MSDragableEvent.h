//
//  MSDragableEvent.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 23/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSDragableEvent : UIView{
    CGPoint _originalPosition;
    CGPoint _touchOffset;
}

@property (strong,nonatomic) UILabel* timeLabel;

@end
