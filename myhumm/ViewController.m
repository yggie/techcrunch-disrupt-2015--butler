//
//  ViewController.m
//  myhumm
//
//  Created by Kankemwa Ishaku on 05/12/2015.
//  Copyright © 2015 Kankemwa Ishaku. All rights reserved.
//

#import "ViewController.h"
#import "HummAPI.h"
#import "PlaylistsAPI.h"
#import "Song.h"
#import "ScheduleService.h"
@interface ViewController ()

@property (nonatomic) HummAPI *humm;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSArray *myArray;
@property ScheduleService *service;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.humm = [HummAPI sharedManager];
    // Do any additional setup after loading the view, typically from a nib.
    [self authenticateHumm];
    
    self.service = [ScheduleService new];
    
    self.myArray = [self.service someArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)authenticateHumm{
    
    [self.humm loginWithUsername:@"kanke" password:@"Windows6" onLoginSuccess:^{
        [self getPlaylist];
    } onLoginError:^(NSError *error) {
        
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
    return [self.myArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"some_cell"];
    
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    label.text = [[self.myArray objectAtIndex:indexPath.row] stringValue];
    
    return cell;
}

#pragma mark SHAKE GESTURES

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake) {
        self.myArray = [self.service someArray];
        [self.tableView reloadData];
    }
}


@end
