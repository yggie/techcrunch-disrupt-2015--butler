//
//  ScheduleService.h
//  MyButler
//
//  Created by Bryan Yap on 05/12/2015.
//  Copyright © 2015 Neetesh Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleService : NSObject {
    NSCalendar *calendar;
}

- (ScheduleService*)init;
- (void)getNewSchedule:(void(^)(NSArray*))callback;

@end
