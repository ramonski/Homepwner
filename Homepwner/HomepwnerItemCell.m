//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Ramon Bartl on 02.02.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "HomepwnerItemCell.h"

@implementation HomepwnerItemCell

@synthesize thumbnailView, nameLabel, serialNumberLabel, valueLabel, controller, tableView;



- (IBAction)showImage:(id)sender {
    
    // Get this name of this method, "showImage:"
    NSString *selector = NSStringFromSelector(_cmd);
    
    // selector is now "showImage:atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    
    // Prepare a selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    
    NSLog(@"%@: newSelector=%@", NSStringFromSelector(_cmd), NSStringFromSelector(newSelector));
    
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    if (indexPath) {
        NSLog(@"%@ - indexPath=%@", NSStringFromSelector(_cmd), indexPath);
        
        if ([[self controller] respondsToSelector:newSelector]) {
            [[self controller] performSelector:newSelector
                                    withObject:sender
                                    withObject:indexPath];
        }
    }
}

@end