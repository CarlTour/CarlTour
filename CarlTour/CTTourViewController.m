//
//  CTTourViewController.m
//  CarlTour
//
//  Created by Lab User on 5/11/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTTourViewController.h"

@interface CTTourViewController ()
@property (weak, nonatomic) CTBuilding *curBuilding;
@property CLLocationManager *locationManager;
@property BOOL enroute;
@end

@implementation CTTourViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)updateState:(id)sender {
    UIButton *button = (UIButton*) sender;
    if (self.enroute)
    {
        [button setTitle:@"Let's move on" forState:UIControlStateNormal];
        self.enroute = NO;
        [self launchDetailView];
    }
    else
    {
        [button setTitle:@"I'm here!" forState:UIControlStateNormal];
        [self moveToNextBuilding];
    }
}

- (void)moveToNextBuilding
{
    self.curBuilding = [self.tour progressAndGetNextBuilding];
    [self highlightBuilding:self.curBuilding];
    self.title = [NSString stringWithFormat:@"Next stop: %@", self.curBuilding.name];
    self.enroute = YES;
}

- (void)launchDetailView
{
    if (self.detailViewController == nil)
    {
        self.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuildingDetailViewControllerID"];
    }
    
    self.detailViewController.building = self.curBuilding;
    [self.navigationController pushViewController:self.detailViewController animated:true];
}

- (void)highlightBuilding:(CTBuilding *)building
{
    NSMutableArray *buildings = [CTResourceManager sharedManager].buildingList;
    for (CTBuilding *otherBuilding in buildings)
    {
        if (otherBuilding == building)
        {
            [self changeColorFor:building toColor:[UIColor blueColor]];
        }
        else
        {
            [self changeColorFor:otherBuilding toColor:[UIColor grayColor]];
        }
    }
}

- (void)viewDidLoad
{
    // IMPORTANT: This must come before calling the parent's method.
    // Start tour and grab first building target
    // Just a stub for now.
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(0.0, 0.0);
    self.curBuilding = [self.tour startFromLocation:loc];
    self.title = [NSString stringWithFormat:@"Next stop: %@", self.curBuilding.name];
    [self highlightBuilding:self.curBuilding];
    self.enroute = YES;
    
    // Hide annotations appropriately.
    [self hideAllAnnotations];
    //[self handleAnnotationVisibility:[self getMapViewZoomLevel:self.mapView] forMapView:self.mapView];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

// Show the navigation bar so we can go back.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
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

/* NOT GOING TO WORK...
- (MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
    if ([overlay.title isEqualToString:self.curBuilding.buildingID])
    {
        renderer.fillColor = [UIColor blueColor];
    }
    else
    {
        renderer.fillColor = [UIColor grayColor];
    }
    return renderer;
}
*/

// Location managing bit
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //TODO implement
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //TODO implement
}

@end
