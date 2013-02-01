//
//  DetailViewController.m
//  Homepwner
//
//  Created by Ramon Bartl on 14.01.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"


@implementation DetailViewController

// synthesize properties
@synthesize item;
@synthesize dismissBlock;

// overwrite custom setter of item to set the navigation title
- (void)setItem:(BNRItem *)_item
{
    item = _item;
    [[self navigationItem] setTitle:[item itemName]];
}


# pragma mark initializers

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"use initForNewItem"
                                 userInfo:nil];
    return nil;
}

- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                                         initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}


# pragma mark view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *clr = [UIColor groupTableViewBackgroundColor];
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    }
    [[self view] setBackgroundColor:clr];
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
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey) {
        // get image for image key from image store
        UIImage *imageToDisplay =
            [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
    }
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


# pragma mark actions

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    // if the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem:item];
    
    [[self presentingViewController] dismissViewControllerAnimated:YES
                                                        completion:dismissBlock];
}


// ROTATION
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return (io == UIInterfaceOrientationPortrait);
    }
}


// TAKE PICTURE
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
    if ([imagePickerPopover isPopoverVisible]) {
        // if the image picker is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    // Check for iPad device before instatiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [imagePickerPopover setDelegate:self];
        
        // Display the popover controller;
        // sender is the camera bar button ite,
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

// DISMISS POPOVER ON IPAD
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed the popover");
    imagePickerPopover = nil;
}

// DISMISS KEYBOARD ON BG TAP
- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}


# pragma mark UIImagePickerController delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // check if we have already an image key
    NSString *oldKey = [item imageKey];
    if (oldKey) {
        // Delete the old image
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    
    // get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Create a CFUUID object - it knows how to create aunique indetifier strings
    //
    // CF -> Core Foundation (Collection of C Classes)
    // Ref -> it is a pointer
    // kCFAllocatorDefault -> let the system decide how to allocate memory
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    // Create a string of the unique identifier
    CFStringRef newUniqueIDString =
        CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    // use that unique ID to set our item's image key
    // toll free bridging between C to ObjectiveC
    // that means: instances of classes look exactly the same as their conuterpart in memory
    NSString *key = (__bridge NSString *)newUniqueIDString;
    
    // set the image key
    [item setImageKey:key];
    
    // store the image in the BNRImageStore with this key
    [[BNRImageStore sharedStore] setImage:image forKey:[item imageKey]];
    
    // Core Foundation objects don't recognize when they loose their owner
    // => Causes memory leak
    CFRelease(newUniqueID);
    CFRelease(newUniqueIDString);
    
    // put that image onto the screen in your image view
    [imageView setImage:image];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // Take image picker off the screen -
        // you must call this dismiss method
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // on ipad, the image picker is in the popover. Dismiss the popover
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}

# pragma mark UITextFiled delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end