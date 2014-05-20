//
//  CTResourceManager.m
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTResourceManager.h"


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
        [sharedManager loadTours];
    }
}

+ (CTResourceManager *)sharedManager
{   [self initialize];
    return sharedManager;
}

/* Loads and stores buildings to buildList instance variable */
- (void)loadBuildings
{
    // Loads buildings from the given plist file.
    // Following code borrowed from:
    // https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/PropertyLists/QuickStartPlist/QuickStartPlist.html
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CTBuildingData.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"CTBuildingData" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *plistDict = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!plistDict) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    // create buildingList using the plist data
    NSMutableArray *buildList = [[NSMutableArray alloc] init];

    for (id buildingDict in [plistDict objectForKey:@"buildings"]) {
        NSString *buildingName = [buildingDict valueForKey:@"buildingName"];
        NSString *uniqueName = [buildingDict valueForKey:@"uniqueName"];
        NSString *buildingDescription = [buildingDict valueForKey:@"buildingDescription"];
        NSNumber *priority = [buildingDict valueForKey:@"priority"];
        
        NSMutableArray *outlineCoords = [[NSMutableArray alloc] init];
        for (id coordinateString in [buildingDict valueForKey:@"outlineCoords"]) {
            // coordinateString has format "latitude,longitude" (ex. "97.2424234,45.023953")
            NSArray *coords = [coordinateString componentsSeparatedByString:@","];
            [outlineCoords addObject:[[CLLocation alloc] initWithLatitude:[coords[0] doubleValue]
                                                                longitude:[coords[1] doubleValue]]];
        }
        
        CTBuilding *building = [[CTBuilding alloc] init];
        building.name = buildingName;
        building.buildingID = uniqueName;
        building.priority = priority;
        building.coords = outlineCoords;
        building.imagePath = @"There is no image";
        building.buildingDescription = buildingDescription;
        
        // put in one event for now
        NSMutableArray *eventsForBuilding = [[NSMutableArray alloc] init];
        CTEvent *event = [[CTEvent alloc] init];
        event.title = [NSString stringWithFormat:@"Some event at %@", buildingName];
        event.startTime = [NSDate date];
        event.endTime = [NSDate date];
        event.eventDescription = [NSString stringWithFormat:@"This is some event description for %@", buildingName];
        CTRoomLocation *room = [[CTRoomLocation alloc] init];
        room.roomDescription = [NSString stringWithFormat:@"Room in %@", buildingName];
        room.building = building;
        event.location = room;
        [eventsForBuilding addObject:event];
        building.events = eventsForBuilding;

        
        [buildList addObject:building];
    }
    
    sharedManager.buildingList = buildList;
}

/* Loads and stores buildings to buildList instance variable */
- (void)loadTours
{
    // Loads buildings from the given plist file.
    // Following code borrowed from loadBuildings
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"CTTourData.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"CTTourData" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *plistDict = (NSDictionary *)[NSPropertyListSerialization
                                               propertyListFromData:plistXML
                                               mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                               format:&format
                                               errorDescription:&errorDesc];
    if (!plistDict) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    }
    
    NSMutableArray *tourList = [[NSMutableArray alloc] init];
    
    for (id tourDict in [plistDict objectForKey:@"tours"]) {
        NSString *tourName = [tourDict valueForKey:@"display_name"];
        NSString *tourID = [tourDict valueForKey:@"unique_name"];
        
        NSMutableArray *buildingList = [[NSMutableArray alloc] init];
        for (id building_id in [tourDict valueForKey:@"building_ids"])
        {
            CTBuilding *building = [self getBuildingFor:building_id];
            if (building != nil)
            {
                [buildingList addObject:building];
            }
            else
            {
                NSLog(@"Error reading from plist: %@. Invalid building id %@", errorDesc, (NSString*)building_id);
            }
        }
        CTTour *tour = [[CTTour alloc] initWithBuildings:buildingList andName:tourName andID:tourID];
        
       
        [tourList addObject:tour];
    }
    
    sharedManager.tourList = tourList;
}


/* Returns a building having an id matching the given <buildID> from the manager's
   buildingList. If it's not initialized this will probably segfault */
- (CTBuilding *)getBuildingFor:(NSString *)buildID
{
    if (![self buildingList]) {
        return nil;
    }
    
    CTBuilding *curBuilding;
    for (int i=0; i<[self.buildingList count]; i++)
    {
        curBuilding = [self.buildingList objectAtIndex:i];
        if ([[curBuilding buildingID] isEqualToString:buildID])
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
        event.title = [NSString stringWithFormat:@"This is event %d", i];
        event.startTime = [[NSDate date] dateByAddingTimeInterval:60*i];
        event.endTime = [event.startTime dateByAddingTimeInterval:60*i];
        event.eventDescription = [NSString stringWithFormat:@"I'm an event description for %d", i];

        CTRoomLocation *room = [[CTRoomLocation alloc] init];
        room.roomDescription = [NSString stringWithFormat:@"BBC %d", i];
        room.building = [self.buildingList objectAtIndex: i % ([self.buildingList count])];
        event.location = room;
        
        [eventList addObject:event];
        
        // KEEP THIS LATER
        // Assuming the json we get will have the building id.
        CTBuilding *eventBuilding = [self getBuildingFor:[NSString stringWithFormat:@"%d", i]];
        // room.building  = eventBuilding;
        [[eventBuilding events] addObject:eventBuilding];
    }
    
    sharedManager.eventList = eventList;
}

@end
