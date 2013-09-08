//
//  JYInventoryScanViewController.h
//  inventoryScan
//
//  Created by John Yorke on 23/12/2012.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "JYInventoryScanScannerViewController.h"
#import "JYInventoryScanItemStore.h"

@interface JYInventoryScanViewController : UIViewController <MFMailComposeViewControllerDelegate, UIAlertViewDelegate, UINavigationControllerDelegate>
{
    __weak IBOutlet UIImageView *appIcon;
    
    __weak IBOutlet UIButton *scanModeButton;
    __weak IBOutlet UIButton *exportButton;
    __weak IBOutlet UIButton *deleteInventoryButton;
    
    __weak IBOutlet UILabel *versionLabel;
    NSInteger versionLabelCounter;
    
    __weak IBOutlet UIImageView *tickGraphic;
    __weak IBOutlet UIImageView *crossGraphic;
    __weak IBOutlet UILabel *tickLabel;
    
    __weak IBOutlet UIButton *infoPaneButton;
}

-(void) fadeInButtons; // Called after icon has faded up

-(void) fadeUpIcon;

-(void) fadeUpIconSlower; // Great for fast phones

-(void) tap: (UITapGestureRecognizer *) gr; // Used on icon to cycle through versionLabel

-(void) tickTap: (UITapGestureRecognizer *) gr; // Used to refresh indata check

-(void) crossTap: (UITapGestureRecognizer *) gr; // Used to refresh indata check

-(BOOL) isInDataAvailable;

-(void) animateDataCheck;

- (IBAction)enterScanMode:(id)sender;

- (IBAction)exportOutData:(id)sender;

- (IBAction)deleteOutData:(id)sender;

- (NSString *) documentFilePath;

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error;

- (IBAction)showInfoPane:(id)sender;

- (void) showNoIndataMessage;

- (void) noOutdataFoundMessage;

@end
