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
- (CLLocationCoordinate2D)getCenterCoordinate
{
    float lat = 0;
    float lon = 0;
    
    int numCoords = (int) [[self coords] count];
    NSArray * coords = [self coords];
    for (int i=0; i<numCoords; i++)
    {
        CLLocationCoordinate2D coord = [[coords objectAtIndex:i] coordinate];
        lat += coord.latitude;
        lon += coord.longitude;
    }
    
    lat /= numCoords;
    lon /= numCoords;
    
    //TODO: delete this once we get real buildings
    lat = 44.458298;
    lon = -93.161604;
    
    CLLocationCoordinate2D location;
    location.latitude = lat;
    location.longitude = lon;
    return location;
}

@end
