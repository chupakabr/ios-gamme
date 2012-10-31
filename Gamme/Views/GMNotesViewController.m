//
//  GMNotesViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/24/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMNotesViewController.h"
#import "GMNib.h"

@implementation GMNotesViewController

@synthesize navBarItem = _navBarItem;
@synthesize textView = _textView;

- (id) initWithTitle:(NSString *)title andData:(NSString *)data
{
    self = [super initWithNibName:[GMNib getNibName:@"GMNotesViewController"] bundle:nil];
    if (self) {
        title_ = [title retain];
        data_ = [data retain];
    }
    return self;
}

- (void) dealloc
{
    [title_ release];
    [data_ release];
    [super dealloc];
}

#pragma mark - UI Actions

- (IBAction) backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Title
    [self.navBarItem setTitle:title_];
    
    // Text data
    [self.textView setText:data_];
    
    // Set BG
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[GMNib getBgImageName]]];
//    self.textView.backgroundColor = [UIColor clearColor];
    
    // Rename Cancel button to Back button
    UIBarButtonItem * btn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)] autorelease];
    [self.navBarItem setLeftBarButtonItem:btn];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Unset BG
    self.view.backgroundColor = nil;
    
    // Clean views
    self.textView = nil;
    self.navBarItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
