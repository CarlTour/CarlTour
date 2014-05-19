//
//  CTEventsTableViewController.m
//  CarlTour
//
//  Created by Daniel Alabi on 5/7/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTEventsTableViewController.h"
#import "CTResourceManager.h"
#import "CTEvent.h"
#import "CTEventsDetailViewController.h"

@interface CTEventsTableViewController ()

@end

@implementation CTEventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.allEvents == nil) {
        self.allEvents = [[NSMutableArray alloc] init];
    }
    
    CTResourceManager *manager = [CTResourceManager sharedManager];
    for (CTEvent *event in manager.eventList) {
        [self.allEvents addObject:event];
    }
    self.filteredEvents = [NSMutableArray arrayWithArray:self.allEvents];
    
    // set delegate and data source for self.searchDisplayController here
    [self.searchDisplayController setDelegate:self];
    [self.searchDisplayController setSearchResultsDataSource:self];
    [self.searchDisplayController setSearchResultsDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // return the number of rows to display
    return [self.filteredEvents count];
}

- (void) sort {
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey: @"time" ascending:YES];
    [self.filteredEvents sortUsingDescriptors:[NSArray arrayWithObject:timeSort]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // filter by "title", "eventDescription", and "location.roomDescription".
    NSArray *searchProperties = @[@"title", @"location.roomDescription", @"eventDescription"];

    // Remove all objects from the filtered search array
    [self.filteredEvents removeAllObjects];
    NSPredicate *predicate;
    NSMutableArray *events;
    for (NSString *searchType in searchProperties) {
        predicate = [NSPredicate predicateWithFormat:@"SELF.%@ contains[c] %@", searchType, searchText];
        events = [NSMutableArray arrayWithArray:[self.allEvents filteredArrayUsingPredicate:predicate]];
        for (CTEvent *event in events) {
            if (![self.filteredEvents containsObject:event]) {
                NSLog(@"called");
                [self.filteredEvents addObject:event];
            }
        }
    }
    if ([self.filteredEvents count] == 0) {
        self.filteredEvents = [NSMutableArray arrayWithArray:self.allEvents];
    }
    [self sort];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EventsTableViewCell" forIndexPath:indexPath];

    CTEvent *event = [self.filteredEvents objectAtIndex:indexPath.row];
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    // when search cancel bar is clicked, reset search bar
    self.eventsSearchBar.text = @"";
    self.filteredEvents = [NSMutableArray arrayWithArray:self.allEvents];
    [self sort];
    [self.tableView reloadData];
    [self.eventsSearchBar resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedEvent = [self.filteredEvents objectAtIndex:indexPath.row];
    
    CTEventsDetailViewController *controller =
    [[UIStoryboard storyboardWithName:@"Main" bundle:NULL]
     instantiateViewControllerWithIdentifier:@"CTEventsDetail"];
    
    // pass in the data for the selected event to CTEventsDetailViewController and open
    controller.currentEvent = [self selectedEvent];    
    [self.navigationController pushViewController: controller animated:YES];

}


@end
