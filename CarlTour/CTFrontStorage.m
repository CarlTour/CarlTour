//
//  CTFrontStorage.m
//  CarlTour
//
//  Created by Daniel Alabi on 6/1/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTFrontStorage.h"
#import "CTEvent.h"
#import "CTEventBuilder.h"

// Will move this over to 'constants.h' soon
static NSString *LAST_EVENTS_FETCH_TIME = @"LAST_EVENTS_FETCH_TIME";
static NSString *EVENTS_IDENTIFIER = @"EVENTS";

@interface CTFrontStorage()

@property NSUserDefaults *defaults;

@end

@implementation CTFrontStorage

static CTFrontStorage *sharedStorage;

// Many thanks to http://stackoverflow.com/questions/145154/what-should-my-objective-c-singleton-look-like
// Access the manager via [CTResourceManager sharedManager];
+ (void)initialize
{
    static BOOL initialized = NO;
    if (!initialized)
    {
        initialized = YES;
        sharedStorage = [[CTFrontStorage alloc] init];
        sharedStorage.defaults = [NSUserDefaults standardUserDefaults];
    }
}

+ (CTFrontStorage *)sharedStorage
{   [self initialize];
    return sharedStorage;
}

- (void) setLastEventsFetchTime: (NSDate *) date {
    [self.defaults setObject:date forKey:LAST_EVENTS_FETCH_TIME];
}

- (NSDate *) getLastEventsFetchTime {
    return [self.defaults objectForKey:LAST_EVENTS_FETCH_TIME];
}

- (NSData *) getCachedEvents {
    return [self.defaults objectForKey:EVENTS_IDENTIFIER];
}

- (void) cacheEvents: (NSData *) objectNotation {
    [self.defaults setObject:objectNotation forKey:EVENTS_IDENTIFIER];
}

@end
