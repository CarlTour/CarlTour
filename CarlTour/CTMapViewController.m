//
//  CTMapViewController.m
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTAnnotation.h"

#import "CTMapViewController.h"
#import "CTBuildingDetailViewController.h"

#import "CTBuilding.h"
#import "CTResourceManager.h"


@interface CTMapViewController ()
// Doesn't have to be weak as the delegate is weak (so no retain cycle). but all examples say weak?
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet CTBuildingDetailViewController *detailViewController;
@end

@implementation CTMapViewController

- (void)addToMap:(NSMutableArray *)buildings
{
    for (CTBuilding *building in buildings)
    {
        /*
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = [building getCenterCoordinate];
        annotation.title = building.name;
        annotation.subtitle = @"test";
        */
        CTAnnotation *annotation = [[CTAnnotation alloc] initWithBuilding:building];
        [self.mapView addAnnotation:annotation];
        
        // draw MKRectangle on the map using the outline coordinates of the building
        CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * building.coords.count);
        for (int i = 0; i < building.coords.count; i++) {
            coords[i] = [[building.coords objectAtIndex:i] coordinate];
        }
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coords count:building.coords.count];
        free(coords);
        
        [self.mapView addOverlay:polygon];
    }
}

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
    if (nil == self.mapView)
    {
        self.mapView = [[MKMapView alloc] init];
    }
    
    // Not sure why but the the above if statement never gets called.
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(CTDefaultLatitude, CTDefaultLongitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(CTDefaultLatitudeSpan, CTDefaultLongitudeSpan);
    MKCoordinateRegion initialMapRegion = MKCoordinateRegionMake(center, span);
    self.mapView.region = initialMapRegion;
    
    CTResourceManager *manager = [CTResourceManager sharedManager];
    [self addToMap:manager.buildingList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MKMapViewDelegate

// Thanks to the lovely tutorial here http://www.devfright.com/mkpointannotation-tutorial/


// Trying to create an annotation
- (MKAnnotationView *)mapView:(MKMapView *)callingMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // User clicked on their own location
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // They clicked a building!
    if ([annotation isKindOfClass:[CTAnnotation class]])
    {
        MKPinAnnotationView *pinView = (MKPinAnnotationView*) [callingMapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        
        if (!pinView)
        {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.pinColor = MKPinAnnotationColorGreen;
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            pinView.rightCalloutAccessoryView = detailButton;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }

    return nil;
}

// When user clicks building callout we get called here.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                                     calloutAccessoryControlTapped:(UIControl *)control
{
    if (self.detailViewController == nil)
    {
        self.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuildingDetailViewControllerID"];
    }
    CTAnnotation* annotation = view.annotation;
    
    self.detailViewController.building = annotation.building;
    [self.navigationController pushViewController:self.detailViewController animated:true];
}

- (MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
    renderer.fillColor = [UIColor magentaColor];
    return renderer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
