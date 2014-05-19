//
//  CTTour.h
//  CarlTour
//
//  Created by mobiledev on 5/12/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CTBuilding.h"

@interface CTTour : NSObject

@property NSString *name;
@property NSString *tourID;

- (id) initWithBuildings:(NSMutableArray*)buildings andName:(NSString*)name andID:(NSString*)ID;

- (CTBuilding*) progressAndGetNextBuilding;
- (CTBuilding*) revertAndGetLastBuilding;
- (BOOL) isFinished;
- (CTBuilding*) startFromLocation:(CLLocation*)loc;

@end
