//
//  BNRItem.m
//  Homepwner
//
//  Created by Ramon Bartl on 08.01.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

@synthesize itemName, imageKey, thumbnail, thumbnailData;
@synthesize containedItem, container, serialNumber, valueInDollars, dateCreated;

- (UIImage *)thumbnail
{
    // If there is no thumbnail data, then I have no thumbnail to return
    if (!thumbnailData) {
        return  nil;
    }
    if (!thumbnail) {
        // If I have not yet created my thumbnail image from my data, do so now
        thumbnail = [UIImage imageWithData:thumbnailData];
    }
    return thumbnail;
}

- (void)setThumbnailDataFromImage:(UIImage *)image
{
    CGSize origImageSize = [image size];
    
    // The rectangle of the thumbnail
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    
    // Figure out the a scaling ratio to make sure we maintain the same aspect ratio
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height / origImageSize.height);
    
    
    
    // Create a transparent bitmap context with a scaling
    // factor equal to that of the screen
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);

    // Create a path that is a rounded rectangle
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    
    // Make all subsequent drawing clip to this rounded rectangle
    [path addClip];
    
    // Center the image in the rectangle
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height ;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height ) / 2.0;
    
    // Draw the image on it
    [image drawInRect:projectRect];
    
    // Get the image from the image context, keep it as our thumbnail
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setThumbnail:smallImage];
    
    // Get the PNG representation of the image and set it as our archivable data
    NSData *data = UIImagePNGRepresentation(smallImage);
    [self setThumbnailData:data];
    
    // Cleanup image context resources, we're done
    UIGraphicsEndImageContext();
}


+ (id)randomItem
{
    
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy",
                                                             @"Rusty",
                                                             @"Shiny", nil];
    
    NSArray *randomNounList = [NSArray arrayWithObjects:@"Bear",
                                                        @"Spork",
                                                        @"Mac", nil];
    
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndex = rand() % [randomNounList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                           [randomAdjectiveList objectAtIndex:adjectiveIndex],
                           [randomNounList objectAtIndex:nounIndex]];
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
                                    
    int randomValue = rand() % 100;
    
    BNRItem *newItem =
    [[self alloc] initWithItemName:randomName
                    valueInDollars:randomValue
                    serialNumber:randomSerialNumber];

    return newItem;
}

- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)sNumber
{
    self = [super init];
    if (self) {
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc] init];
    }
    return self;
}


- (void)setContainedItem:(BNRItem *)i
{
    containedItem = i;
    [i setContainer:self];
}

- (NSString *)description
{
    NSString *descriptionString =
        [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
                            itemName,
                            serialNumber,
                            valueInDollars,
                            dateCreated];
    return descriptionString;
}


# pragma mark NSCoding Protocol

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"ateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
    [aCoder encodeInt:thumbnailData forKey:@"thumbnailData"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        thumbnailData = [aDecoder decodeObjectForKey:@"thumbnailData"];
    }
    return self;
}

@end