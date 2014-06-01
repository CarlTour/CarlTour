//
//  CTEvent.m
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTEvent.h"

@implementation CTEvent

-(NSString*) getReadableStartFormat {
    return [self getReadableFormat:self.startTime];
}

-(NSString*) getReadableFormatTimeOnly: (NSDate*) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h':'mm aaa"];
    return [dateFormatter stringFromDate:date];
}

-(NSString*) getReadableFullFormat {
    if (self.endTime != nil) {
        return [NSString stringWithFormat: @"%@ until %@",
                [self getReadableFormat:self.startTime],
                [self getReadableFormatTimeOnly:self.endTime]
            ];
    } else {
        return [self getReadableStartFormat];
    }
}

// modified from
// http://www.codeproject.com/Articles/41906/Formatting-Dates-relative-to-Now-Objective-C-iPhon
// only handles dates for today and future dates

- (NSString*) getReadableFormat: (NSDate*) laterDate {
    NSDateFormatter *mdf = [[NSDateFormatter alloc] init];
    [mdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnightLaterDate = [mdf dateFromString:[mdf stringFromDate:laterDate]];
    NSDate *midnightToday = [mdf dateFromString:[mdf stringFromDate:[NSDate date]]];
    
    NSInteger dayDiff = MAX((int)[midnightLaterDate timeIntervalSinceNow],
                            (int)[laterDate timeIntervalSinceDate:midnightToday])/ (60*60*24);
    
    // time to format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    if(dayDiff <= 0) {
        [dateFormatter setDateFormat:@"'Today, 'h':'mm aaa"];
    } else if (dayDiff == 1) {
        [dateFormatter setDateFormat:@"'Tomorrow, 'h':'mm aaa"];
    }
    else if((dayDiff >= 2 && dayDiff < 7)) {
        [dateFormatter setDateFormat:@"EEEE',' h':'mm aaa"];
    } else if (dayDiff >= 7 && dayDiff <= 14) {
        [dateFormatter setDateFormat:@"MMMM d'; Next week'"];
    } else if (dayDiff >= 30 && dayDiff <=  60) {
        [dateFormatter setDateFormat:@"MMMM d'; Next month'"];
    } else if (dayDiff >= 60 && dayDiff <= 90) {
        [dateFormatter setDateFormat:@"MMMM d'; Within the next three months'"];
    } else if (dayDiff >= 90 && dayDiff <= 180) {
        [dateFormatter setDateFormat:@"MMMM d'; Within the next six months'"];
    } else if (dayDiff > 365) {
        [dateFormatter setDateFormat:@"MMMM d, YYYY'; A long time later'"];
    }
    
    return [dateFormatter stringFromDate:laterDate];
}

- (NSTimeInterval)getTimeInterval {
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

@end
