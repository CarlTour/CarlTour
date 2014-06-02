//
//  CTBuildingDetailViewController.h
//  CarlTour
//
//  Created by Lab User on 5/7/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTBuilding.h"
#import "CTEvent.h"
#import "CTEventsCommunicator.h"

@interface CTBuildingDetailViewController : UIViewController <CTEventsCommunicator,
                                                              UITableViewDataSource>

@property (nonatomic, weak) CTBuilding *building;
@property NSArray *events;
@property CTEvent *selectedEvent;

-(void)setNewBuilding:(CTBuilding *)building;

@end
