//
//  DetailViewController.h
//  Homepwner
//
//  Created by Ramon Bartl on 14.01.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate,
                                                    UIImagePickerControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIImageView *imageView;
}

@property (nonatomic, strong) BNRItem *item;

- (IBAction)takePicture:(UIBarButtonItem *)sender;

@end