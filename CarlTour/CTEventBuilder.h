//
//  CTEventBuilder.h
//  CarlTour
//
//  Created by Daniel Alabi on 5/20/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTEventBuilder : NSObject

+ (NSArray *)eventsFromJSON:(NSData *)objectNotation error:(NSError **)error;
+ (NSDate *) getNSDate: (NSString *) dateString;

@end
