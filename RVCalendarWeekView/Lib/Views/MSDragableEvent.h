//
//  MSDragableEvent.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 23/8/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSEventCell.h"

@interface MSDragableEvent : MSEventCell{
    CGPoint _originalPosition;
    CGPoint _touchOffset;
}

+(MSDragableEvent*)makeWithEventCell:(MSEventCell*)eventCell andOffset:(CGPoint)offset;

@property (strong,nonatomic) UILabel* timeLabel;

@end
