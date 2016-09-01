//
//  MSWeekViewDecorator.h
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSWeekView.h"

@interface MSWeekViewDecorator : MSWeekView{
}

@property(strong,nonatomic) MSWeekView* weekView;

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView;
-(void)setup;

-(MSWeekView*)baseWeekView;

//=========================================================
#pragma mark - Get XX for Point
//=========================================================
-(NSDate*)dateForPoint:(CGPoint)point;
-(int)getHourForY:(float)y;
-(int)getMinuteForY:(float)y;
-(int)getDayIndexForX:(float)x;
-(CGFloat)round:(float)number toNearest:(float)pivot;
@end
