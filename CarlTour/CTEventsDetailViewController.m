//
//  CTEventsDetailViewController.m
//  CarlTour
//
//  Created by Daniel Alabi on 5/9/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTEventsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CTEventsDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventTitle;

@property (weak, nonatomic) IBOutlet UIView *eventTimeContainer;
@property (weak, nonatomic) IBOutlet UILabel *eventTime;


@property (weak, nonatomic) IBOutlet UIView *eventLocationContainer;
@property (weak, nonatomic) IBOutlet UILabel *eventLocation;


@property (weak, nonatomic) IBOutlet UIView *eventDescriptionContainer;
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
    self.eventTitle.text = [event title];
    self.eventTime.text = [event getReadableFullFormat];
    CTRoomLocation *eventLocation = [event location];
    self.eventLocation.text = [NSString stringWithFormat:@"%@ in %@",
                                [eventLocation roomDescription],
                                [[eventLocation building] name]];
    self.eventDescription.text = [event eventDescription];

    for (UILabel *label in @[self.eventTitle,
                             self.eventTime,
                             self.eventDescription,
                             self.eventLocation]) {
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    for (UIView *view in @[self.eventTimeContainer,
                             self.eventLocationContainer,
                             self.eventDescriptionContainer]) {
        [view.layer setCornerRadius:5];
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
    // self.navigationItem.title = [[self currentEvent] title];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}

// Hide it as we don't need it on the map screen.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
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
