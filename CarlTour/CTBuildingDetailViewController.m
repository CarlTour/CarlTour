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
#import "CTTextSection.h"
#import "CTTableSectionProtocol.h"

@interface CTBuildingDetailViewController ()


@property (nonatomic) NSMutableArray *sectionInfoArray;
@property (nonatomic) NSInteger openSectionIndex;
@property (nonatomic) CTTextSection *descrTextSection;
@property (nonatomic) CTTextSection *dummyTextSection;


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
    self.descrTextSection = [[CTTextSection alloc] init];
    self.dummyTextSection = [[CTTextSection alloc] init];
    
    self.sectionInfoArray = [[NSMutableArray alloc] initWithObjects:self.descrTextSection, self.dummyTextSection, nil];
    //UINib *sectionHeaderNib = [UINib nibWithNibName:@"SectionHeaderView" bundle:nil];
    //[self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
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
    
    self.descrTextSection.building = self.building;
    self.dummyTextSection.building = self.building;
    
    // load events for this particular building
    self.events = [CTEventBuilder sortByTime:self.building.events];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.sectionInfoArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	id<CTTableSectionProtocol> sectionInfo = (self.sectionInfoArray)[section];
    return sectionInfo.open ? [sectionInfo numberOfRowsNeeded] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id<CTTableSectionProtocol> selectedSection = self.sectionInfoArray[self.openSectionIndex];
    NSString *cellId = selectedSection.customCellIdentifier;
    
    UITableViewCell *cell = (UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:cellId];
    [selectedSection populateCell:cell];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    static NSString *SectionHeaderViewIdentifier = @"SectionHeaderViewIdentifier";
    CTSectionHeaderView *sectionHeaderView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    
    id<CTTableSectionProtocol> sectionInfo = (self.sectionInfoArray)[section];
    sectionInfo.headerView = sectionHeaderView;

    sectionHeaderView.titleLabel.text = sectionInfo.title;
    sectionHeaderView.section = section;
    sectionHeaderView.delegate = self;
    
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Actually make this depend on the particular sectionInfo object.
    return 100;
	//APLSectionInfo *sectionInfo = (self.sectionInfoArray)[indexPath.section];
    //return [[sectionInfo objectInRowHeightsAtIndex:indexPath.row] floatValue];
    // Alternatively, return rowHeight.
}

#pragma mark - SectionHeaderViewDelegate
/*
- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)sectionOpened {
    
	APLSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionOpened];
    
	sectionInfo.open = YES;
    
 
     Create an array containing the index paths of the rows to insert: These correspond to the rows for each quotation in the current section.
     /
    NSInteger countOfRowsToInsert = [sectionInfo.play.quotations count];
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
        [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
    }
    
 
     Create an array containing the index paths of the rows to delete: These correspond to the rows for each quotation in the previously-open section, if there was one.
     *
    /
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    
    NSInteger previousOpenSectionIndex = self.openSectionIndex;
    if (previousOpenSectionIndex != NSNotFound) {
        
		APLSectionInfo *previousOpenSection = (self.sectionInfoArray)[previousOpenSectionIndex];
        previousOpenSection.open = NO;
        [previousOpenSection.headerView toggleOpenWithUserAction:NO];
        NSInteger countOfRowsToDelete = [previousOpenSection.play.quotations count];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenSectionIndex]];
        }
    }
    
    // style the animation so that there's a smooth flow in either direction
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenSectionIndex == NSNotFound || sectionOpened < previousOpenSectionIndex) {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    // apply the updates
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:insertAnimation];
    [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [self.tableView endUpdates];
    
    self.openSectionIndex = sectionOpened;
}

- (void)sectionHeaderView:(APLSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)sectionClosed {
 
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     
	APLSectionInfo *sectionInfo = (self.sectionInfoArray)[sectionClosed];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:sectionClosed];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
        }
        [self.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}*/


/* DANIELS STUFF
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
*/


@end
