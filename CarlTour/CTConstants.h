//
//  CTConstants.h
//  CarlTour
//
//  Created by mobiledev on 5/21/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>

static const float CTDefaultLatitude = 44.461056;
static const float CTDefaultLongitude = -93.154567;
static const float CTDefaultLatitudeSpan = 0.000147;
static const float CTDefaultLongitudeSpan = 0.008465;
static const float CTBuildingLineWidth = 1;

// constants used in CTFrontStorage
static NSString *LAST_EVENTS_FETCH_TIME = @"LAST_EVENTS_FETCH_TIME";
static NSString *EVENTS_IDENTIFIER = @"EVENTS";
static NSString *LAST_TAB = @"LAST_TAB";
static NSString *DETAIL_VIEW = @"DETAIL_VIEW";
static  NSString *TOUR_INDEX = @"TOUR_INDEX";

// URI for getting events
static NSString *EVENTS_URI = @"http://carltour.nrjones8.com/api/v1.0/events";

@interface CTConstants : NSObject

+(UIColor*) CTCarletonBlueColor;
+(UIColor*) CTCarletonMaizeColor;
+(UIColor*) CTGrayColor;
@end
