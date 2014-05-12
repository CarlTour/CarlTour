//
//  CTTour.m
//  CarlTour
//
//  Created by mobiledev on 5/12/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTTour.h"

@interface CTTour ()

@property NSMutableArray *buildings;
@property int tourStartIdx;
@property int curBuildingIdx;


@end

@implementation CTTour

- (id) initWithBuildings:(NSMutableArray*)buildings andName:(NSString*)name andID:(NSString*)ID
{
    self = [super self];
    if (self)
    {
        self.tourStartIdx = 0;
        self.curBuildingIdx = 0;
        self.buildings = buildings;
        self.name = name;
        self.tourID = ID;
    }
    return self;
}

- (CTBuilding*) progressAndGetNextBuilding
{
    self.curBuildingIdx = (self.curBuildingIdx + 1) % [self.buildings count];
    return [self.buildings objectAtIndex:self.curBuildingIdx];
}

/* YES if all buildings have been visited, else NO */
- (BOOL) isFinished;
{
    int nextIdx = (self.curBuildingIdx + 1) % [self.buildings count];
    if (nextIdx == self.tourStartIdx)
    {
        return YES;
    }
    return NO;
}

/* Initializes the tour to start from the current location */
- (CTBuilding*) startFromLocation:(CLLocationCoordinate2D)loc
{
    // Always start from the beginning for now
    self.tourStartIdx = 0;
    self.curBuildingIdx = 0;
    return [self.buildings objectAtIndex:self.tourStartIdx];
}

@end
