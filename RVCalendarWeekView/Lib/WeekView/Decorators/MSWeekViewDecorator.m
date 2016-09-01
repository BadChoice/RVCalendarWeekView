//
//  MSWeekViewDecorator.m
//  RVCalendarWeekView
//
//  Created by Jordi Puigdellívol on 1/9/16.
//  Copyright © 2016 revo. All rights reserved.
//

#import "MSWeekViewDecorator.h"


@implementation MSWeekViewDecorator

-(id)init{
    if(self = [super init]){
        [self setup];
    }
    return self;
}

-(void)setup{
    self.weekView.collectionView.dataSource = self;
}

//==========================================
#pragma mark -Collection view datasource
//==========================================
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_weekView collectionView:collectionView numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [_weekView collectionView:collectionView cellForItemAtIndexPath:indexPath];    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [_weekView numberOfSectionsInCollectionView:collectionView];
}


@end
