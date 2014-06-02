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
@property (weak, nonatomic) IBOutlet UIButton *startTourButton;
@property (strong, nonatomic) NSMutableArray *tours;
@property (strong, nonatomic) CTTour *selectedTour;

//@property (strong, nonatomic) CTTourViewController *tourViewController;
@end

@implementation CTTourSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedTour = [self.tours objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    CTTourViewController *tourVC =[self.storyboard instantiateViewControllerWithIdentifier:@"TourMapViewController"];
    tourVC.tour = self.selectedTour;
    [self.navigationController pushViewController:tourVC animated:true];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.navigationController.navigationBar.barTintColor = [CTConstants CTCarletonMaizeColor];
    self.selectedTour = nil;
	// Do any additional setup after loading the view.
    self.tours = [CTResourceManager sharedManager].tourList;
    
    // this eleiminates extra table rows. See http://stackoverflow.com/a/14520593/1739725
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
