//
//  JYInventoryScanItem.h
//  inventoryScan
//
//  Created by John Yorke on 18/02/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JYInventoryScanItem : NSObject <NSCoding, NSCopying>

{
    NSString *itemSku;
    NSString *itemUpc;
    NSString *itemDescription;
    NSString *itemPrice;
    NSString *itemQuantityOnHand;
}


@property (nonatomic, copy) NSString *itemSku;
@property (nonatomic, copy) NSString *itemUpc;
@property (nonatomic, copy) NSString *itemDescription;
@property (nonatomic, copy) NSString *itemPrice;
@property (nonatomic, copy) NSString *itemQuantityOnHand;

-(id) initItemWithSku: (NSString *) sku 
               andUpc: (NSString *) upc 
       andDescription: (NSString *) description 
             andPrice: (NSString *) price 
    andQuantityOnHand: (NSString *) quantityOnHand;

@end
