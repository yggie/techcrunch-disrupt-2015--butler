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
@interface ViewController ()

@property (nonatomic) HummAPI *humm;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.humm = [HummAPI sharedManager];
    // Do any additional setup after loading the view, typically from a nib.
    [self authenticateHumm];
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

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//
//    
//}

@end
