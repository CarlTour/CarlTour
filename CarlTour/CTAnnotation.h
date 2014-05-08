//
//  CTAnnotation.h
//  CarlTour
//
//  Created by mobiledev on 5/8/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#import "CTBuilding.h"

@interface CTAnnotation : NSObject <MKAnnotation>


@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, weak) CTBuilding *building;

- (id)initWithBuilding:(CTBuilding*) building;
@end
