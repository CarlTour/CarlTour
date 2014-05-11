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
        building.coords = outlineCoords;
        building.imagePath = @"There is no image";
        building.buildingDescription = @"I'm a building yayyyyy";
        
        // put in one event for now
        NSMutableArray *eventsForBuilding = [[NSMutableArray alloc] init];
        CTEvent *event = [[CTEvent alloc] init];
        event.title = [NSString stringWithFormat:@"Some event at %@", buildingName];
        event.time = [NSDate date];
        event.eventDescription = [NSString stringWithFormat:@"This is some event description for %@", buildingName];
        CTRoomLocation *room = [[CTRoomLocation alloc] init];
        room.roomDescription = [NSString stringWithFormat:@"Some room in %@", buildingName];
        [eventsForBuilding addObject:event];
        building.events = eventsForBuilding;

        
        [buildList addObject:building];
    }
    
    sharedManager.buildingList = buildList;
}

/* Returns a building having an id matching the given <buildID> from the manager's
   buildingList. If it's not initialized this will probably segfault */
- (CTBuilding *)getBuildingFor:(NSString *)buildID
{
    if (![self buildingList]) {
        return nil;
    }
    
    CTBuilding *curBuilding;
    for (int i=0; i<[[self buildingList] count]; i++)
    {
        curBuilding = [[self buildingList] objectAtIndex:i];
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
        event.time = [NSDate date];
        event.eventDescription = [NSString stringWithFormat:@"I'm an event description for %d", i];
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
