//
//  JYInventoryScanItemStore.h
//  inventoryScan
//
//  Created by John Yorke on 18/02/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JYInventoryScanItem;

@interface JYInventoryScanItemStore : NSObject
{
    NSMutableArray *inputData;
    NSMutableArray *outputData;
    
    NSString *inputDataString;
}

@property NSMutableArray *inputData;
@property NSMutableArray *outputData;
@property NSString *inputDataString;

+ (JYInventoryScanItemStore *) sharedStore;

- (JYInventoryScanItem *) createItem;

- (NSString *) itemArchivePath;

- (BOOL) saveOutputData;

- (NSUInteger) numberOfUnits;

@end
