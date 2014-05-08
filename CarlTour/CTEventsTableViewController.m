//
//  CTEventsTableViewController.m
//  CarlTour
//
//  Created by Daniel Alabi on 5/7/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import "CTEventsTableViewController.h"
#import "CTResourceManager.h"
#import "CTEvent.h"

@interface CTEventsTableViewController ()

@end

@implementation CTEventsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.eventsDisplayed == nil) {
        self.eventsDisplayed = [[NSMutableArray alloc] init];
    }
    
    CTResourceManager *manager = [CTResourceManager sharedManager];
    for (CTEvent *event in manager.eventList) {
        [self.eventsDisplayed addObject:event];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.eventsDisplayed count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"EventsTableViewCell" forIndexPath:indexPath];
    
    int n = indexPath.row;
    if (n == 0) {
        // header
        UILabel *label1, *label2, *label3;
        
        label1 = (UILabel *)[cell viewWithTag:1];
        label1.text = @"Time";
        // label1.layer.borderColor = [UIColor blackColor].CGColor;
        // label1.layer.borderWidth = 4.0;
        
        label2 = (UILabel *)[cell viewWithTag:2];
        label2.text = @"Title";
        CALayer *sublayer = [CALayer layer];
        // sublayer.backgroundColor = [UIColor blackColor].CGColor;
        // sublayer.frame = CGRectMake(label2.bounds.size.width, 0, 1, label2.frame.size.height);
        // [label2.layer addSublayer:sublayer];
        
        label3 = (UILabel *)[cell viewWithTag:3];
        label3.text = @"Location";
        
    } else {
        CTEvent *event = [self.eventsDisplayed objectAtIndex:indexPath.row];
    
        UILabel *label;
    
        label = (UILabel *)[cell viewWithTag:1];
        label.text = [NSString stringWithFormat:@"%@", [event time]];
    
        label = (UILabel *)[cell viewWithTag:2];
        label.text = [NSString stringWithFormat:@"%@", [event title]];
    
        label = (UILabel *)[cell viewWithTag:3];
        label.text = [NSString stringWithFormat:@"%@", [event location]];
 
        NSLog(@"Called for second label %@", [label text]);
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
