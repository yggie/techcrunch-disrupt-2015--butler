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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
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
    } else if ([item.info isKindOfClass:[Sky class]]) {
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        Sky *sky = (Sky*)item.info;
        
        label.text = sky.name;
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

