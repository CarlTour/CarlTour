//
//  CTResourceManager.m
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTResourceManager.h"
#import "CTEvent.h"
#import "CTBuilding.h"

@implementation CTResourceManager

static CTResourceManager *sharedManager;

// Many thanks to http://stackoverflow.com/questions/145154/what-should-my-objective-c-singleton-look-like
// Access the manager via [CTResourceManager sharedManager];
+ (void)initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        sharedManager = [[CTResourceManager alloc] init];
        [sharedManager loadBuildings];
    }
}

+ (CTResourceManager *)sharedManager
{
    return sharedManager;
}

/* Loads and stores buildings to buildList instance variable */
- (void)loadBuildings
{
    // Loads buildings from the given plist file.
    NSMutableArray *buildList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<12; i++)
    {
        CTBuilding *building = [[CTBuilding alloc] init];
        building.coords = nil;
        building.name = [NSString stringWithFormat:@"Building %d", i];
        building.buildingID = [NSString stringWithFormat:@"%d", i];
        building.imagePath = @"There is no image";
        building.buildingDescription = @"I'm a building yayyyyy";
        building.events = nil;
        [buildList addObject:building];
    }
    
    sharedManager.buildingList = buildList;
}

/* Returns a building having an id matching the given <buildID> from the manager's
   buildingList. If it's not initialized this will probably segfault */
- (CTBuilding *)getBuildingFor:(NSString *)buildID
{
    CTBuilding *curBuilding;
    for (int i=0; i<[[self buildingList] count]; i++)
    {
        curBuilding = [[self buildingList] objectAtIndex:i];
        
        if ([curBuilding.buildingID isEqualToString:buildID])
        {
            return curBuilding;
        }
    }
    // Will happen when the id is not found.
    return nil;
}

/* Loads and stores events to eventList property having date after <date> */
- (void)loadEventsAfter:(NSDate *)date
{
    // Presumably call to the server here and create a bunch of events.
    NSMutableArray *eventList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<50; i++)
    {
        CTEvent *event = [[CTEvent alloc] init];
        event.title = @"An event";
        event.time = [NSDate date];
        event.eventDescription = @"I'm an event";
        CTRoomLocation *room = [[CTRoomLocation alloc] init];
        room.roomDescription = [NSString stringWithFormat:@"%d", i];
        [eventList addObject:event];
        
        // KEEP THIS LATER
        // Assuming the json we get will have the building id.
        CTBuilding *eventBuilding = [self getBuildingFor:[NSString stringWithFormat:@"%d", i]];
        room.building  = eventBuilding;
        [[eventBuilding events] addObject:eventBuilding];
    }
    
    sharedManager.eventList = eventList;
}

@end
