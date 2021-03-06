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
#import "CTFrontStorage.h"

@interface CTResourceManager : NSObject

@property NSMutableArray *eventList;
@property NSMutableArray *buildingList;
@property NSMutableArray *tourList;
@property CTFrontStorage *store;

- (void)fetchEventsFor: (id<CTEventsCommunicator>) controller;
+ (CTResourceManager *) sharedManager;
- (void) fetchAllEvents;
- (CTBuilding*) findBuildingWithProp:(NSString*) prop value:(id) value;

@end
