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

@interface CTConstants : NSObject

+(UIColor*) CTCarletonBlueColor;
+(UIColor*) CTCarletonMaizeColor;
+(UIColor*) CTGrayColor;
@end
