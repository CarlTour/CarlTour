//
//  CTEventsDetailViewController.m
//  CarlTour
//
//  Created by Daniel Alabi on 5/9/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTEventsDetailViewController.h"

@interface CTEventsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTime;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;
@property (weak, nonatomic) IBOutlet UILabel *eventDescription;

@end

@implementation CTEventsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CTEvent *event = [self currentEvent];
    
    // set label text 
    self.eventTime.text = [event getReadableFullFormat];
    CTRoomLocation *eventLocation = [event location];
    self.eventLocation.text = [NSString stringWithFormat:@"%@ in %@",
                                [eventLocation roomDescription],
                                [[eventLocation building] name]];
    self.eventDescription.text = [event eventDescription];

    for (UILabel *label in @[self.eventTime, self.eventLocation, self.eventDescription]) {
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Show the navigation bar so we can go back.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    self.navigationItem.title = [[self currentEvent] title];
}

// Hide it as we don't need it on the map screen.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
