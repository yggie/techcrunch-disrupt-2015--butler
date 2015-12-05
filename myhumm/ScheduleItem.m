//
//  ScheduleItem.m
//  MyButler
//
//  Created by Bryan Yap on 05/12/2015.
//  Copyright © 2015 Neetesh Gupta. All rights reserved.
//

#import "ScheduleItem.h"

@implementation ScheduleItem

- (id)initWithInfo:(NSDate *)startTime :(NSDate *)endTime :(NSObject*)info {
    self = [super init];
    
    if (self) {
        self.startTime = startTime;
        self.endTime = endTime;
        self.info = info;
    }
    
    return self;
}

@end
