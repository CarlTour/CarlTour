//
//  CTAnnotation.m
//  CarlTour
//
//  Created by mobiledev on 5/8/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTAnnotation.h"

@implementation CTAnnotation

- (id)initWithBuilding:(CTBuilding*) building
{
    self = [super init];
    if (self)
    {
        self.building = building;
        self.title = building.name;
        self.coordinate = [building getCenterCoordinate];
        // Just use a blank one for now.
        self.subtitle = @"";
    }
    return self;
}

@end
