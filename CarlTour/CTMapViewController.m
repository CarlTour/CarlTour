//
//  CTMapViewController.m
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTMapViewController.h"



@interface CTMapViewController ()

@end

@implementation CTMapViewController

- (void)addToMap:(NSMutableArray *)buildings
{
    for (CTBuilding *building in buildings)
    {
        CTAnnotation *annotation = [[CTAnnotation alloc] initWithBuilding:building];
        [self.mapView addAnnotation:annotation];
        [self.annotationsArray addObject:annotation];
        
        // draw MKRectangle on the map using the outline coordinates of the building
        CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * building.coords.count);
        for (int i = 0; i < building.coords.count; i++) {
            coords[i] = [[building.coords objectAtIndex:i] coordinate];
        }
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:coords count:building.coords.count];
        //TODO: This is pretty janky...
        polygon.title = building.buildingID;
        free(coords);
        
        [self.mapView addOverlay:polygon];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    if (self.annotationsArray == nil) {
        self.annotationsArray = [[NSMutableArray alloc] init];
    }

    if (self.renderers == nil) 
    {
        self.renderers = [[NSMutableDictionary alloc] init];
    }
    
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(CTDefaultLatitude, CTDefaultLongitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(CTDefaultLatitudeSpan, CTDefaultLongitudeSpan);
    MKCoordinateRegion initialMapRegion = MKCoordinateRegionMake(center, span);
    self.mapView.region = initialMapRegion;
    
    CTResourceManager *manager = [CTResourceManager sharedManager];
    [self addToMap:manager.buildingList];
    [self hideAllAnnotations];
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
    
    [self.detailViewController setNewBuilding:annotation.building];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationController pushViewController:self.detailViewController animated:true];
}

- (MKOverlayRenderer*)mapView:(MKMapView*)mapView rendererForOverlay:(id <MKOverlay>)overlay
{
    // Recall that the overlays are keyed with buildingID as their title
    MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];

    renderer.fillColor = [CTConstants CTCarletonMaizeColor];
    renderer.strokeColor = [CTConstants CTCarletonBlueColor];
    renderer.lineWidth = CTBuildingLineWidth;
    [self.renderers setObject:renderer forKey:overlay.title];
    return renderer;
}

- (void) changeColorFor:(CTBuilding *)building toColor:(UIColor *)color
{
    MKPolygonRenderer *renderer = [self.renderers objectForKey:building.buildingID];
    renderer.fillColor = color;
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self handleAnnotationVisibility:[self getMapViewZoomLevel:mapView] forMapView:mapView];
}

/*
 * Returns a number between [1.0, 5.0] indicating how far the mapView is zoomed in.
 * 5.0 means the map is zoomed far out
 * 1.0 means the map is zoomed far in
 */
- (double)getMapViewZoomLevel:(MKMapView *)mapView
{
    // these are super arbitrary right now.  Definitely want to move them somewhere else, too!!
    double zoomLevel5LatitudeDelta = 0.012057;
    double zoomLevel4LatitudeDelta = 0.007852;
    double zoomLevel3LatitudeDelta = 0.004490;
    double zoomLevel2LatitudeDelta = 0.002769;
    // 5.0: 0.012057
    // 4.0: 0.007852
    // 3.0: 0.004490
    // 2.0: 0.002769
    // 1.0: 0
    if (mapView.region.span.latitudeDelta > zoomLevel5LatitudeDelta) {
        return 5.0;
    } else if (mapView.region.span.latitudeDelta > zoomLevel4LatitudeDelta) {
        return 4.0;
    } else if (mapView.region.span.latitudeDelta > zoomLevel3LatitudeDelta) {
        return 3.0;
    } else if (mapView.region.span.latitudeDelta > zoomLevel2LatitudeDelta) {
        return 2.0;
    } else {
        return 1.0;
    }
}

/*
 * Hides or shows each annotation on the map according to the zoomLevel of the map and 
 * the annotations' priorities.
 */
-(void)handleAnnotationVisibility:(double)zoomLevel forMapView:(MKMapView *)mapView
{
    /*
    for (id annotation in self.annotationsArray) {
        // show the annotation if its priority equal to or greater than the zoomLevel
        // hide the annotation otherwise
        if ([[[annotation building] priority] doubleValue] >= zoomLevel) {
            [mapView addAnnotation:annotation];
            
        } else {
            [mapView removeAnnotation:annotation];
        }
    }*/
}

-(void)hideAllAnnotations
{
    for (id annotation in self.annotationsArray) {
        [self.mapView removeAnnotation:annotation];
    }
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

// Thanks to http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html for the quick test function. Won't work on polygons with holes.
- (BOOL) isCoord:(CLLocation*)test_loc withinCoords:(NSArray*)coords
{
    // Uses the Simulation of Simplicity
    // Nice article here with more info http://wiki.cizmar.org/doku.php?id=physics:point-in-polygon_problem_with_simulation_of_simplicity
    BOOL withinCoords = NO;
    CLLocationCoordinate2D test_coord = test_loc.coordinate;
    // Basically having j = i-1 at every iteration -> test all edges
    for (long i=0, j=[coords count]-1; i<[coords count]; j=i++)
    {
        CLLocationCoordinate2D endPoint1 = ((CLLocation *)[coords objectAtIndex:i]).coordinate;
        CLLocationCoordinate2D endPoint2 = ((CLLocation *)[coords objectAtIndex:j]).coordinate;
        if (((endPoint1.latitude>test_coord.latitude) != (endPoint2.latitude>test_coord.latitude)) &&
            (test_coord.longitude < (endPoint2.longitude-endPoint1.longitude) * (test_coord.latitude - endPoint1.latitude) / (endPoint2.latitude - endPoint1.latitude) + endPoint1.longitude))
            {
                withinCoords = !withinCoords;
            }
    }
    return withinCoords;
}
- (IBAction)handleTap:(UIGestureRecognizer *)sender {
    if ((sender.state & UIGestureRecognizerStateRecognized) == UIGestureRecognizerStateRecognized)
    {
        // Get map coordinate from touch point
        CGPoint touchPt = [sender locationInView:self.mapView];
        CLLocationCoordinate2D coord = [self.mapView convertPoint:touchPt toCoordinateFromView:self.mapView];
        CLLocation *coord_loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        
        // Get the corresponding building.
        NSMutableArray *buildings = [CTResourceManager sharedManager].buildingList;
        for (CTBuilding* building in buildings) {
            if ([self isCoord:coord_loc withinCoords:building.coords])
            {
                // Try to just show the annotation.
                for (CTAnnotation *annotation in self.annotationsArray)
                {
                    if (annotation.building == building)
                    {
                        [self.mapView addAnnotation:annotation];
                        [self.mapView selectAnnotation:annotation animated:YES];
                    }
                    else
                    {
                        [self.mapView removeAnnotation:annotation];
                    }
                }
                NSLog(@"Selected? %@", self.mapView.selectedAnnotations);
                return;
            }
        }
        
    }
    
}

@end
