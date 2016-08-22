//
//  AKSection.h
//  Example
//
//  Created by ak on 18.01.2016.
//  Copyright © 2016 Eric Horacek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AKEvent.h"
@interface AKSection : NSObject

@property (nonatomic, assign) int sectionId;
@property (nonatomic, strong) NSMutableArray<AKEvent *> *eventsArr;
@property (nonatomic, strong) NSString *title;
@end