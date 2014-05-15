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

#import "constants.h"


@interface CTMapViewController : UIViewController <MKMapViewDelegate>

@property NSMutableArray *annotationsArray;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) IBOutlet CTBuildingDetailViewController *detailViewController;

-(void)handleAnnotationVisibility:(double)zoomLevel forMapView:(MKMapView *)mapView;
-(double)getMapViewZoomLevel:(MKMapView *)mapView;
-(void)hideAllAnnotations;
@end
