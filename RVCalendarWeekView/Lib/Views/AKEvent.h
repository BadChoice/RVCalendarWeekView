//
//  AKEvent.h
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKEvent : NSObject

@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *location;

- (NSDate *)day;

@end