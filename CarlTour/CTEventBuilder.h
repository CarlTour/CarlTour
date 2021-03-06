//
//  CTEventBuilder.h
//  CarlTour
//
//  Created by Daniel Alabi on 5/20/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTEventBuilder.h"
#import "CTFrontStorage.h"

@interface CTEventBuilder : NSObject

+ (NSMutableArray *) eventsFromJSON:(NSData *)objectNotation error:(NSError **)error storage:(CTFrontStorage *) store;
+ (NSDate *) getNSDate: (NSString *) dateString;
+ (NSMutableArray *) sortByTime: (NSMutableArray*) events;

@end
