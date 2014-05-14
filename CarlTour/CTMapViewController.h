//
//  CTMapViewController.h
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "constants.h"

@interface CTMapViewController : UIViewController <MKMapViewDelegate>

@property NSMutableArray *annotationsArray;

@end
