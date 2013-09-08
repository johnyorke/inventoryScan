//
//  JYInventoryScanAppDelegate.h
//  inventoryScan
//
//  Created by John Yorke on 23/12/2012.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYInventoryScanViewController;

@interface JYInventoryScanAppDelegate : UIResponder <UIApplicationDelegate>
{
    // URL to incoming indata file from email.app
    NSString *indataNew;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JYInventoryScanViewController *viewController;

@end
