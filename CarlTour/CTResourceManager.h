//
//  CTResourceManager.h
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTEvent.h"
#import "CTBuilding.h"
#import "CTTour.h"
#import "CTEventsCommunicator.h"

@interface CTResourceManager : NSObject

@property NSMutableArray *eventList;
@property NSMutableArray *buildingList;
@property NSMutableArray *tourList;

- (void)fetchEventsFor:(id<CTEventsCommunicator>) controller;
+ (CTResourceManager *)sharedManager;
- (void)loadEventsAfter:(NSDate *)date;
- (void) fetchAllEvents;
- (CTBuilding*) findBuildingWithProp:(NSString*) prop value:(id) value;

@end
