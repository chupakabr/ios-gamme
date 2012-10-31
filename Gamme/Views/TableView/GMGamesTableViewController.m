//
//  GMGamesTableViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/19/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMGamesTableViewController.h"
#import "GMPlatformInfoViewController.h"
#import "GMAuthorInfoViewController.h"
#import "GMLog.h"

@implementation GMGamesTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title model:(NSManagedObject *)model dsdl:(GMAbstractSimpleFormTableViewDSDL *)dsdl
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil title:title datasource:dsdl delegate:dsdl];
    if (self) {
        model_ = [model retain];
        [dsdl setParentController:self];
    }
    
    return self;
}

- (void) dealloc
{
    [model_ release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Rename Cancel button to Back button
    UIBarButtonItem * btn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)] autorelease];
    [self.navBarItem setLeftBarButtonItem:btn];
    
    // Show/Hide info button
    if (!model_ || [model_ isKindOfClass:[Genre class]]) {
        self.navBarItem.rightBarButtonItem = nil;
    }
}

- (IBAction) editButtonPressed:(id)sender
{
    // do nothing
}

- (IBAction) infoButtonPressed:(id)sender
{
    GMLog(@"GMGamesTableViewController - editButtonPressed() show info button");
    
    if ([model_ isKindOfClass:[Platform class]]) {
        GMPlatformInfoViewController * controller = [[[GMPlatformInfoViewController alloc] initWithModel:model_] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if ([model_ isKindOfClass:[Author class]]) {
        GMAuthorInfoViewController * controller = [[[GMAuthorInfoViewController alloc] initWithModel:model_] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        [NSException raise:NSInternalInconsistencyException format:@"Model must be set when info button is displayed. Model: %@", model_];
    }
    
}

@end
