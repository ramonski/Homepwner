//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Ramon Bartl on 08.01.13.
//  Copyright (c) 2013 Ramon Bartl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRItem;

@interface BNRItemStore: NSObject {
    NSMutableArray *allItems;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (BNRItemStore *)sharedStore;

- (NSString *)itemArchivePath;
- (BOOL)saveChanges;

- (NSArray *)allItems;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)p;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;

- (void)loadAllItems;
- (NSArray *)allAssetTypes;

@end