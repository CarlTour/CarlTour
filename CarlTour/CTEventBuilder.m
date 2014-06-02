//
//  CTEventBuilder.m
//  CarlTour
//
//  Created by Daniel Alabi on 5/20/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTEventBuilder.h"
#import "CTEvent.h"
#import "CTResourceManager.h"
#import "CTFrontStorage.h"

@implementation CTEventBuilder

+ (NSDate *) getNSDate: (NSString *) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}


+ (NSMutableArray*) sortByTime: (NSMutableArray*) events {
    NSMutableArray *newEvents = [NSMutableArray arrayWithArray:events];
    NSSortDescriptor *timeSort = [NSSortDescriptor sortDescriptorWithKey: @"startTime" ascending:YES];
    [newEvents sortUsingDescriptors:[NSArray arrayWithObject:timeSort]];
    return newEvents;
}


+ (NSMutableArray *) eventsFromJSON:(NSData *)objectNotation error:(NSError **)error storage:(CTFrontStorage *) store
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"events"];
    if (store != nil) {
        [store cacheEvents:objectNotation];
    }
    
    CTResourceManager *manager = [CTResourceManager sharedManager];

    // clear events in each building
    for (CTBuilding *building in [manager buildingList]) {
        building.events = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *eventsForBuilding;
    CTEvent *event;
    CTRoomLocation *eventLocation;
    for (NSDictionary *eventDic in results) {
        event = [[CTEvent alloc] init];
        
        // set title
        event.title = [eventDic valueForKey:@"title"];
        // set start and end time
        event.startTime = [self getNSDate:[eventDic valueForKey:@"start_datetime"]];
        event.endTime = [self getNSDate:[eventDic valueForKey:@"end_datetime"]];
        
        // only go through events that haven't already ended
        if ([[NSDate date] compare: event.endTime] == NSOrderedDescending) {
            continue;
        }
        
        // set event description
        event.eventDescription = [eventDic valueForKey:@"description"];
        // set room location for event
        eventLocation = [[CTRoomLocation alloc] init];
        eventLocation.roomDescription = [eventDic valueForKey:@"full_location"];
        eventLocation.building = [manager findBuildingWithProp:@"name" value:[eventDic valueForKey:@"building"]];
        eventsForBuilding = [eventLocation.building events];
        [eventsForBuilding addObject:event];
        event.location = eventLocation;
        
        [events addObject:event];
    }
    return [CTEventBuilder sortByTime:events];
}

@end
