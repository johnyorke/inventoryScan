//
//  JYInventoryScanInfoPaneViewController.h
//  inventoryScan
//
//  Created by John Yorke on 24/02/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JYInventoryScanInfoPaneViewController : UIViewController
{
    __weak IBOutlet UIButton *infoButton;
    
    __weak IBOutlet UILabel *textField;
}

- (IBAction)backToMenu:(id)sender;


@end
