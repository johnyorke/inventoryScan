//
//  appleLabelCell.m
//  inventroyScan
//
//  Created by John Yorke on 16/03/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "appleLabelCell.h"

@implementation appleLabelCell

@synthesize itemDescriptionLabel = _itemDescriptionLabel;
@synthesize itemQuantityOnHandLabel = _itemQuantityOnHandLabel;
@synthesize itemPriceLabel = _itemPriceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
