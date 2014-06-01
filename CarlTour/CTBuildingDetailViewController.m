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
#import "CTResourceManager.h"
#import "CTEventBuilder.h"

@interface CTBuildingDetailViewController ()

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) IBOutlet UITextView* descrTextView;
@property CTResourceManager *manager;
@property UITableView *tableView;

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
    if (self.building.events == nil) {
        [self.manager fetchEventsFor:self];
    }
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    [self updateBuilding];
    // Hide the building description to start with
    [self.descrTextView setHidden:YES];
}

// Hide it as we don't need it on the map screen.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

- (IBAction)toggleDescriptionViewable:(id)sender
{
    // Animation help from:
    // http://stackoverflow.com/questions/12622424/how-do-i-animate-constraint-changes
    if([self.descrTextView isHidden]) {
        NSLog(@"Was hidden, about to show");
        [self.descrTextView setHidden: NO];
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.descriptionHeight.constant = 131.0;
                             [self.descrTextView setAlpha:1.0f];
                             [self.view layoutIfNeeded];
                         }
         ];
        
    } else {
        NSLog(@"HIDING NOW. Used to be shown");
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.descriptionHeight.constant = 0.0;
                             [self.descrTextView setAlpha:0.0f];
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                                [self.descrTextView setHidden: YES];
                         }
         ];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateDisplayForEvents {
    [self updateBuilding];
}


# pragma Mark non-VC methods
- (void) updateBuilding
{
    self.title = self.building.name;
    // Why do I need to do this?
    self.navigationItem.backBarButtonItem.title = @"Back";
    self.descrTextView.text = self.building.buildingDescription;
    // TODO: Obviously make this not just goodsell...
    self.imageView.image = [UIImage imageNamed:@"goodsell"];
    
    // load events for this particular building
    self.events = [CTEventBuilder sortByTime:self.building.events];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EventsTableViewCell" forIndexPath:indexPath];
    
    CTEvent *event = [self.events objectAtIndex:indexPath.row];
    UILabel *titleLabel, *timeLabel, *locationLabel;
    
    // set event title text
    titleLabel = (UILabel *)[cell viewWithTag:1];
    titleLabel.text = [event title];
    // set event time text
    timeLabel = (UILabel *)[cell viewWithTag:2];
    timeLabel.text = [event getReadableStartFormat];
    // set event location text
    locationLabel = (UILabel *)[cell viewWithTag:3];
    locationLabel.text = [[event location] roomDescription];
    
    self.tableView = tableView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
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
