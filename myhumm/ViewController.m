//
//  ViewController.m
//  MyButler
//
//  Created by NG on 05/12/15.
//  Copyright (c) 2015 Neetesh Gupta. All rights reserved.
//

#import "ViewController.h"
#import "ScheduleService.h"
#import "ScheduleItem.h"
#import "Sky.h"
#import "Song.h"

@interface ViewController () {
    NSDateFormatter *formatter;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *scheduleItems;
@property ScheduleService *service;
@property NSMutableArray *movieList;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.hidesBackButton = YES;
    
    self.service = [ScheduleService new];
    
    [self loadNewSchedule];
    
    self->formatter = [NSDateFormatter new];
    [self->formatter setDateFormat:@"HH:mm"];
    
    //Sky *movie = [Sky new];
    //movie.name =@"Epic kk movie";
    //movie.genre = @"horror";
    _movieList = [NSMutableArray new];
    [_movieList addObject:[[Sky new] name:@"RTÉ News: One O'Clock and Farming Weather" :@"news" :@"1"]];
    [_movieList addObject:[[Sky new] name:@"The Simpsons: The Changing of the Guardian" :@"animation;comedy" :@"2"]];
    [_movieList addObject:[[Sky new] name:@"Henry Danger: Mo' Danger, Mo' Problems" :@"comedy" :@"3"]];
    [_movieList addObject:[[Sky new] name:@"Through the Night" :@"news" :@"4"]];
    [_movieList addObject:[[Sky new] name:@"The Green Green Grass: Brothers and Sisters" :@"comedy" :@"5"]];
    [_movieList addObject:[[Sky new] name:@"Family Guy: Untitled Griffin Family History" :@"animation;comedy" :@"6"]];
    [_movieList addObject:[[Sky new] name:@"Austin & Ally: Relationships & Red Carpets" :@"comedy" :@"7"]];
    [_movieList addObject:[[Sky new] name:@"Hospital Sydney" :@"medical;reality" :@"8"]];
    [_movieList addObject:[[Sky new] name:@"Chuggington: Back Up Brewster" :@"cartoons" :@"9"]];
    [_movieList addObject:[[Sky new] name:@"Get Your Rocks Off!" :@"rock" :@"10"]];
    
    
}

-(Sky *)randomiseSky{
    int random = arc4random_uniform(9);
    return (Sky *)[_movieList objectAtIndex:random];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    Sky *randomSky = [self randomiseSky];
    NSLog(@"Random name: %@", randomSky.name);
}

- (void)viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidAppear:animated];
}

#pragma mark DELEGATE

#pragma mark DATA SOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.scheduleItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleItem *item = [self.scheduleItems objectAtIndex:indexPath.row];
    
    UITableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"some_cell"];
    
    UILabel *startTimeLabel = (UILabel*)[cell viewWithTag:2];
    startTimeLabel.text = [self->formatter stringFromDate:item.startTime];
    
    UILabel *endTimeLabel = (UILabel*)[cell viewWithTag:3];
    endTimeLabel.text = [self->formatter stringFromDate:item.endTime];
    
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:4];
    imageView.image = item.image;
    
    if ([item.info isKindOfClass:[Song class]]) {
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        Song *song = (Song*)item.info;
        
        label.text = song.title;
    }
    
    return cell;
}

#pragma mark SHAKE GESTURES

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        [self loadNewSchedule];
    }
}

- (void)loadNewSchedule {
    [self.service getNewSchedule:^(NSArray *scheduleItems) {
        self.scheduleItems = scheduleItems;
        [self.tableView reloadData];
    }];
}

@end

