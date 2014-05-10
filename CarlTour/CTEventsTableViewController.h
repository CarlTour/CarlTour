//
//  CTEventsTableViewController.h
//  CarlTour
//
//  Created by Daniel Alabi on 5/7/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CTEvent.h"

@interface CTEventsTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property NSMutableArray *allEvents;
@property NSMutableArray *filteredEvents;
@property CTEvent *selectedEvent;
@property (weak, nonatomic) IBOutlet UISearchBar *eventsSearchBar;

@end
