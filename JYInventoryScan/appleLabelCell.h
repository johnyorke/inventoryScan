//
//  appleLabelCell.h
//  inventoryScan
//
//  Created by John Yorke on 16/03/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface appleLabelCell : UITableViewCell

{

}

@property (nonatomic, weak) IBOutlet UILabel *itemDescriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *itemQuantityOnHandLabel;
@property (nonatomic, weak) IBOutlet UILabel *itemPriceLabel;

@end
