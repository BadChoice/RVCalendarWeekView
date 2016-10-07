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

/**
 * Use this variable to change the minutes precision when
 * dragging or creating new event 
 * use values from 0 to 60
 * default is 5 minutes
 */
@property(nonatomic) int minutesPrecision;

//=========================================================
#pragma mark - Get XX for Point
//=========================================================
-(NSDate*)dateForPoint:(CGPoint)point;
-(int)getHourForY:(float)y;
-(int)getMinuteForY:(float)y;
-(int)getDayIndexForX:(float)x;
-(CGFloat)round:(float)number toNearest:(float)pivot;
-(CGFloat)round:(float)number toLowest:(float)pivot;

//=========================================================
#pragma mark -
//=========================================================
/**
 * Checks if there is any GR using as delegate the class itself
 */
-(BOOL)isGestureAlreadyAdded:(UIView*)cell;
@end
