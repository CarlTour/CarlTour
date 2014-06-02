//
//  CTMapViewController.h
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "CTBuildingDetailViewController.h"

#import "CTAnnotation.h"
#import "CTBuilding.h"
#import "CTResourceManager.h"

#import "CTConstants.h"


@interface CTMapViewController : UIViewController <MKMapViewDelegate, UIGestureRecognizerDelegate>

@property NSMutableArray *annotationsArray;
@property NSMutableDictionary *renderers;
// Doesn't have to be weak as the delegate is weak (so no retain cycle). but all examples say weak?
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet CTBuildingDetailViewController *detailViewController;

-(void)handleAnnotationVisibility:(double)zoomLevel forMapView:(MKMapView *)mapView;
- (void) changeColorFor:(CTBuilding *)building toColor:(UIColor *)color;
-(double)getMapViewZoomLevel:(MKMapView *)mapView;
-(void)hideAllAnnotations;
@end
