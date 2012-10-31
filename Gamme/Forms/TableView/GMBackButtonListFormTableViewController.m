//
//  GMBackButtonListFormTableViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/3/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMBackButtonListFormTableViewController.h"
#import "GMLinksSimpleFormTableViewDSDL.h"

@implementation GMBackButtonListFormTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Rename Cancel button to Back button
    UIBarButtonItem * btn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)] autorelease];
    [self.navBarItem setLeftBarButtonItem:btn];
}

- (IBAction) cancelButtonPressed:(id)sender
{
    // Save current values
    if ([datasource_ respondsToSelector:@selector(applyNewData)]) {
        [datasource_ performSelector:@selector(applyNewData)];
    }
    else {
        [NSException raise:NSInternalInconsistencyException format:@"Datasource does not responds to applyNewData() sel"];
    }
    
    // Super call :-)
    [super cancelButtonPressed:sender];
}

@end
