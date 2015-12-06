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
#import "Food.h"
#import "CineworldFilm.h"

@interface ViewController () {
    NSDateFormatter *formatter;
    UIActivityIndicatorView *indicator;
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
    
    self->indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self->indicator.frame = CGRectMake(0.0, 0.0, self.view.bounds.size.width, self.view.bounds.size.height);
    self->indicator.center = self.view.center;
    [self->indicator setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.6f]];
    [self.view addSubview:self->indicator];
    [self->indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark DELEGATE

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleItem *item = [self.scheduleItems objectAtIndex:indexPath.row];
    
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentModalViewController:picker animated:YES];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
    NSLog(@"Picked Person:", name);
    [self displayPerson:person];
    [self dismissModalViewControllerAnimated:YES];
    
    return NO;
}

- (void)displayPerson:(ABRecordRef)person
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
//    self.firstName.text = name;
    
    NSString* phone = nil;
    ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                     kABPersonPhoneProperty);
    if (ABMultiValueGetCount(phoneNumbers) > 0) {
        phone = (__bridge_transfer NSString*)
        ABMultiValueCopyValueAtIndex(phoneNumbers, 0);
    } else {
        phone = @"[None]";
    }
//    self.phoneNumber.text = phone;
    CFRelease(phoneNumbers);
}


#pragma mark DATA SOURCE

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.scheduleItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleItem *item = [self.scheduleItems objectAtIndex:indexPath.row];
    
    UITableViewCell *cell =[self.tableView dequeueReusableCellWithIdentifier:@"some_cell"];
    
    UILabel *startTimeLabel = (UILabel*)[cell viewWithTag:2];
    startTimeLabel.text = item.timeInfoText;
    
    UILabel *endTimeLabel = (UILabel*)[cell viewWithTag:5];
    endTimeLabel.text = item.subtitle;
    
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:4];
    imageView.image = item.image;
    
    UIImageView *footerImageView = (UIImageView*)[cell viewWithTag:7];
    UIImageView *playImageView = (UIImageView*)[cell viewWithTag:9];
    playImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    if ([item.info isKindOfClass:[Song class]]) {
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        Song *song = (Song*)item.info;
        
        label.text = song.title;
        
        footerImageView.image = [UIImage imageNamed:@"musicft.png"];
        playImageView.image = [UIImage imageNamed:@"play_button.png"];
    } else if ([item.info isKindOfClass:[Sky class]]) {
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        Sky *sky = (Sky*)item.info;
        
        label.text = sky.name;
        
        footerImageView.image = [UIImage imageNamed:@"movieft.png"];
        playImageView.image = nil;
    } else if ([item.info isKindOfClass:[Food class]]) {
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        Food *food = (Food*)item.info;
        
        label.text = food.name;
        
        footerImageView.image = [UIImage imageNamed:@"foodft.png"];
        playImageView.image = nil;
    } else if ([item.info isKindOfClass:[NSDictionary class]]) {
        UILabel *label = (UILabel*)[cell viewWithTag:1];
        NSDictionary *film = (NSDictionary*)item.info;
    
        label.text = [film objectForKey:@"title"];
    
        footerImageView.image = [UIImage imageNamed:@"movieft.png"];
        playImageView.image = nil;
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
    [self->indicator startAnimating];
    [self.service getNewSchedule:^(NSArray *scheduleItems) {
        NSLog(@"New schedule LOADED");
        self.scheduleItems = scheduleItems;
        
        [self->indicator stopAnimating];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationRight];
    }];
}

@end

