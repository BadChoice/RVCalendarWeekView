//
//  MSEventCell.h
//  Example
//
//  Created by Eric Horacek on 2/26/13.
//  Copyright (c) 2015 Eric Horacek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSEvent.h"

@class MSEvent;

@interface MSEventCell : UICollectionViewCell

@property (nonatomic, strong) MSEvent *event;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *location;

- (void)updateColors;

- (NSDictionary *)titleAttributesHighlighted:(BOOL)highlighted;
- (NSDictionary *)subtitleAttributesHighlighted:(BOOL)highlighted;
- (UIColor *)backgroundColorHighlighted:(BOOL)selected;
- (UIColor *)textColorHighlighted:(BOOL)selected;
- (UIColor *)borderColor;

@end
