//
//  CTBuildingDetailViewController.m
//  CarlTour
//
//  Created by Lab User on 5/7/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTBuildingDetailViewController.h"
#import "CTEvent.h"
#import "CTEventsDetailViewController.h"

@interface CTBuildingDetailViewController ()

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UITextView* descrTextView;

@end

@implementation CTBuildingDetailViewController

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
	// Do any additional setup after loading the view.
}

// Show the navigation bar so we can go back.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateBuilding];
}

// Hide it as we don't need it on the map screen.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma Mark non-VC methods
- (void) updateBuilding
{
    self.title = self.building.name;
    // Set this to actual description
    self.descrTextView.text = self.building.name;
    // TODO: Obviously make this not just goodsell...
    self.imageView.image = [UIImage imageNamed:@"goodsell"];
    
    // load events for this particular building
    self.events = self.building.events;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EventsTableViewCell" forIndexPath:indexPath];
    
    CTEvent *event = [self.events objectAtIndex:indexPath.row];
    UILabel *titleLabel, *timeLabel, *locationLabel;
    
    // set event title text
    titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = [NSString stringWithFormat:@"%@", [event title]];
    // set event time text
    timeLabel = (UILabel *)[cell viewWithTag:2];
    timeLabel.text = [NSString stringWithFormat:@"%@", [event getRelativeFormat]];
    // set event location text
    locationLabel = (UILabel *)[cell viewWithTag:3];
    locationLabel.text = [NSString stringWithFormat:@"%@", [[event location] roomDescription]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedEvent = [self.events objectAtIndex:indexPath.row];
    
    CTEventsDetailViewController *controller =
    [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
     instantiateViewControllerWithIdentifier:@"CTEventsDetail"];
    
    // pass in the data for the selected event to CTEventsDetailViewController and open
    controller.currentEvent = [self selectedEvent];
    [self.navigationController pushViewController: controller animated:YES];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return the number of rows to display
    return [self.events count];
}



@end
