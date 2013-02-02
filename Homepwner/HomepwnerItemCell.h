//
//  HomepwnerItemCell.h
//  Homepwner
//
//  Created by Ramon Bartl on 02.02.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomepwnerItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

- (IBAction)showImage:(id)sender;

@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

@end