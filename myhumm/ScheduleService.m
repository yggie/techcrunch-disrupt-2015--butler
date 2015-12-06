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
#import "Sky.h"

@implementation ScheduleService {
    HummAPI *humm;
    BOOL hummAuthenticated;
    NSArray<Sky*> *movies;
}

- (ScheduleService*)init {
    self = [super init];

    self->calendar = [NSCalendar currentCalendar];
    
    self->humm = [HummAPI sharedManager];
    self->hummAuthenticated = false;
    
    NSMutableArray<Sky*> *movieList = [NSMutableArray new];
    [movieList addObject:[[Sky new] name:@"RTÉ News: One O'Clock and Farming Weather" :@"news" :@"1.jpeg"]];
    [movieList addObject:[[Sky new] name:@"The Simpsons: The Changing of the Guardian" :@"animation;comedy" :@"2.jpeg"]];
    [movieList addObject:[[Sky new] name:@"Henry Danger: Mo' Danger, Mo' Problems" :@"comedy" :@"3.jpeg"]];
    [movieList addObject:[[Sky new] name:@"Through the Night" :@"news" :@"4.jpeg"]];
    [movieList addObject:[[Sky new] name:@"The Green Green Grass: Brothers and Sisters" :@"comedy" :@"5.jpeg"]];
    [movieList addObject:[[Sky new] name:@"Family Guy: Untitled Griffin Family History" :@"animation;comedy" :@"6.jpeg"]];
    [movieList addObject:[[Sky new] name:@"Austin & Ally: Relationships & Red Carpets" :@"comedy" :@"7.jpeg"]];
    [movieList addObject:[[Sky new] name:@"Hospital Sydney" :@"medical;reality" :@"8.jpeg"]];
    [movieList addObject:[[Sky new] name:@"Chuggington: Back Up Brewster" :@"cartoons" :@"9.jpeg"]];
    [movieList addObject:[[Sky new] name:@"Get Your Rocks Off!" :@"rock" :@"10.jpeg"]];
    
    self->movies = movieList;

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
        
        Sky *skyInfo = [self pickSkyProgram];
        NSDate *skyStartDate = [self dateAt:22 :0];
        NSDate *skyEndDate = [self dateAt:23 :0];
        
        ScheduleItem *skyItem = [[ScheduleItem alloc] initWithInfo:skyStartDate :skyEndDate :skyInfo :skyInfo.image];
        
        [array addObject:skyItem];
        
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

#pragma mark SKY

-(Sky *)pickSkyProgram{
    int random = arc4random_uniform([self->movies count]);
    return (Sky *)[self->movies objectAtIndex:random];
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
            } error:^(NSError *error) {
                NSLog(error);
            }];
        } error:^(NSError *error) {
            NSLog(error);
        }];
    }];
}

@end

