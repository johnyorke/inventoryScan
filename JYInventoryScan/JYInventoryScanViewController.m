//
//  JYInventoryScanViewController.m
//  inventoryScan
//
//  Created by John Yorke on 23/12/2012.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYInventoryScanViewController.h"
#import "JYInventoryScanScannerViewController.h"
#import "CHCSVParser.h"
#import "JYInventoryScanItem.h"
#import "JYInventoryScanInfoPaneViewController.h"

@interface JYInventoryScanViewController ()

@end

@implementation JYInventoryScanViewController

- (void)viewDidLoad
{
    UINavigationItem *n = [self navigationItem];
    
    [n setTitle:@"inventoryScan"];
                
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [scanModeButton setAlpha:0];
    [exportButton setAlpha:0];
    [deleteInventoryButton setAlpha:0];
    [versionLabel setAlpha:0];
    [tickGraphic setAlpha:0];
    [crossGraphic setAlpha:0];
    [tickLabel setAlpha:0];
    [infoPaneButton setAlpha:0];
    
    versionLabelCounter = 0;

    // Put icon in center (less 20pts for menu bar)
    appIcon.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, 
                                 [UIScreen mainScreen].bounds.size.height / 2 - 64); // 64 = navBar + statusBar
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) { // Checks for iPhone 5
        if (screenSize.height > 480.0f){
            [self fadeUpIconSlower];
        } else [self fadeUpIcon];
    }
    
    
    // Add tap gesture recognizers to icon, tick and cross graphic
    UITapGestureRecognizer *iconTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
            
    [appIcon addGestureRecognizer:iconTapRecognizer];
    
    UITapGestureRecognizer *tickTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tickTap:)];
    
    [tickGraphic addGestureRecognizer:tickTapRecognizer];
    
    UITapGestureRecognizer *crossTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(crossTap:)];
    
    [crossGraphic addGestureRecognizer:crossTapRecognizer];
            
}

- (void) viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[JYInventoryScanItemStore sharedStore] saveOutputData];

}

- (void) fadeInButtons
{
    [UIView animateWithDuration:0.3f
                     animations:^{
                         scanModeButton.alpha = 1;
                     }];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         exportButton.alpha = 1;
                     }];
    
    [UIView animateWithDuration:0.3f
                              animations:^{
                                  deleteInventoryButton.alpha = 1;
                              }];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         infoPaneButton.alpha = 1;
                     }];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         versionLabel.alpha = 1;
                     }];
}


-(void) fadeUpIcon
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         appIcon.center = CGPointMake(160, 72);
                     }
     completion:^(BOOL finished) {
         [self fadeInButtons];
         [self animateDataCheck];
     }
     ];
}

-(void) fadeUpIconSlower
{
    [UIView animateWithDuration:1.0f 
                          delay:0.8f 
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         appIcon.center = CGPointMake(160, 72);
                     }
                     completion:^(BOOL finished) {
                         [self fadeInButtons];
                         [self animateDataCheck];
                     }
     ];
}

- (void) tap: (UITapGestureRecognizer *) gr
{
    versionLabelCounter++;
    
    [versionLabel setAlpha:1.0];
        
    if (versionLabelCounter == 1) {
        [versionLabel setText:@"v0.7"];
    } else if (versionLabelCounter == 2) {
        [versionLabel setText:@"by John Yorke"];
    } else if (versionLabelCounter == 3) {
        [versionLabel setText:@""];
        versionLabelCounter = 0;
    }
}

- (BOOL) isInputDataAvailable
{
    NSArray *documentDirectories = 
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    BOOL inputDataFile = [[NSFileManager defaultManager] fileExistsAtPath:[documentDirectory stringByAppendingPathComponent:@"inputData.txt"]];
        
    return inputDataFile;
}

- (void) animateDataCheck
{
    // Keep these for the default position of the tickGraphic/crossGraphic
    CGFloat tickX = tickGraphic.center.x;
    CGFloat tickY = tickGraphic.center.y;
    CGFloat crossX = crossGraphic.center.x;
    CGFloat crossY = crossGraphic.center.y;
    
    [tickGraphic setAlpha:0];
    [crossGraphic setAlpha:0];
    
    if ([self isInputDataAvailable]) {
        tickGraphic.center = CGPointMake(tickGraphic.center.x - 200, tickGraphic.center.y);
        [UIView animateWithDuration:0.3f 
                              delay:0.4
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             tickGraphic.alpha = 1;
                             tickGraphic.center = CGPointMake(tickGraphic.center.x + 200, tickY);
                             [tickLabel setText:@"inputData.txt found"];
                             tickLabel.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             tickGraphic.center = CGPointMake(tickX, tickY);
                         }];
    } else {
        crossGraphic.center = CGPointMake(crossGraphic.center.x - 200, crossGraphic.center.y);
        [UIView animateWithDuration:0.3f 
                              delay:0.4
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             crossGraphic.alpha = 1;
                             crossGraphic.center = CGPointMake(crossGraphic.center.x + 200, crossY);
                             [tickLabel setText:@"inputData.txt not found"];
                             tickLabel.alpha = 1;
                         }
                         completion:^(BOOL finished) {
                             crossGraphic.center = CGPointMake(crossX, crossY);
                             
                         }];
    }
}


- (IBAction)enterScanMode:(id)sender 
{
    if ([self isInputDataAvailable] == NO) {
        [self showNoInputDataMessage];
    } else {
        JYInventoryScanScannerViewController *scannerViewController = [[JYInventoryScanScannerViewController alloc]
                                                                    initWithNibName:@"JYInventoryScanScannerViewController" bundle:[NSBundle mainBundle]];
        
        //[self presentViewController:scannerViewController animated:YES completion:nil];
        
        [[self navigationController] pushViewController:scannerViewController animated:YES];
    }
}

