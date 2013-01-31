//
//  DetailViewController.m
//  Homepwner
//
//  Created by Ramon Bartl on 14.01.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"


@implementation DetailViewController

@synthesize item;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    // create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Use filtered NSDate object to set date label contents
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
}


@end