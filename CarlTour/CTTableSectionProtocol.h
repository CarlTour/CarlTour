//
//  CTTableSectionProtocol.h
//  CarlTour
//
//  Created by Lab User on 5/30/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTSectionHeaderView.h"

@protocol CTTableSectionProtocol <NSObject>

@property (nonatomic) NSString *title;
@property (nonatomic) BOOL open;
@property (nonatomic) NSString *customCellIdentifier;
@property (nonatomic) CTSectionHeaderView *headerView;

- (int) numberOfRowsNeeded;
- (void) populateCell:(UITableViewCell*) cell;

@end
