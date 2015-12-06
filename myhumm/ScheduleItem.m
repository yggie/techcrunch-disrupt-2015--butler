//
//  ScheduleItem.m
//  MyButler
//
//  Created by Bryan Yap on 05/12/2015.
//  Copyright © 2015 Neetesh Gupta. All rights reserved.
//

#import "ScheduleItem.h"

@implementation ScheduleItem

- (id)initWithInfo:(NSString *)timeInfoText :(NSString *)subtitle :(NSObject*)info :(UIImage*)image{
    self = [super init];
    
    if (self) {
        self.timeInfoText = timeInfoText;
        self.subtitle = subtitle;
        self.info = info;
        self.image = image;
    }
    
    return self;
}

@end
