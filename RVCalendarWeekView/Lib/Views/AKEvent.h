//
//  AKEvent.h
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AKEvent : NSObject

@property (nonatomic, strong) NSNumber *remoteID;
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSNumber *timeToBeDecided;
@property (nonatomic, strong) NSNumber *dateToBeDecided;

- (NSDate *)day;

@end