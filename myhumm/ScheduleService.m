//
//  ScheduleService.m
//  MyButler
//
//  Created by Bryan Yap on 05/12/2015.
//  Copyright © 2015 Neetesh Gupta. All rights reserved.
//

#include <stdlib.h>
#import "ScheduleService.h"
#import "ScheduleItem.h"

@implementation ScheduleService

- (ScheduleService*)init {
    self = [super init];

    self->calendar = [NSCalendar currentCalendar];

    return self;
}

- (NSArray*)someArray {
    NSMutableArray *array = [NSMutableArray new];

    NSDate *startDate = [self dateAt:20 :0];
    NSDate *endDate = [self dateAt:21 :0];
    ScheduleItem *item = [[ScheduleItem alloc] initWithInfo:startDate :endDate :[NSNumber numberWithInt:arc4random_uniform(74)]];

    [array addObject:item];

    NSDate *startDate1 = [self dateAt:21 :0];
    NSDate *endDate1 = [self dateAt:22 :30];
    ScheduleItem *item1 = [[ScheduleItem alloc] initWithInfo:startDate1 :endDate1 :[NSNumber numberWithInt:arc4random_uniform(74)]];

    [array addObject:item1];

    NSDate *startDate2 = [self dateAt:22 :30];
    NSDate *endDate2 = [self dateAt:23 :45];
    ScheduleItem *item2 = [[ScheduleItem alloc] initWithInfo:startDate2 :endDate2 :[NSNumber numberWithInt:arc4random_uniform(74)]];

    [array addObject:item2];

    return array;
}

- (NSDate*)dateAt:(NSInteger)hour :(NSInteger)minute {
    NSDateComponents *components = [self->calendar components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate new]];

    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:0];

    return [self->calendar dateFromComponents:components];
}

@end

