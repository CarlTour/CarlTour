//
//  CTTextSection.h
//  CarlTour
//
//  Created by Lab User on 5/30/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTTableSectionProtocol.h"
#import "CTTextCell.h"
#import "CTConstants.h"
#import "CTBuilding.h"

@interface CTTextSection : NSObject <CTTableSectionProtocol>

@property (nonatomic) NSString *title;
@property (nonatomic) BOOL open;
@property (nonatomic) NSString *customCellIdentifier;
@property (nonatomic) CTSectionHeaderView *headerView;
@property (nonatomic) CTBuilding *building;

- (int) numberOfRowsNeeded;
- (void) populateCell:(UITableViewCell*) cell;

@end
