//
//  ImageViewController.h
//  Homepwner
//
//  Created by Ramon Bartl on 02.02.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController {

    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIScrollView *scrollView;
}

@property (nonatomic, strong) UIImage *image;

@end