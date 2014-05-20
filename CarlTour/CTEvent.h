//
//  CTEvent.h
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTRoomLocation.h"

@interface CTEvent : NSObject

// title of the event
@property NSString *title;

// start and end times of the events
@property NSDate *startTime;
@property NSDate *endTime;

// event description
@property NSString *eventDescription;

// building and 
@property CTRoomLocation *location;

-(NSString*) getReadableStartFormat;
-(NSString*) getReadableFullFormat;
-(NSString*) getReadableFormat;
-(NSTimeInterval) getTimeInterval;
-(NSString*) getReadableFormatTimeOnly: (NSDate*) date;

@end
