//
//  CTSectionHeaderView.m
//  CarlTour
//
//  Created by Lab User on 5/30/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTSectionHeaderView.h"

@implementation CTSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)toggleOpen:(id)sender {
    
    [self toggleOpenWithUserAction:YES];
}

- (void)toggleOpenWithUserAction:(BOOL)userAction {
    
    // toggle the disclosure button state
    self.disclosureButton.selected = !self.disclosureButton.selected;
    
    // if this was a user action, send the delegate the appropriate message
    if (userAction) {
        if (self.disclosureButton.selected) {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionOpened:)]) {
                [self.delegate sectionHeaderView:self sectionOpened:self.section];
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(sectionHeaderView:sectionClosed:)]) {
                [self.delegate sectionHeaderView:self sectionClosed:self.section];
            }
        }
    }
}



@end

