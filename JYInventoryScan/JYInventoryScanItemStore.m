//
//  JYInventoryScanItemStore.m
//  inventoryScan
//
//  Created by John Yorke on 18/02/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYInventoryScanItemStore.h"
#import "JYInventoryScanItem.h"

@implementation JYInventoryScanItemStore

@synthesize inData, outData;
@synthesize inDataString;

-(id) init
{
    self = [super init];
    if (self) {
        inData = [[NSMutableArray alloc] init];
        // outData = [[NSMutableArray alloc] init];
        
        NSString *path = [self itemArchivePath];
        outData = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
                
        if (!outData) {
            outData = [[NSMutableArray alloc] init];
        }
        
        inDataString = [[NSString alloc] init];
    }
    
    return self;
}

+(JYInventoryScanItemStore *) sharedStore
{
    static JYInventoryScanItemStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return  sharedStore;
}

+(id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

-(JYInventoryScanItem *) createItem
{
    JYInventoryScanItem *i = [[JYInventoryScanItem alloc] init];
        
    return i;
}

- (NSString *) itemArchivePath
{
    // Returns path of where to put archive
    NSArray *documentDirectories = 
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                        NSUserDomainMask, 
                                        YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL) saveOutData
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:outData toFile:path];
}

- (NSUInteger) numberOfUnits
{
    // Calculates total number of scanned items
    NSUInteger totalNumberOfUnits = 0;
    
    // QTYs stored as strings so have to convert to int values first using integerValue method
    for (JYInventoryScanItem *item in outData) {
        totalNumberOfUnits = [item.itemQuantityOnHand integerValue] + totalNumberOfUnits;
    }
    
    return totalNumberOfUnits;
}


@end
