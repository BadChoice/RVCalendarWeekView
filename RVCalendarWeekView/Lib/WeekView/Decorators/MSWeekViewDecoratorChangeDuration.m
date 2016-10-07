//
//  MSWeekViewDecoratorChangeDuration.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 7/10/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecoratorChangeDuration.h"
#import "MSEventCell.h"
#import "RVCollection.h"



@implementation MSWeekViewDecoratorChangeDuration

+(__kindof MSWeekView*)makeWith:(MSWeekView*)weekView andDelegate:(id<MSWeekViewChangeDurationDelegate>)delegate{
    MSWeekViewDecoratorChangeDuration * weekViewDecorator   = [super makeWith:weekView];
    weekViewDecorator.changeDurationDelegate                = delegate;
    return weekViewDecorator;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    if(self.changeDurationDelegate){
        MSEventCell* cell   = (MSEventCell*)[collectionView cellForItemAtIndexPath:indexPath];
        mStartY             = cell.frame.origin.y;
        mStartHeight        = cell.frame.size.height;
        mStartIndicator     = [MSDurationChangeIndicator makeForStartWithCell:cell andDelegate:self];
        mEndIndicator       = [MSDurationChangeIndicator makeForEndWithCell:cell andDelegate:self];
    }
}

-(void)durationIndicatorStartUpdated:(MSDurationChangeIndicator*)sender y:(int)y{
    sender.eventCell.frame = CGRectMake(
                        sender.eventCell.frame.origin.x,
                        sender.eventCell.frame.origin.y + y,
                        sender.eventCell.frame.size.width,
                        sender.eventCell.frame.size.height - y);
    
    [mEndIndicator updatePosition];
}

-(void)durationIndicatorEndUpdated:(MSDurationChangeIndicator*)sender y:(int)y{
    sender.eventCell.frame = CGRectMake(
                        sender.eventCell.frame.origin.x,
                        sender.eventCell.frame.origin.y,
                        sender.eventCell.frame.size.width,
                        y);
}

-(void)durationIndicatorEnded:(MSDurationChangeIndicator*)sender{
    NSDate* startDate = [self dateForPoint:CGPointMake(sender.eventCell.frame.origin.x - self.collectionView.contentOffset.x + 5,
                                                       sender.eventCell.frame.origin.y - self.collectionView.contentOffset.y)];
    
    NSDate* endDate   = [self dateForPoint:CGPointMake(sender.eventCell.frame.origin.x - self.collectionView.contentOffset.x + 5,
                                                       sender.eventCell.frame.origin.y - self.collectionView.contentOffset.y + sender.eventCell.frame.size.height )];
    
    sender.eventCell.event.StartDate = startDate;
    sender.eventCell.event.EndDate   = endDate;
    [self.baseWeekView forceReload:YES];
    if(self.changeDurationDelegate){
        [self.changeDurationDelegate weekView:self.weekView event:sender.eventCell.event durationChanged:startDate endDate:endDate];
    }
}

@end
