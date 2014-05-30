//
//  CTTextSection.m
//  CarlTour
//
//  Created by Lab User on 5/30/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTTextSection.h"

@implementation CTTextSection


- (NSString*) customCellIdentifier
{
    static NSString *identifier = @"CTTextSectionCellIdentifier";
    return identifier;
}

- (void) updateWithBuilding:(CTBuilding*) building
{
    self.building = building;
    self.title = building.name;
    
}

- (int) numberOfRowsNeeded
{
    return 1;
}

- (void) populateCell:(UITableViewCell*) cell
{
    CTTextCell *textCell = (CTTextCell*) cell;
    textCell.tintColor = [CTConstants CTCarletonBlueColor];
    
}
@end
