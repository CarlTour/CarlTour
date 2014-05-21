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

@implementation CTEventBuilder

+ (NSDate *) getNSDate: (NSString *) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSArray *) eventsFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"events"];
    NSLog(@"Count %d", results.count);
    
    CTResourceManager *manager = [CTResourceManager sharedManager];
    
    for (NSDictionary *eventDic in results) {
        CTEvent *event = [[CTEvent alloc] init];
        
        // set title
        event.title = [eventDic valueForKey:@"title"];
        event.startTime = [self getNSDate:[eventDic valueForKey:@"start_datetime"]];
        event.endTime = [self getNSDate:[eventDic valueForKey:@"end_datetime"]];
        // event.eventDescription = [event valueForKey:@"description"];
        CTRoomLocation *eventLocation = [[CTRoomLocation alloc] init];
        eventLocation.roomDescription = [eventDic valueForKey:@"full_location"];
        eventLocation.building = [manager findBuildingWithProp:@"name" value:[eventDic valueForKey:@"building"]];
        [[eventLocation.building events] addObject:event];
        event.location = eventLocation;

        [events addObject:event];
    }
    
    return events;
}
@end