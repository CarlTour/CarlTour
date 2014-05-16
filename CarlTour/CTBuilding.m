//
//  CTBuilding.m
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTBuilding.h"
@implementation CTBuilding

/* Returns a coord with averaged lat/long of building's coordinates */
- (CLLocation*)getCenterCoordinate
{
    double lat = 0;
    double lon = 0;
    
    int numCoords = (int) [self.coords count];
    NSArray * coords = self.coords;
    for (int i=0; i<numCoords; i++)
    {
        CLLocationCoordinate2D coord = [[coords objectAtIndex:i] coordinate];
        lat += coord.latitude;
        lon += coord.longitude;
    }
    
    lat /= numCoords;
    lon /= numCoords;
    

    CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
    return loc;
}

@end
