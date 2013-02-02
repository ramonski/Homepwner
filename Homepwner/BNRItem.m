//
//  BNRItem.m
//  Homepwner
//
//  Created by Ramon Bartl on 08.01.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

@synthesize itemName, imageKey;
@synthesize containedItem, container, serialNumber, valueInDollars, dateCreated;


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
    }
    return self;
}

@end