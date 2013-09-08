//
//  JYInventoryScanItem.m
//  inventoryScan
//
//  Created by John Yorke on 18/02/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYInventoryScanItem.h"

@implementation JYInventoryScanItem

@synthesize itemSku, itemUpc, itemDescription,itemPrice,itemQuantityOnHand;

-(id) initItemWithSku: (NSString *) sku 
               andUpc: (NSString *) upc 
       andDescription: (NSString *) description 
             andPrice: (NSString *) price 
    andQuantityOnHand: (NSString *) quantityOnHand
{
    self = [super init];
    
    if (self) {
        itemSku = sku;
        itemUpc = upc;
        itemDescription = description;
        itemPrice = price;
        itemQuantityOnHand = quantityOnHand;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Used when archiving
    [aCoder encodeObject:itemSku forKey:@"itemSku"];
    [aCoder encodeObject:itemUpc forKey:@"itemUpc"];
    [aCoder encodeObject:itemDescription forKey:@"itemDescription"];
    [aCoder encodeObject:itemPrice forKey:@"itemPrice"];
    [aCoder encodeObject:itemQuantityOnHand forKey:@"itemQuantityOnHand"];
}

- (id)initWithCoder:(NSCoder *) aDecoder
{
    // Used when unarchiving
    self = [super init];
    if (self) {
        [self setItemSku:[aDecoder decodeObjectForKey:@"itemSku"]];
        [self setItemUpc:[aDecoder decodeObjectForKey:@"itemUpc"]];
        [self setItemDescription:[aDecoder decodeObjectForKey:@"itemDescription"]];
        [self setItemPrice:[aDecoder decodeObjectForKey:@"itemPrice"]];
        [self setItemQuantityOnHand:[aDecoder decodeObjectForKey:@"itemQuantityOnHand"]];
    }
    
    return self;
}

- (NSString *) description
{
    // Used when compiling outdata.txt
    // Checks whether to use UPC or SKU
    if ([itemUpc isEqual: @""]) {
        return [NSString stringWithFormat:@"%@\",\"%@", itemSku, itemQuantityOnHand];
    } else return [NSString stringWithFormat:@"%@\",\"%@", itemUpc, itemQuantityOnHand];
}

- (id) init
{
    return [self initItemWithSku:@"" andUpc:@"" andDescription:@"" andPrice:@"" andQuantityOnHand:@""];
}

- (id) copy
{
    JYInventoryScanItem *copiedItem = [[JYInventoryScanItem alloc] init];
    
    return copiedItem;
}

- (id) copyWithZone:(NSZone *)zone
{
    return self;
}


@end
