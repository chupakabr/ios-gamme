//
//  GMSimpleListFormTableViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMSimpleListFormTableViewController.h"
#import "GMAppDelegate.h"
#import "GMAddGenreFormController.h"
#import "GMNib.h"
#import "GMLog.h"


@implementation GMSimpleListFormTableViewController

@synthesize tableView = _tableView;
@synthesize navBarItem = _navBarItem;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title datasource:(id<UITableViewDataSource>)datasource delegate:(id<UITableViewDelegate>)delegate;
{
    GMLog(@"GMSimpleListFormTableViewController - initWithNibName()");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaultTitle_ = [title copy];
        datasource_ = [datasource retain];
        delegate_ = [delegate retain];
    }
    return self;
}

- (void) dealloc
{
    [defaultTitle_ release];
    [datasource_ release];
    [delegate_ release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = datasource_;
    self.tableView.delegate = delegate_;
    
    // Title
    [self.navBarItem setTitle:defaultTitle_];
    
    // Set BG
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[GMNib getBgImageName]]];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[[UIView alloc] init] autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Unset BG
    self.view.backgroundColor = nil;
    
    // Clean views
    self.tableView = nil;
    self.navBarItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Sync with DB
    [self.tableView reloadData];
    
    // Go to edit mode if no data exists
    if ([self.tableView numberOfRowsInSection:0] <= 0) {
        [self editButtonPressed:self];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UI actions

- (IBAction) cancelButtonPressed:(id)sender
{
    GMLog(@"GMSimpleListFormTableViewController - cancelButtonPressed()");
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) editButtonPressed:(id)sender
{
    GMLog(@"GMSimpleListFormTableViewController - editButtonPressed()");
    
    if ([self.tableView isEditing]) {
        [self.tableView setEditing:NO animated:YES];
        [self.navBarItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonPressed:)] autorelease]];
    } else {
        [self.tableView setEditing:YES animated:YES];
        [self.navBarItem setRightBarButtonItem:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(editButtonPressed:)] autorelease]];
    }
    
    // Reload data
    [self.tableView reloadData];
}


@end
