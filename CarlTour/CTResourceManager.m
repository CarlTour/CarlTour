//
//  CTResourceManager.m
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTResourceManager.h"
#import "CTEventBuilder.h"
#import "CTEventsCommunicator.h"
#import "CTFrontStorage.h"
#import "CTEvent.h"

NSString *EVENTS_URI = @"http://carltour.nrjones8.com/api/v1.0/events";

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
        sharedManager.store = [CTFrontStorage sharedStorage];
    }
}

+ (CTResourceManager *)sharedManager
{   [self initialize];
    return sharedManager;
}

- (CTBuilding*) findBuildingWithProp:(NSString*) prop value:(id) value {
        if (![self buildingList]) {
            return nil;
        }
        
        CTBuilding *curBuilding;
        for (int i=0; i<[self.buildingList count]; i++)
        {
            curBuilding = [self.buildingList objectAtIndex:i];
            if ([[curBuilding valueForKey:prop] isEqualToString:value])
            {
                return curBuilding;
            }
        }
        return nil;
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
        NSLog(@"Error reading plist: %@, format: %lu", errorDesc, format);
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
        building.events = [[NSMutableArray alloc] init];
        
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
        NSLog(@"Error reading plist: %@, format: %lu", errorDesc, format);
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

- (void)fetchAllEvents {
    [self fetchEventsFor:nil];
}

- (void)fetchEventsFor:(id<CTEventsCommunicator>) controller {
    NSDate *lastFetched = [self.store getLastEventsFetchTime];
    NSDate *currentDate = [NSDate date];
    
    // fetch events every hour
    if ([currentDate compare: [lastFetched dateByAddingTimeInterval:3600] ] == NSOrderedAscending) {
        
        [self receivedEventsJSON: [self.store getCachedEvents]];
        
        if (controller != nil) {
            [controller updateDisplayForEvents];
        }
    } else {

        if (controller != nil) {
            [controller requestSent];
        }
        
        NSURL *url = [[NSURL alloc] initWithString:EVENTS_URI];
        
        [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url] queue:[[NSOperationQueue alloc] init] completionHandler:
            ^(NSURLResponse *response, NSData *data, NSError *error) {
            if (error != nil) {
                [self fetchingEventsFailedWithError: error];
            } else {
                [self receivedEventsJSON: data];
                
                [NSThread sleepForTimeInterval:2.5];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    if (controller != nil) {
                        [controller updateDisplayForEvents];
                    }
                });
                
                [self.store setLastEventsFetchTime: currentDate];
            }
        }];
    }
}

- (void)receivedEventsJSON:(NSData *)objectNotation {
    NSError *error = nil;
    NSMutableArray *events = [CTEventBuilder eventsFromJSON:objectNotation error:&error storage:self.store];
    if (error != nil) {
        [self fetchingEventsFailedWithError:error];
    } else {
        self.eventList = events;
    }
}

- (void)fetchingEventsFailedWithError:(NSError *)error {
    NSLog(@"An error occurred while trying to load events");
    NSLog(@"%@", error);
}

@end
