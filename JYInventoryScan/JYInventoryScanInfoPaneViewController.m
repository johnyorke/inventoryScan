//
//  JYInventoryScanInfoPaneViewController.m
//  inventoryScan
//
//  Created by John Yorke on 24/02/2013.
//  Copyright (c) 2013 John Yorke. All rights reserved.
//

#import "JYInventoryScanInfoPaneViewController.h"
#import "JYInventoryScanViewController.h"

@interface JYInventoryScanInfoPaneViewController ()

@end

@implementation JYInventoryScanInfoPaneViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMenu:(id)sender 
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
}
@end
