//
//  CTFrontStorage.h
//  CarlTour
//
//  Created by Daniel Alabi on 6/1/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTFrontStorage : NSObject

+ (CTFrontStorage *)sharedStorage;

- (void) setLastEventsFetchTime: (NSDate *) date;
- (NSDate *) getLastEventsFetchTime;
- (void) cacheEvents: (NSData *) objectNotation;
- (NSData *) getCachedEvents;

@end
