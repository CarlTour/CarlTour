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
#import "CTConstants.h"

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

- (NSUInteger) getLastTab {
    NSNumber *lastTabIndex =[self.defaults objectForKey:LAST_TAB];
    return [lastTabIndex intValue];
}

- (void) setLastTab: (NSUInteger) lastTabIndex {
    [self.defaults setObject:[NSNumber numberWithInteger:lastTabIndex] forKey:LAST_TAB];
}

- (void) goingIntoDetail {
    [self.defaults setObject:[NSNumber numberWithBool:YES] forKey:DETAIL_VIEW];
}

- (void) goingOutOfDetail {
    [self.defaults setObject:[NSNumber numberWithBool:NO] forKey:DETAIL_VIEW];
}

- (BOOL) isInDetail {
    return [[self.defaults objectForKey:DETAIL_VIEW] boolValue];
}

- (NSUInteger) getLastTourIndex {
    NSNumber *tourIndex =[self.defaults objectForKey:TOUR_INDEX];
    return [tourIndex intValue];
}

- (void) setLastTourIndex: (NSUInteger) lastTourIndex {
    [self.defaults setObject:[NSNumber numberWithInteger:lastTourIndex] forKey:TOUR_INDEX];
}

@end
