//
//  CTTourViewController.m
//  CarlTour
//
//  Created by Lab User on 5/11/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTTourViewController.h"

@interface CTTourViewController ()
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) CTBuilding *curBuilding;

@end

@implementation CTTourViewController

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
}

// Show the navigation bar so we can go back.
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tabBarController.tabBar setHidden:YES];
    
    // Start tour and grab first building target
    
    // Just a stub for now.
    CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(0.0, 0.0);
    [self.tour startFromLocation:loc];
    
    self.curBuilding = [self.tour progressAndGetNextBuilding];
    // TODO: throwing an error???
    //self.instructionLabel.text = self.curBuilding.name;
    self.instructionLabel.text = @"Huh?";
}

// Hide it as we don't need it on the map screen.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
