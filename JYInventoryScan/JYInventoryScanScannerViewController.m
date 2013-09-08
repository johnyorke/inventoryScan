//
//  JYInventoryScanScannerController.m
//  inventoryScan
//
//  Created by John Yorke on 17/02/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYInventoryScanScannerViewController.h"
#import "CHCSVParser.h"
#import "JYInventoryScanItem.h"
#import "JYInventoryScanItemStore.h"
#import "JYInventoryScanItemsViewController.h"

@interface JYInventoryScanScannerViewController ()

@end

@implementation JYInventoryScanScannerViewController

@synthesize itemDescriptionLabel, itemPriceLabel, itemQuantityOnHandLabel, enteredQtyField, enteredSkuField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Attempt to connect to scanner and configure
        dtdev = [DTDevices sharedDevice];
        [dtdev setDelegate:self];
        [dtdev connect];
        
        if (dtdev.connstate == 2) {
            [dtdev barcodeStartScan:nil];
            [dtdev setCharging:NO error:nil];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    UINavigationItem *n = [self navigationItem];
    [n setTitle:@"Scanner"];
            
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Set low alpha for default label
    [itemDescriptionLabel setAlpha:0.1];
    [itemPriceLabel setAlpha:0.1];
    [itemQuantityOnHandLabel setAlpha:0.1];
    
    [enteredSkuField becomeFirstResponder];
    
    [self loadInDataIntoString];
    
    // Calculate total number of items scanned so far
    [itemCountLabel setText:[NSString stringWithFormat:@"%d",[[JYInventoryScanItemStore sharedStore] numberOfUnits]]];
    
    // Add tap gesture recognizers to icon, tick and cross graphic
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLabel:)];
    [appleLabel addGestureRecognizer:tapGestureRecognizer];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [self loadInDataIntoString];
    [dtdev connect];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [[JYInventoryScanItemStore sharedStore] saveOutData];
}

- (void) setItemDescription: (NSString *) itemDescription 
      andItemQuantityOnHand: (NSString *) quantityOnHand 
                   andPrice: (NSString *) price
{
    [itemDescriptionLabel setAlpha:1];
    [itemPriceLabel setAlpha:1];
    [itemQuantityOnHandLabel setAlpha:1];
    
    [itemDescriptionLabel setText:itemDescription];
        
    [itemQuantityOnHandLabel setText:quantityOnHand];
            
    [itemPriceLabel setText:price];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    // This method is called when user returns off either qty or desc fields
    // It takes desc string and THEN uses following method to find match
    
    // Seach in the indata for the enteredSkuField's text
    [self searchInIndata:enteredSkuField.text];
    
    // Go back to the SKU field
    [enteredSkuField becomeFirstResponder];
    
    // If scanner is connected refresh the scanner battery level
    if ([dtdev connstate] == 2) {
        [self updateScannerBattery];
    }
    
    return YES;
}

- (void) playGoodBeepAtVolume:(NSInteger)volume
{
    // If scanner is connected use speaker on scanner
    if ([dtdev connstate] == 2) {
        int beepData[]={3400,100,4000,100};
        
        [dtdev playSound:100 beepData:beepData length:sizeof(beepData) error:nil];
    } else {
        
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/goodBeep.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        
        audioPlayer.volume = volume;
        
        [audioPlayer play];
        
    }
    
}

