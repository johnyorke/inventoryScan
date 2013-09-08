//
//  JYInventoryScanScannerController.h
//  inventoryScan
//
//  Created by John Yorke on 17/02/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYInventoryScanViewController.h"
#import "CHCSVParser.h"
#import "JYInventoryScanItemStore.h"
#import <AVFoundation/AVFoundation.h>
#import "DTDevices.h"

@interface JYInventoryScanScannerViewController : UIViewController <UITextFieldDelegate, DTDeviceDelegate>
{
    __weak IBOutlet UITextField *enteredSkuField;
    __weak IBOutlet UITextField *enteredQtyField;
    __weak IBOutlet UILabel *itemDescriptionLabel; // Label desc
    __weak IBOutlet UILabel *itemQuantityOnHandLabel; // Label QOH
    __weak IBOutlet UILabel *itemPriceLabel; // Label price
    __weak IBOutlet UILabel *itemCountLabel; // Total scanned item count
    
    AVAudioPlayer *audioPlayer; // Set up to output sound in absence of scanner
    
    DTDevices *dtdev; // Scanner
    
    __weak IBOutlet UILabel *batteryCapacity;
    
    __weak IBOutlet UIImageView *appleLabel;
}

@property (nonatomic, weak) UITextField *enteredSkuField;
@property (nonatomic, weak) UITextField *enteredQtyField;
@property (nonatomic, weak) UILabel *itemDescriptionLabel;
@property (nonatomic, weak) UILabel *itemQuantityOnHandLabel;
@property (nonatomic, weak) UILabel *itemPriceLabel;

// Used to set label desc, qty and price
- (void) setItemDescription: (NSString *) itemDescription 
      andItemQuantityOnHand: (NSString *) quantityOnHand 
                   andPrice: (NSString *) price;

// On successful match in indata
- (void) playGoodBeepAtVolume: (NSInteger) volume;

// On unscuccessful match in indata
- (void) playBadBeepAtVolume: (NSInteger) volume;

// Looks in indata for string in enteredSkuField
- (void) searchInIndata: (NSString *) searchData;

// Updates label when connected and on textFieldShouldReturn
- (void) updateScannerBattery;

// Adds ItemsViewController to stack
- (void) tapLabel: (UITapGestureRecognizer *) gr;

// Takes indata.txt and loads into one big string
// Called whenever view loads or appears
- (void) loadInDataIntoString;

@end
