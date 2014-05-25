//
//  CTTour.m
//  CarlTour
//
//  Created by mobiledev on 5/12/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTTour.h"

@interface CTTour ()

@property (nonatomic, strong) NSMutableArray *buildings;
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
        self.buildings = [NSMutableArray arrayWithArray:buildings];
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

- (CTBuilding*) revertAndGetLastBuilding
{
    // Fun fact, C will cast the curBuildingIdx - 1 to an unsigned int as well when doing % operator with NSUInteger. Which leads to some, uh, interesting problems.
    int signedCount = [self.buildings count];
    self.curBuildingIdx = (((self.curBuildingIdx - 1) %  signedCount) + signedCount) % signedCount;
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
- (CTBuilding*) startFromLocation:(CLLocation*)loc
{
    int bestIdx = -1;
    float minDistance = MAXFLOAT;
    // Grab the closest building
    for (int i=0; i<[self.buildings count]; i++)
    {
        CTBuilding *building = [self.buildings objectAtIndex:i];
        float curDistance = [loc distanceFromLocation:[building getCenterCoordinate]];
        if (curDistance < minDistance) { bestIdx = i; }
    }
    
    self.tourStartIdx = bestIdx;
    self.curBuildingIdx = bestIdx;
    return [self.buildings objectAtIndex:bestIdx];
}

@end
