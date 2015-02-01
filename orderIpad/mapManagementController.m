//
//  mapManagementController.m
//  orderIpad
//
//  Created by 金 秋瑞 on 5/22/14.
//  Copyright (c) 2014 Rachel. All rights reserved.
//

#import "mapManagementController.h"
#import "sqlite3.h"
#import "dbMap.h"
#import "mapDetailController.h"
#import "ODRefreshControl.h"

@interface mapManagementController ()

@end

@implementation mapManagementController

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
    allMap = [dbMap findAll];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [allMap count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    dbMap *map = [allMap objectAtIndex:indexPath.row];
	static NSString *CellIdentifier = @"mapCell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    UILabel *cellLabel1 = (UILabel *)[cell viewWithTag:1];
    cellLabel1.text = [map name];
    
    
    UILabel *cellLabel2 = (UILabel *)[cell viewWithTag:2];
    cellLabel2.text = [map address];
    
    UILabel *cellLabel3 = (UILabel *)[cell viewWithTag:3];
    cellLabel3.text = [NSString stringWithFormat:@"Open Status: %@",[map status]];
    
    UILabel *cellLabel4 = (UILabel *)[cell viewWithTag:4];
    cellLabel4.text = [NSString stringWithFormat:@"Open 24 hours: %@",[map open24]];
    
    UILabel *cellLabel5 = (UILabel *)[cell viewWithTag:5];
    cellLabel5.text = [map phone];
    
    UILabel *cellLabel6 = (UILabel *)[cell viewWithTag:6];
    cellLabel6.text = [map features];
   // cellLabel3.text = [dbCategory findByID:[menu categoryID]];
    

    /*initWithID:(NSString *) ID name:(NSString *) name latitude:(NSNumber *)latitude longtitude:(NSNumber *)longtitude address:(NSString *)address status:(NSString *) status open24:(NSString *) open24 phone: (NSString *) phone features: (NSString *) features  storeID: (NSString *) storeID  pic: (NSString *) pic*/
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	dbMap *map = [allMap objectAtIndex:indexPath.row];
	[dbMap delete:[map ID]];
	[allMap removeObjectAtIndex:indexPath.row];
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController =segue.destinationViewController;
    UIViewController *controller;
    if ([segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
        controller = [navController.viewControllers objectAtIndex:0];
    } else {
        controller = segue.destinationViewController;
    }
    
    if ([controller isKindOfClass:[mapDetailController class]]) {
        mapDetailController *mapController = (mapDetailController *)controller;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //[detailController setDataString:[NSString stringWithFormat:@"%i",selectIndexPath.section]];
        dbMap *map= [allMap objectAtIndex:indexPath.row];
        mapController.myMap = map;
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    allMap = [dbMap findAll];
    [self.tableView reloadData];
    
    //  NSLog(@"reoload!!!");
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
    });
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
