//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Ramon Bartl on 01.01.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@interface ItemsViewController : UITableViewController <UIPopoverControllerDelegate>
{
    UIPopoverController *imagePopover;
}

@end