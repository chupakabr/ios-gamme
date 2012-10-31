//
//  GMByDeveloperViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMByDeveloperViewController.h"
#import "GMAddGameFormController.h"
#import "GMNib.h"
#import "GMLog.h"


@implementation GMByDeveloperViewController

@synthesize navBarItem = _navBarItem;
@synthesize tableView = _tableView;
@synthesize dsdl = _dsdl;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    GMLog(@"GMByDeveloperViewController - initWithNibName()");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"By Author", nil);
        self.tabBarItem.image = [UIImage imageNamed:@"tab-by-developer"];
        self.dsdl = [[[GMAuthorNiceTableViewDSDL alloc] initWithParentController:self] autorelease];
    }
    return self;
}

- (void) dealloc
{
    self.dsdl = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    GMLog(@"GMByDeveloperViewController - didReceiveMemoryWarning()");
    
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    GMLog(@"GMByDeveloperViewController - viewDidLoad()");
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[GMNib getBgImageName]]];
    [self.navBarItem setTitle:NSLocalizedString(@"By Author", nil)];
    
    // Table view
    self.tableView.dataSource = self.dsdl;
    self.tableView.delegate = self.dsdl;
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
    GMLog(@"GMByDeveloperViewController - viewWillAppear()");
    
    [super viewWillAppear:animated];
    
    // Sync with DB
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UI actions

- (IBAction) addButtonPressed:(id)sender
{
    GMLog(@"GMByDeveloperViewController - addButtonPressed()");
    
    GMAddGameFormController * formController = [[[GMAddGameFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil] autorelease];
    [self.navigationController pushViewController:formController animated:YES];
}


@end
