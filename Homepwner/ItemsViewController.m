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

@implementation ItemsViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        for (int i = 0; i < 5; i++) {
            BNRItem * p = [[BNRItemStore sharedStore] createItem];
            NSLog(@"Created random BNRItem %@", [p itemName]);
        }
    }
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}



# pragma mark UITableViewDataSource protocol methods

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // Check for a reusable cell first
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                   reuseIdentifier:@"UITableViewCell"];
    }
    
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[p description]];
    return cell;
}

@end