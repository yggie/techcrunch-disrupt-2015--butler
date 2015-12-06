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
#import "Food.h"
#import "CineworldFilm.h"

@interface CineworldApiWrapper : JSONModel

@property (strong, nonatomic) NSArray<CineworldFilm*> *films;

@end

@implementation CineworldApiWrapper
@end

@implementation ScheduleService {
    HummAPI *humm;
    BOOL hummAuthenticated;
    NSArray<Sky*> *movies;
    NSArray<Food*> *foods;
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
    
    
    NSMutableArray<Food*> *foodList = [NSMutableArray new];
    [foodList addObject:[[Food new] name:@"Ham & Mushroom Pizza" :@"30 minutes" :@"ham.jpg" :4 :@"Dominos"]];
    [foodList addObject:[[Food new] name:@"Lamb Burrito" :@"15 minutes" :@"burrito.jpg" :5 :@"Maximum Burritos"]];
    [foodList addObject:[[Food new] name:@"Tandoori Chicken" :@"3 minutes" :@"chicken.jpg" :3 :@"Cheeky Indian"]];
    [foodList addObject:[[Food new] name:@"Pumpkin Ravioli" :@"60 minutes" :@"pumpkin.jpg" :2 :@"Maxwell’s Cafe"]];
    [foodList addObject:[[Food new] name:@"Fresh Crab Spaghetti" :@"7 minutes" :@"pasta.jpg" :1 :@"Seafood Paradise"]];
    [foodList addObject:[[Food new] name:@"Railway Beef Rice" :@"5 minutes" :@"rice.jpg" :4 :@"Texas Original"]];
    
    
    self->movies = movieList;
    self->foods = foodList;

    return self;
}

- (void)getNewSchedule:(void(^)(NSArray*))callback {
    [self loadPlaylist:^(NSArray<Song*>* songs) {
        NSMutableArray *array = [NSMutableArray new];
        
        Sky *skyInfo = [self pickSkyProgram];
        NSString *timeInfoText = @"starts at 23:00";
        NSString *subtitle = skyInfo.genre;
        
        ScheduleItem *skyItem = [[ScheduleItem alloc] initWithInfo:timeInfoText :subtitle :skyInfo :skyInfo.image];
        
        [array addObject:skyItem];
        
        Food *foodInfo = [self pickFood];
        NSString *foodTimeInfoText = @"30 mins";
        NSString *foodSubtitle = foodInfo.restaurant;
        
        ScheduleItem *foodItem = [[ScheduleItem alloc] initWithInfo:foodTimeInfoText :foodSubtitle :foodInfo :foodInfo.image];
        
        [array addObject:foodItem];
        
        for (Song *song in songs) {
            NSString *songTimeInfoText = @"2 hrs";
            NSString *songSubtitle = [song.genres componentsJoinedByString:@", "];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", @"http://i.ytimg.com/vi", [song.foreign_ids objectForKey:@"youtube"], @"mqdefault.jpg"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            UIImage *image = [[UIImage alloc] initWithData:data];
            
            ScheduleItem *item = [[ScheduleItem alloc] initWithInfo:songTimeInfoText :songSubtitle :song :image];
            
            [array addObject:item];
        }
        
        NSString *json = [self getDataFrom:@"http://www2.cineworld.co.uk/api/quickbook/films?key=tQV@xYvf&cinema=23&date=20151208&full=true"];
        NSError *error = nil;
        
        NSLog(json);
        
        CineworldApiWrapper *wrapper = [[CineworldApiWrapper alloc] initWithString:json error:&error];
        
        NSDictionary *film = [wrapper.films objectAtIndex:arc4random_uniform([wrapper.films count])];
        
        NSData *filmImageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[film objectForKey:@"still_url"]]];
        UIImage *filmImage = [[UIImage alloc] initWithData:filmImageData];
        
        ScheduleItem *filmItem = [[ScheduleItem alloc] initWithInfo:@"Now showing" :@"Cineworld" :film :filmImage];
        
        [array addObject:filmItem];
        
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


-(Food *)pickFood{
//    NSLog([self->foods count]);
    int random = arc4random_uniform([self->foods count]);
    return (Food *)[self->foods objectAtIndex:random];
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
        NSLog(@"Humm AUTHENTICATED");
        [self->humm.playlists getRecentWithLimit:20 offset:0 success:^(NSArray<Playlist*> *playlists) {
            Playlist *playlist = [playlists objectAtIndex:((NSUInteger)arc4random_uniform([playlists count]))];
            
            NSLog(@"Found %i playlists", (NSInteger)[playlists count]);
            
            [self->humm.playlists getSongs:playlist._id limit:1 offset:0 success:^(NSArray<Song *> *songs) {
                callback(songs);
            } error:^(NSError *error) {
                NSLog(@"ERROR:", error);
            }];
        } error:^(NSError *error) {
            NSLog(@"ERROR:", error);
        }];
    }];
}

- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}

@end

