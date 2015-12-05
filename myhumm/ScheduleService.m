//
//  ScheduleService.m
//  MyButler
//
//  Created by Bryan Yap on 05/12/2015.
//  Copyright © 2015 Neetesh Gupta. All rights reserved.
//

#include <stdlib.h>
#import "HummAPI.h"
#import "PlaylistsAPI.h"
#import "Song.h"
#import "ScheduleService.h"
#import "ScheduleItem.h"

@implementation ScheduleService {
    HummAPI *humm;
}

- (ScheduleService*)init {
    self = [super init];

    self->calendar = [NSCalendar currentCalendar];
    
    self->humm = [HummAPI sharedManager];
    [self authenticateHumm];

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

#pragma mark HUMM

-(void)authenticateHumm{
    [self->humm loginWithUsername:@"kanke" password:@"Windows6" onLoginSuccess:^{
        [self getPlaylist];
    } onLoginError:^(NSError *error) {
        NSLog(@"There was an error");
    }];
}

-(void)getPlaylist {
    [self->humm.playlists getSongs:@"56403fd834017507dba11880" limit:20 offset:0 success:^(NSArray<Song *> *response) {
        
        for (Song *song in response) {
            NSLog(@"song name = %@", song.title);
        }
        
    } error:^(NSError *error) {
        
    }];
}

@end

