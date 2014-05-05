//
//  CTBuilding.h
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface CTBuilding : NSObject

// Should be a list of CLLocations (we need to maintain objects, CLLocation2D is not an object)
@property NSArray *coords;
@property NSString *name;
@property NSString *buildingID;
@property NSString *imagePath;
@property NSString *description;
// Should be a list of CTEvent objects.
@property NSMutableArray *events;

- (CLLocationCoordinate2D)getCenterCoordinate;

@end