- (void) playBadBeepAtVolume:(NSInteger)volume
{
    // If scanner is connected use speaker on scanner
    if ([dtdev connstate] == 2) {
        int beepData[]={700,200,100,300};
        
        [dtdev playSound:100 beepData:beepData length:sizeof(beepData) error:nil];
        
    } else {
        
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/badBeep.mp3", [[NSBundle mainBundle] resourcePath]]];
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
        
        audioPlayer.volume = volume;
        
        [audioPlayer play];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

- (void) searchInIndata: (NSString *) searchData
{
    NSString *enteredSearch = searchData;
    
    // Check length of sku is above 10 characters to prevent accidental searches for "1", "123"
    if (enteredSearch.length > 10) {
        // Find the location in indataString of matching SKU/UPC
        NSRange range = [[JYInventoryScanItemStore sharedStore].inDataString rangeOfString:enteredSearch options:NSCaseInsensitiveSearch];
        
        // NSRange length returns 0 if it can't be found 
        if (range.length != 0) { 
            // Means there is a match
            
            // Test to see enteredQtyField is a number
            int qtyField = [enteredQtyField.text integerValue];
            if (qtyField == 0) {
                enteredQtyField.text = @"1";
            }
            
            // Return the complete line the range exists on
            NSRange lineRange = [[JYInventoryScanItemStore sharedStore].inDataString lineRangeForRange:range];
            
            NSString *line = [[JYInventoryScanItemStore sharedStore].inDataString substringWithRange:lineRange];
            
            // Parse it
            CHCSVParser *parser = [[CHCSVParser alloc] initWithCSVString:line];
            parser.sanitizesFields = YES;
            [parser parse];
            
            // Put the components in array for the JYInventoryScanItem to take from
            NSArray *components = [line CSVComponents];
            
            // Create an item to store that info
            JYInventoryScanItem *newItem = [[JYInventoryScanItem alloc] initItemWithSku:[[components objectAtIndex:0] objectAtIndex:0] 
                                                                           andUpc:[[components objectAtIndex:0] objectAtIndex:1] 
                                                                   andDescription:[[components objectAtIndex:0] objectAtIndex:2] 
                                                                         andPrice:[[components objectAtIndex:0] objectAtIndex:3] 
                                                                andQuantityOnHand:[[components objectAtIndex:0] objectAtIndex:4]];
            
            // Set the Apple label
            [self setItemDescription:[newItem itemDescription] 
               andItemQuantityOnHand:[newItem itemQuantityOnHand] 
                            andPrice:[newItem itemPrice]];
                        
            // Now save the new item with the correct quantityOnHand
            if ([enteredQtyField.text isEqualToString:@""]) {
                [newItem setItemQuantityOnHand:@"1"];
            } else newItem.itemQuantityOnHand = enteredQtyField.text;
            
            
            // Add it to the outData array
            [[JYInventoryScanItemStore sharedStore].outData addObject:newItem];
            
            // Update the total item count label
            [itemCountLabel setText:[NSString stringWithFormat:@"%d",[[JYInventoryScanItemStore sharedStore] numberOfUnits]]];
            
            // Save in case of crash
            [[JYInventoryScanItemStore sharedStore] saveOutData];
            
            [self playGoodBeepAtVolume:1];
            
            // Reset the labels
            [enteredSkuField setText:@""];
            [enteredQtyField setText:@""];
            
        } else { // if range.length = 0 (aka no match found in indataString
            [itemDescriptionLabel setAlpha:1];
            [itemPriceLabel setAlpha:1];
            [itemQuantityOnHandLabel setAlpha:1];
            [itemDescriptionLabel setText:@"ITEM NOT FOUND"];
            [itemPriceLabel setText:@"N/A"];
            [itemQuantityOnHandLabel setText:@"N/A"];
            [self playBadBeepAtVolume:1];
            if ([dtdev connstate] == 2) { // in case user doesn't have scanner and needs to correct
                [enteredSkuField setText:@""];
            }
            [enteredQtyField setText:@""];
        }
        
    } else { // if enteredSku.text length < 10 (aka user returned short number by accident)
        [itemDescriptionLabel setAlpha:1];
        [itemPriceLabel setAlpha:1];
        [itemQuantityOnHandLabel setAlpha:1];
        [itemDescriptionLabel setText:@"ITEM NOT FOUND"];
        [itemPriceLabel setText:@"N/A"];
        [itemQuantityOnHandLabel setText:@"N/A"];
        [self playBadBeepAtVolume:1];
        if ([dtdev connstate] == 2) { // in case user doesn't have scanner and needs to correct
            [enteredSkuField setText:@""]; 
        }
        [enteredQtyField setText:@""];
    }
}
    

- (void) loadInDataIntoString
{
    // Create the url to the indata file
    NSError * error;
    NSString * stringFromFile;
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    NSString * stringFilepath = [documentDirectory stringByAppendingPathComponent:@"indata.txt"];
    
    // Create a string from the contents
    stringFromFile = [[NSString alloc] initWithContentsOfFile:stringFilepath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    
    [JYInventoryScanItemStore sharedStore].inDataString = stringFromFile;
}

- (void) barcodeData:(NSString *)barcode type:(int)type
{
    // Called when barcode is successfully read by scanner
    
    // Set SkuField to scanned text
    enteredSkuField.text = barcode;
    
    // Act as if user had hit return
    [self textFieldShouldReturn:enteredSkuField];
    
    // Sets the volume and beeps of the scanner
    [dtdev barcodeSetScanBeep:YES volume:0 beepData:nil length:0 error:nil];
}

- (void) updateScannerBattery
{
    int percent;
    
    if ([dtdev getBatteryCapacity:&percent voltage:nil error:nil]) {
        [batteryCapacity setText:[NSString stringWithFormat:@"Scanner Battery at %d%%", percent]];
    }
    
}

- (void) connectionState:(int)state
{
    switch (state) {
        case CONN_DISCONNECTED:
            NSLog(@"Disconnected");
            break;
            
        case CONN_CONNECTING:
            NSLog(@"Connecting");
            
        case CONN_CONNECTED:
            NSLog(@"Connected");
            NSLog(@"%d", dtdev.connstate);
            [self updateScannerBattery];

            break;
    }
}

- (void) tapLabel:(UITapGestureRecognizer *)gr
{
    JYInventoryScanItemsViewController *itemsViewController = [[JYInventoryScanItemsViewController alloc]
                                                            initWithNibName:@"JYInventoryScanItemsViewController" bundle:[NSBundle mainBundle]];
        
    [[super navigationController] pushViewController:itemsViewController animated:YES];
    
}

- (void) viewWillDisappear:(BOOL)animated
{
    // Disconnect to save battery and prevent accidental scans
    [dtdev disconnect];
    
    // Save outdata
    [[JYInventoryScanItemStore sharedStore] saveOutData];
}















@end
