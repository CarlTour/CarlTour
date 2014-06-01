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

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UITextView *descrTextView;
@property (weak, nonatomic) IBOutlet UITableView *eventsTableView;
@property CTResourceManager *manager;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionArrow;
@property (weak, nonatomic) IBOutlet UIImageView *eventsArrow;
@property BOOL *initialLoad;

// Helpful stackoverflow: http://stackoverflow.com/questions/14189362/animating-an-image-view-to-slide-upwards/14190042#14190042
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventsTableHeightConstraint;
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
    self.eventsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    [self.view layoutIfNeeded];
    if (self.initialLoad) {
        [self.eventsTableView setHidden:YES];
        [self.descrTextView setHidden:YES];
        [self.descriptionArrow setImage:[UIImage imageNamed:@"down_arrow"]];
        [self.eventsArrow setImage:[UIImage imageNamed:@"down_arrow"]];
        self.descriptionHeightConstraint.constant = 0;
    }
    self.initialLoad = NO;
}

// Hide it as we don't need it on the map screen.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)setNewBuilding:(CTBuilding *)building
{
    self.building = building;
    self.initialLoad = YES;
}

- (IBAction)toggleDescriptionViewable:(id)sender
{
    // Animation help from:
    // http://stackoverflow.com/questions/12622424/how-do-i-animate-constraint-changes
    if([self.descrTextView isHidden]) {
        [self.descrTextView setHidden: NO];
        [self.descriptionArrow setImage:[UIImage imageNamed:@"up_arrow"]];
        [self.view layoutIfNeeded];
        CGSize sizeThatShouldFitTheContent = [self.descrTextView
                                              sizeThatFits:self.descrTextView.frame.size];
        
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.descriptionHeightConstraint.constant = sizeThatShouldFitTheContent.height;
                             [self.descrTextView setAlpha:1.0f];
                             [self.view layoutIfNeeded];
                         }
         ];
        
    } else {
        [self.descriptionArrow setImage:[UIImage imageNamed:@"down_arrow"]];
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.descriptionHeightConstraint.constant = 0.0;
                             [self.descrTextView setAlpha:0.0f];
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                                [self.descrTextView setHidden: YES];
                         }
         ];
    }
    
}
- (IBAction)toggleEventsViewable:(id)sender {
    
    if([self.eventsTableView isHidden]) {
        [self.eventsTableView setHidden: NO];
        [self.eventsArrow setImage:[UIImage imageNamed:@"up_arrow"]];
        [self.view layoutIfNeeded];

        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.eventsTableHeightConstraint.constant = [self.eventsTableView contentSize].height;
                             [self.eventsTableView setAlpha:1.0f];
                             [self.view layoutIfNeeded];
                         }
         ];
        
    } else {
        [self.view layoutIfNeeded];
        [self.eventsArrow setImage:[UIImage imageNamed:@"down_arrow"]];
        [UIView animateWithDuration:0.5f
                         animations:^{
                             self.eventsTableHeightConstraint.constant = 0.0;
                             [self.eventsTableView setAlpha:0.0f];
                             [self.view layoutIfNeeded];
                         }
                         completion:^(BOOL finished) {
                             [self.eventsTableView setHidden: YES];
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
    self.imageView.image = [UIImage imageNamed:self.building.imagePath];
    
    // load events for this particular building
    self.events = [CTEventBuilder sortByTime:self.building.events];
    [self.eventsTableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.events count] == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EventsTableViewNoEventsCell" forIndexPath:indexPath];
        return cell;
    }
    else
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
        
        self.eventsTableView = tableView;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    // They selected the "no events" item, ignore it.
    if ([self.events count] == 0) { return; }
    
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
    // return the number of rows to display, or 1 which says there are no events
    return MAX(1, [self.events count]);
}



@end
