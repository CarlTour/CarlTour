//
//  CTMainTabBarViewController.m
//  CarlTour
//
//  Created by Daniel Alabi on 6/2/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTMainTabBarViewController.h"
#import "CTResourceManager.h"
#import "CTTourSelectorViewController.h"

@interface CTMainTabBarViewController ()

@property CTResourceManager *manager;

@end

@implementation CTMainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.manager = [CTResourceManager sharedManager];
    
    self.selectedIndex = [self.manager.store getLastTab];
    BOOL inDetail = [self.manager.store isInDetail];
    if (self.selectedIndex == 1 && inDetail) {
        int tourIndex = [self.manager.store getLastTourIndex];
        NSLog(@"loading tour for index %d", tourIndex);
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
