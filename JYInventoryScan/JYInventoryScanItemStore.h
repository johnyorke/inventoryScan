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
    NSMutableArray *inData;
    NSMutableArray *outData;
    
    NSString *inDataString;
}

@property NSMutableArray *inData;
@property NSMutableArray *outData;
@property NSString *inDataString;

+ (JYInventoryScanItemStore *) sharedStore;

- (JYInventoryScanItem *) createItem;

- (NSString *) itemArchivePath;

- (BOOL) saveOutData;

- (NSUInteger) numberOfUnits;

@end
