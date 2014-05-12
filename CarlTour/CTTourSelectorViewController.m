//
//  CTTourSelectorViewController.m
//  CarlTour
//
//  Created by Lab User on 5/11/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTTourSelectorViewController.h"

@interface CTTourSelectorViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tours;

@end

@implementation CTTourSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tours count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"ToursTableViewCell" forIndexPath:indexPath];
    
    CTTour *tour = [self.tours objectAtIndex:indexPath.row];
    
    UILabel *title = (UILabel *)[cell viewWithTag:1];
    title.text = tour.name;
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tours = [CTResourceManager sharedManager].tourList;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
