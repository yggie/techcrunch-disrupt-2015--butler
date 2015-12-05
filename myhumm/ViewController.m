////
////  ViewController.m
////  myhumm
////
////  Created by Kankemwa Ishaku on 05/12/2015.
////  Copyright © 2015 Kankemwa Ishaku. All rights reserved.
////
//
//#import "ViewController.h"
//#import "ScheduleService.h"
//@interface ViewController ()
//
//@property NSArray *myArray;
//@property ScheduleService *service;
//
//@end
//
//@implementation ViewController
//
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    self.humm = [HummAPI sharedManager];
//    // Do any additional setup after loading the view, typically from a nib.
//    [self authenticateHumm];
//    
//    self.service = [ScheduleService new];
//    
//    self.myArray = [self.service someArray];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

//
//#pragma mark DELEGATE
//
//#pragma mark DATA SOURCE
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [self.myArray count];
//}
//
//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"some_cell"];
//    
//    UILabel *label = (UILabel*)[cell viewWithTag:1];
//    label.text = [[self.myArray objectAtIndex:indexPath.row] stringValue];
//    
//    return cell;
//}
//
//#pragma mark SHAKE GESTURES
//
//-(BOOL)canBecomeFirstResponder {
//    return YES;
//}
//
//- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    if (motion == UIEventSubtypeMotionShake) {
//        self.myArray = [self.service someArray];
//        [self.tableView reloadData];
//    }
//}
//
//
//@end

//
//  ViewController.m
//  MyButler
//
//  Created by NG on 05/12/15.
//  Copyright (c) 2015 Neetesh Gupta. All rights reserved.
//

#import "ViewController.h"
#import "HummAPI.h"
#import "PlaylistsAPI.h"
#import "Song.h"
#import "ScheduleService.h"
#import "ScheduleItem.h"

@interface ViewController () {
    NSDateFormatter *formatter;
}

@property (nonatomic) HummAPI *humm;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *scheduleItems;
@property ScheduleService *service;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.humm = [HummAPI sharedManager];
    [self authenticateHumm];
    
    self.service = [ScheduleService new];
    
    self.scheduleItems = [self.service someArray];
    
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

#pragma mark HUMM

-(void)authenticateHumm{
    [self.humm loginWithUsername:@"kanke" password:@"Windows6" onLoginSuccess:^{
        [self getPlaylist];
    } onLoginError:^(NSError *error) {
        NSLog(@"There was an error");
    }];
}

-(void)getPlaylist{
    [self.humm.playlists getSongs:@"56403fd834017507dba11880" limit:20 offset:0 success:^(NSArray<Song *> *response) {

        for (Song  *song in response)
        {
            NSLog(@"song name = %@", song.title);
        }

    } error:^(NSError *error) {

    }];
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
    
    if ([item.info isKindOfClass:[NSNumber class]]) {
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        label.text = [((NSNumber*)item.info) stringValue];
    }
    
    return cell;
}

#pragma mark SHAKE GESTURES

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.scheduleItems = [self.service someArray];
        [self.tableView reloadData];
    }
}

@end

