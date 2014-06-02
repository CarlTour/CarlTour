//
//  CTLoadingOverlay.m
//  CarlTour
//
//  Created by Daniel Alabi on 6/1/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CTLoadingOverlay.h"

// heavily modified from this recipe:
//  http://developer.xamarin.com/recipes/ios/standard_controls/popovers/display_a_loading_message/

@interface CTLoadingOverlay()

// control declarations
@property UIActivityIndicatorView *activityIndicator;
@property UILabel *statusLabel;
@property UIView *background;

@end

@implementation CTLoadingOverlay

- (UIView *) overlayBackground: (CGRect) frame {
    CGRect bgRect = CGRectMake(0,
                               0,
                               frame.size.width,
                               frame.size.height);
    
    UIView *background = [[UIView alloc] initWithFrame:bgRect];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.7;
    
    return background;
}

- (UILabel *) overlayStatusLabel: (CGRect) frame withText: (NSString *) text{
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    statusLabel.numberOfLines = 0;
    statusLabel.text = text;
    [statusLabel sizeToFit];
    
    CGFloat labelHeight = statusLabel.bounds.size.height;
    CGFloat labelWidth = statusLabel.bounds.size.width;
    
    CGRect labelRect = CGRectMake(frame.size.width/2.0 - labelWidth/2.0,
                                  frame.size.height/2.0 - labelHeight/2.0,
                                  labelWidth,
                                  labelHeight);
    statusLabel.frame = labelRect;
    statusLabel.backgroundColor = [UIColor clearColor];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.shadowColor = [UIColor blackColor];
    return statusLabel;
}

- (UIActivityIndicatorView *) overlayIndicatorView {
   UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
   
   CGPoint statusLabelCenter = self.statusLabel.center;
   CGRect indicatorRect = CGRectMake(statusLabelCenter.x - 20.0/2.0,
                                     statusLabelCenter.y - self.statusLabel.frame.size.height/2.0 - 20,
                                     20,
                                     20);
   indicator.frame = indicatorRect;
   indicator.hidden = NO;
   [indicator startAnimating];
    return indicator;
}

- (id)initWithFrame:(CGRect)frame labelText:(NSString*)text indicatorVisible:(BOOL)indicatorVisible
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        self.background = [self overlayBackground:frame];
        self.statusLabel = [self overlayStatusLabel:frame withText: text];
        self.activityIndicator = [self overlayIndicatorView];
        
        [self addSubview:self.background];
        [self addSubview:self.statusLabel];
        
        if (indicatorVisible) {
            [self addSubview:self.activityIndicator];
        }
    }
    return self;
}

@end
