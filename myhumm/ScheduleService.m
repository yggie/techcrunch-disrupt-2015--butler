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
    BOOL hummAuthenticated;
}

- (ScheduleService*)init {
    self = [super init];

    self->calendar = [NSCalendar currentCalendar];
    
    self->humm = [HummAPI sharedManager];
    self->hummAuthenticated = false;

    return self;
}

- (void)getNewSchedule:(void(^)(NSArray*))callback {
    [self loadPlaylist:^(NSArray<Song*>* songs) {
        NSMutableArray *array = [NSMutableArray new];
        
        for (Song *song in songs) {
            NSDate *startDate = [self dateAt:20 :0];
            NSDate *endDate = [self dateAt:21 :0];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", @"http://i.ytimg.com/vi", [song.foreign_ids objectForKey:@"youtube"], @"mqdefault.jpg"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            ScheduleItem *item = [[ScheduleItem alloc] initWithInfo:startDate :endDate :song :image];
            [array addObject:item];
        }
        
        callback(array);
    }];
}

- (NSDate*)dateAt:(NSInteger)hour :(NSInteger)minute {
    NSDateComponents *components = [self->calendar components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate new]];

    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:0];

    return [self->calendar dateFromComponents:components];
}

#pragma mark HUMM

-(void)authenticateHumm:(void(^)(void))callback {
    if (self->hummAuthenticated) {
        callback();
    } else {
        [self->humm loginWithUsername:@"kanke" password:@"Windows6" onLoginSuccess:^{
            NSLog(@"Login successful");
            self->hummAuthenticated = true;
            callback();
        } onLoginError:^(NSError *error) {
            NSLog(@"There was an error");
        }];
    }
}

-(void)loadPlaylist:(void(^)(NSArray<Song*>*))callback {
    [self authenticateHumm:^{
        [self->humm.playlists getRecentWithLimit:20 offset:0 success:^(NSArray<Playlist*> *playlists) {
            Playlist *playlist = [playlists objectAtIndex:((NSUInteger)arc4random_uniform([playlists count]))];
            
            [self->humm.playlists getSongs:playlist._id limit:10 offset:0 success:^(NSArray<Song *> *songs) {
                
                callback(songs);
                //        for (Song *song in response) {
                //            NSLog(@"song name = %@", song.title);
                //        }
                
            } error:^(NSError *error) {
                
            }];
        } error:^(NSError *error) {
            
        }];
    }];
}

@end

