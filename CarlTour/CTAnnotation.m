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
        // Show the priority of the building to help debug when we set the real priorities
        self.subtitle = [NSString stringWithFormat:@"Priority (zoom): %.2f", [[building priority] doubleValue]];
    }
    return self;
}

@end
