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
@property BOOL initLocationGrab;
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
        [button setTitle:@"I'm there!" forState:UIControlStateNormal];
        [self moveToNextBuilding];
    }
    [self centerMapView];
}

- (void)moveToNextBuilding
{
    self.curBuilding = [self.tour progressAndGetNextBuilding];
    [self highlightBuilding:self.curBuilding];
    self.title = [NSString stringWithFormat:@"Next stop: %@", self.curBuilding.name];
    self.enroute = YES;
    [self centerMapView];
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
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    // Hopefully this will be a good mix between speed and accuracy.
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    // Work of actually starting the tour is delgated to didUpdateLocations because we need to know their starting location.
    self.initLocationGrab = YES;
    [self.locationManager startUpdatingLocation];
    
    [self.locationManager startUpdatingHeading];
    // DEBUG!
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateHeading)
                                   userInfo:nil
                                    repeats:YES];
}

// Show the navigation bar so we can go back.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    [self hideAllAnnotations];
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


- (void)startTourFromLocation:(CLLocation*)coord
{
    self.curBuilding = [self.tour startFromLocation:coord];
    self.title = [NSString stringWithFormat:@"Next stop: %@", self.curBuilding.name];
    [self highlightBuilding:self.curBuilding];
    self.enroute = YES;
    self.initLocationGrab = NO;
    self.mapView.showsUserLocation = YES;
    [self centerMapView];
}

// Location managing bit
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (self.initLocationGrab)
    {
        CLLocation *loc = [locations objectAtIndex:[locations count]-1];
        [self startTourFromLocation:loc];
        [manager stopUpdatingLocation];
    }
    // If we ever want to grab location for some other reason
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if (self.initLocationGrab)
    {
        // Just start from a random place I guess.
        CLLocation *dummyCoord = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
        [self startTourFromLocation:dummyCoord];
        [manager stopUpdatingLocation];
    }
}

// Override parent so we keep annotations hidden
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{}

- (void)debugUpdatedHeading
{
    // Get a random number for degrees
    float heading = arc4random() % 360;
    float headingDegrees = (heading*M_PI/180);
    [self.view viewWithTag:1].transform = CGAffineTransformMakeRotation(headingDegrees);
}

// TODO: Can't really tell if this if working
// Also, we need to kill the NSTimer that gets started in viewDidLoad. If you start additional tours, the NSTimer keeps going.
-(void)updateHeading
{
    CLLocation *destination = [self.curBuilding getCenterCoordinate];
    double latDiff = destination.coordinate.latitude - self.mapView.userLocation.coordinate.latitude;
    double lonDiff = destination.coordinate.longitude - self.mapView.userLocation.coordinate.longitude;
    
    double radians = atan(latDiff / lonDiff);
    if (lonDiff < 0) {
        radians += M_PI;
    }
    if (radians < 0) {
        radians += 2 * M_PI;
    }
    
    [self.view viewWithTag:1].transform = CGAffineTransformMakeRotation(radians);
}

// centers the map view so it contains both the user's location and the destination
-(void)centerMapView
{
    CLLocation *destination = [self.curBuilding getCenterCoordinate];
    
    // average the two locations to get the center of the new region
    double newLat = (destination.coordinate.latitude + self.mapView.userLocation.coordinate.latitude) / 2.0;
    double newLon = (destination.coordinate.longitude + self.mapView.userLocation.coordinate.longitude) / 2.0;
    CLLocationCoordinate2D newCenter = CLLocationCoordinate2DMake(newLat, newLon);
    
    // find difference to get new span
    double latDiff = fabs(destination.coordinate.latitude - self.mapView.userLocation.coordinate.latitude) * 1.2;
    double lonDiff = fabs(destination.coordinate.longitude - self.mapView.userLocation.coordinate.longitude) * 1.2;
    MKCoordinateSpan newSpan = MKCoordinateSpanMake(latDiff, lonDiff);
    
    MKCoordinateRegion newMapViewRegion = MKCoordinateRegionMake(newCenter, newSpan);
    [self.mapView setRegion:newMapViewRegion animated:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    float heading = newHeading.magneticHeading;
    float headingDegrees = (heading*M_PI/180);
    [self.view viewWithTag:1].transform = CGAffineTransformMakeRotation(headingDegrees);
}

@end
