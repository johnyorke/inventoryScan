//
//  JYInventoryScanItemsViewController.m
//  inventoryScan
//
//  Created by John Yorke on 16/03/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYInventoryScanItemsViewController.h"
#import "JYInventoryScanItemStore.h"
#import "JYInventoryScanItem.h"
#import "appleLabelCell.h"

@interface JYInventoryScanItemsViewController ()

@end

@implementation JYInventoryScanItemsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationItem *n = [self navigationItem];
    
    // Check if 1 item or more exists, if not change title to "No items"
    if ([[JYInventoryScanItemStore sharedStore].outData count] > 0) {
        [n setTitle:@"Scanned Items"];
    } else {
        [n setTitle:@"No items"];
    }
    
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[JYInventoryScanItemStore sharedStore].outData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Use appleLabelCell as the background for each cell
    static NSString *simpleTableIdentifier = @"appleLabelCell";
    
    appleLabelCell *cell = (appleLabelCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) 
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"appleLabelCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    } 
    
    // -1 at the end to turn count into index no.
    NSUInteger outdataCount = [[JYInventoryScanItemStore sharedStore].outData count] - 1;
    
    // Takes the last item added to the array and displays it first
    JYInventoryScanItem *tempItem = [[[JYInventoryScanItemStore sharedStore] outData] objectAtIndex:outdataCount - [indexPath row]];
    
    cell.itemDescriptionLabel.text = [tempItem itemDescription];
    cell.itemQuantityOnHandLabel.text = [tempItem itemQuantityOnHand];
    cell.itemPriceLabel.text = [tempItem itemPrice];
    
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}


@end