- (IBAction)exportOutputData:(id)sender 
{
    if ([[JYInventoryScanItemStore sharedStore].outputData count] == 0) {
        [self noOutputDataFoundMessage];
    } else {
        // Set up CHSSV to write to outputData.txt
        CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToCSVFile:self.documentFilePath];
        
        // For every item in the outputData array, write a line to the outputData.txt
        for (JYInventoryScanItem *item in [JYInventoryScanItemStore sharedStore].outputData) {
            
            // Change the order here for other systems?
            // Check whether you have UPC or in-store SKU
            if ([item.itemUpc isEqual: @""]) {
                [writer writeField:item.itemSku];
            } else [writer writeField:item.itemUpc];
            
            [writer writeField:item.itemQuantityOnHand];
            
            [writer finishLine];
        }
                
        // Now lob the file into an email if device can send email
        if ([MFMailComposeViewController canSendMail] == YES) {
            MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
            
            [mailView setMailComposeDelegate:self];
            
            [mailView setSubject:@"outputData.txt File"];
            
            // Create message body text with the total number of scanned items included
            NSString *messageBodyText = [NSString stringWithFormat:@"outputData.txt file attached with %d units.",[[JYInventoryScanItemStore sharedStore] numberOfUnits]];
            [mailView setMessageBody:messageBodyText isHTML:YES];
            
            [mailView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
            
            NSData *attachment = [NSData dataWithContentsOfFile:[self documentFilePath]];
            
            [mailView addAttachmentData:attachment mimeType:@"text/plain" fileName:@"outputData.txt"];
            
            [self presentViewController:mailView animated:YES completion:nil];
        } else NSLog(@"No email set up"); // Should swap to error message with user notification
    }
}

- (IBAction)deleteOutputData:(id)sender // Used only to show error message to user, does no deleting
{
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"Do you wish to delete all scanned inventory?" 
                                                          message:@"Only delete once you have emailed your scanned inventory and are ready to move onto your next area." 
                                                         delegate:self 
                                                cancelButtonTitle:@"Keep it" 
                                                otherButtonTitles:@"Delete it", nil];
    
    [deleteAlert setCancelButtonIndex:0];
    
    [deleteAlert show];
}


- (NSString *) documentFilePath // returns full path to the outputData.txt
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"outputData.txt"];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfoPane:(id)sender 
{
    JYInventoryScanInfoPaneViewController *infoPane = [[JYInventoryScanInfoPaneViewController alloc]
                                                            initWithNibName:@"JYInventoryScanInfoPaneViewController" bundle:[NSBundle mainBundle]];
    
    infoPane.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self.navigationController presentViewController:infoPane animated:YES completion:nil];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // NB!! If other UIAlerts are shown to user with more than one button outputData will get deleted
    // if they tap the button where index == 1. Update for future.
    
    if (buttonIndex == 1) { 
        NSLog(@"Delete that flipper!");
        
        NSFileManager *fm = [[NSFileManager alloc] init];
        
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentDirectory = [documentDirectories objectAtIndex:0];
        
        // Remove outputData, the archive and the inbox folder containing mail.app files
        [fm removeItemAtPath:[documentDirectory stringByAppendingPathComponent:@"outputData.txt"] error:nil];
        [fm removeItemAtPath:[documentDirectory stringByAppendingPathComponent:@"items.archive"] error:nil];
        [fm removeItemAtPath:[documentDirectory stringByAppendingPathComponent:@"Inbox"] error:nil];
        
        // Clear the outputData
        [JYInventoryScanItemStore sharedStore].outputData = nil;
    }
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [JYInventoryScanItemStore sharedStore].outputData = [[NSMutableArray alloc] init];
    }
}

- (void) showNoInputDataMessage // Shown when user hits scanner mode with no inputData loaded
{
    UIAlertView *noInputData = [[UIAlertView alloc] initWithTitle:@"No inputData.txt loaded" 
                                                          message:@"Email or file transfer the inputData.txt file to this device to begin." 
                                                         delegate:self 
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil, nil];
    
    [noInputData setCancelButtonIndex:0];
    
    [noInputData show];
}

- (void) noOutputDataFoundMessage // Shown when user goes to email file when outputData count == 0
{
    UIAlertView *noOutputData = [[UIAlertView alloc] initWithTitle:@"No outputData.txt found" 
                                                          message:@"Scan products to start building your outputData.txt file." 
                                                         delegate:self 
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil, nil];
    
    [noOutputData setCancelButtonIndex:0];
    
    [noOutputData show];
}

- (void) tickTap:(UITapGestureRecognizer *)gr // Checks for new inputData
{
    [tickGraphic setAlpha:0];
    [crossGraphic setAlpha:0];
    [self animateDataCheck];
}

- (void) crossTap:(UITapGestureRecognizer *)gr // Checks for new inputData
{
    [tickGraphic setAlpha:0];
    [crossGraphic setAlpha:0];
    [self animateDataCheck];
}

- (void) viewDidDisappear:(BOOL)animated // Changes view title to Menu for display on the back button
{
    UINavigationItem *n = [self navigationItem];
    
    [n setTitle:@"Menu"];
}

- (void) viewWillAppear:(BOOL)animated // Changes view title back to inventoryScan when returning to main menu
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    UINavigationItem *n = [self navigationItem];
    
    [n setTitle:@"inventoryScan"];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

-(void) viewWillDisappear:(BOOL)animated
{

}

- (UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}










@end
