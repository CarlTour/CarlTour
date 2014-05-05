//
//  CTMapViewController.m
//  CarlTour
//
//  Created by mobiledev on 5/4/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTMapViewController.h"
#import "CTBuilding.h"

@interface CTMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation CTMapViewController

- (void)addToMap:(NSMutableArray *)buildings
{
    for (CTBuilding *building in buildings)
    {
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.coordinate = [building getCenterCoordinate];
        annotation.title = building.name;
        [self.mapView addAnnotation:annotation];
    }
}

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
    if(nil == self.mapView)
    {
        self.mapView = [[MKMapView alloc] init];
        self.mapView.delegate = self;
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
