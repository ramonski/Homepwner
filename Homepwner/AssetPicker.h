//
//  AssetPicker.h
//  Homepwner
//
//  Created by Ramon Bartl on 04.02.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface AssetPicker : UITableViewController

@property (nonatomic, strong) BNRItem *item;

@end