//
//  MSWeekViewDecoratorPinchable.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 2/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorPinchable.h"
#define MAX_HOUR_HEIGHT 250
#define MIN_HOUR_HEIGHT 20

@implementation MSWeekViewDecoratorPinchable


-(void)setup{
    [super setup];
    
    UIGestureRecognizer* lpgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinch:)];
    [lpgr setCancelsTouchesInView:NO];  //To didSelectCell still works
    [self.collectionView addGestureRecognizer:lpgr];
}

-(void)onPinch:(UIPinchGestureRecognizer*)gestureRecognizer{
    //if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGFloat newHourHeight = MIN(50* gestureRecognizer.scale, MAX_HOUR_HEIGHT);
        newHourHeight         = MAX(newHourHeight, MIN_HOUR_HEIGHT);
        
        self.baseWeekView.weekFlowLayout.hourHeight = newHourHeight;
        [self.baseWeekView forceReload:NO];
    }
}

@end
