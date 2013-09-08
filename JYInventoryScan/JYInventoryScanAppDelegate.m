//
//  JYInventoryScanAppDelegate.m
//  inventoryScan
//
//  Created by John Yorke on 23/12/2012.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYInventoryScanAppDelegate.h"

#import "JYInventoryScanViewController.h"

@implementation JYInventoryScanAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    //    self.viewController = [[JYInventoryScanViewController alloc] initWithNibName:@"JYInventoryScanViewController" bundle:[NSBundle mainBundle]];
    //    self.window.rootViewController = self.viewController;
    //    [self.window makeKeyAndVisible];
    
    //create a ItemsViewController
    JYInventoryScanViewController *mainMenu = [[JYInventoryScanViewController alloc] init];
    
    // Create an instance of UINavigationController
    // its stack contains only mainMenu
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:mainMenu];
    
    // Place navigation controller's view in the window hierarchy
    [[self window] setRootViewController:navController];
    
    navController.navigationBar.tintColor = [UIColor blackColor];
        
    // Load incoming indata url from mail.app into a string
    indataNew = [launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
    
    [navController.navigationBar setTranslucent:NO];
    [navController.navigationBar setTintColor:[UIColor blueColor]];

    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];            
    return YES;
}

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{    
    // Overwrite existing indata with incoming and update main menu tick/cross
    NSFileManager *fm = [[NSFileManager alloc] init];
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                                       NSUserDomainMask, 
                                                                       YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    NSURL *oldFile = [NSURL URLWithString:[documentDirectory stringByAppendingPathComponent:@"indata.txt"]];
    
    [fm replaceItemAtURL:oldFile withItemAtURL:url backupItemName:nil options:0 resultingItemURL:nil error:nil];
    
    
    // Create the url to the indata file and update it in the indataString
    NSError * error;
    NSString * stringFromFile;
    NSArray *docDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [docDirectories objectAtIndex:0];
    NSString * stringFilepath = [docDirectory stringByAppendingPathComponent:@"indata.txt"];
    
    // Create a string from the contents
    stringFromFile = [[NSString alloc] initWithContentsOfFile:stringFilepath
                                                     encoding:NSUTF8StringEncoding
                                                        error:&error];
    
    [JYInventoryScanItemStore sharedStore].inDataString = stringFromFile;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    BOOL success = [[JYInventoryScanItemStore sharedStore] saveOutData];
    if (success) {
        NSLog(@"Saved all of the items");
    } else {
        NSLog(@"Could not save all of the items");
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    BOOL success = [[JYInventoryScanItemStore sharedStore] saveOutData];
    if (success) {
        NSLog(@"Saved all of the items");
    } else {
        NSLog(@"Could not save all of the items");
    }
}

@end
