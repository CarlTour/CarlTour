//
//  CTTourViewController.h
//  CarlTour
//
//  Created by Lab User on 5/11/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//


#import "CTMapViewController.h"
#import "CTBuilding.h"
#import "CTTour.h"

@interface CTTourViewController : CTMapViewController <CLLocationManagerDelegate>
@property CTTour *tour;
@end
