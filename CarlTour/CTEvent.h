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

@property NSString *title;
@property NSDate *time;
@property NSString *eventDescription;
@property CTRoomLocation *location;

-(NSString*) getRelativeFormat;

@end
