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

// overwrite custom setter of item to set the navigation title
- (void)setItem:(BNRItem *)_item
{
    item = _item;
    [[self navigationItem] setTitle:[item itemName]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"DetailViewController::viewWillAppear");
    
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"DetailViewController::viewWillDisappear");
    
    // clear first responder
    [[self view] endEditing:YES];
    
    // Save changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}


- (IBAction)takePicture:(UIBarButtonItem *)sender {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // if our device has a camera, we want to take a picture, otherwise, we
    // just pick from the photo library
    if ([UIImagePickerController
         isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    [imagePicker setDelegate:self];
    
    // place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

# pragma mark UIImagePickerController delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // put that image onto the screen in your image view
    [imageView setImage:image];
    
    // Take image picker off the screen -
    // you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end