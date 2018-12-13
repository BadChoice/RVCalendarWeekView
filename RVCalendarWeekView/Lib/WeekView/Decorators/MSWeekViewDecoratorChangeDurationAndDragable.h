#import <Foundation/Foundation.h>
#import "MSWeekView.h"
#import "MSWeekViewDecorator.h"
@protocol MSWeekViewChangeDurationDelegate;
@protocol MSWeekViewDragableDelegate;

#import "MSDurationChangeIndicator.h";

@interface MSWeekViewDecoratorChangeDurationAndDragable : MSWeekViewDecorator <MSDurationIndicatorDelegate> {
    MSDragableEvent     * mDragableEvent;

    CGFloat mStartY;
    CGFloat mStartHeight;

    MSDurationChangeIndicator* mStartIndicator;
    MSDurationChangeIndicator* mEndIndicator;
}

+ (__kindof MSWeekView *)makeWith:(MSWeekView *)weekView andDelegate:(id)delegate;

@property(weak,nonatomic) id<MSWeekViewChangeDurationDelegate> changeDurationDelegate;
@property(weak,nonatomic) id<MSWeekViewDragableDelegate> dragDelegate;
@end