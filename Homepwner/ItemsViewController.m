//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Ramon Bartl on 01.01.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#import "HomepwnerItemCell.h"

@implementation ItemsViewController

# pragma mark Initializers

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
//        for (int i = 0; i < 5; i++) {
//            BNRItem * p = [[BNRItemStore sharedStore] createItem];
//            NSLog(@"Created random BNRItem %@", [p itemName]);
//        }
        UINavigationItem * n = [self navigationItem];
        [n setTitle:@"Homepwner"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                        initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                             target:self
                                             action:@selector(addNewItem:)];
        
        // set this bar button item as the right item in the navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the nib file
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    // Register this nib which contains the cell
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"HomepwnerItemCell"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (io == UIInterfaceOrientationPortrait);
    }
}

# pragma mark ItemsViewController methods

- (IBAction)addNewItem:(id)sender
{
    // create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController = [[DetailViewController alloc]
                                                  initForNewItem:YES];
    
    [detailViewController setItem:newItem];
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:detailViewController];
    
    // display the modal window in the middle of the screen and dim the rest out.
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    
    // interrupt the oldest-ancestor behaviour
    // [navController setModalPresentationStyle:UIModalPresentationCurrentContext];
    //[self setDefinesPresentationContext:YES];
    
    [navController setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentViewController:navController animated:YES completion:nil];
}

# pragma mark UITableViewDataSource protocol methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

// GET
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    // Get the new or recycled cell
    HomepwnerItemCell *cell = [tableView
            dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [[cell thumbnailView] setImage:[p thumbnail]];
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialNumberLabel] setText:[p serialNumber]];
    [[cell valueLabel] setText:[NSString stringWithFormat:@"$%d", [p valueInDollars]]];
    
    return cell;
}

// SELECT
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:indexPath.row];
    [detailViewController setItem:selectedItem];
    
    [[self navigationController] pushViewController:detailViewController
                                          animated:YES];
}

// DELETE
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        // we also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

// SORTING
- (void)tableView:(UITableView *)tableView
    moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
           toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row]
                                        toIndex:[destinationIndexPath row]];
}
 

@end