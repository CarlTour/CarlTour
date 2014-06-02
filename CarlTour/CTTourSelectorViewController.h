//
//  CTTourSelectorViewController.h
//  CarlTour
//
//  Created by Lab User on 5/11/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CTTourViewController.h"

#import "CTTour.h"
#import "CTResourceManager.h"

@interface CTTourSelectorViewController : UIViewController <UITableViewDelegate,
                                                            UITableViewDataSource,
                                                            NSCoding>

@end
