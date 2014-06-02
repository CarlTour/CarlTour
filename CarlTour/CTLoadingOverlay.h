//
//  CTLoadingOverlay.h
//  CarlTour
//
//  Created by Daniel Alabi on 6/1/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTLoadingOverlay : UIView

- (id)initWithFrame:(CGRect)frame labelText:(NSString*)text indicatorVisible:(BOOL)indicatorVisible;

@end
