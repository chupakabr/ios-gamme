//
//  GMHomeViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMHomeViewController.h"
#import "GMAddGameFormController.h"
#import "GMCompletedGamesTableViewDSDL.h"
#import "GMPlannedGamesTableViewDSDL.h"
#import "GMSearchGamesTableViewDSDL.h"
#import "GMGamesTableViewController.h"
#import "GMNib.h"
#import "GMLog.h"


@implementation GMHomeViewController

@synthesize navBarItem = _navBarItem;
@synthesize searchBar = _searchBar;
@synthesize completedButton = _completedButton;
@synthesize completedLabel = _completedLabel;
@synthesize plannedButton = _plannedButton;
@synthesize plannedLabel = _plannedLabel;
@synthesize searchResultLabel = _searchResultLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    GMLog(@"GMHomeViewController - initWithNibName()");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Home", @"Home");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-home"];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    GMLog(@"GMHomeViewController - didReceiveMemoryWarning()");
    
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    GMLog(@"GMHomeViewController - viewDidLoad()");
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[GMNib getBgImageName]]];
    [self.navBarItem setTitle:@""];
    
    // Buttons
    [self.completedLabel setText:NSLocalizedString(@"Completed", nil)];
    [self.plannedLabel setText:NSLocalizedString(@"Planned", nil)];
    
    // Search bar
    self.searchBar.placeholder = NSLocalizedString(@"Game title", nil);
    self.searchResultLabel.text = NSLocalizedString(@"Nothing was found", nil);
    self.searchResultLabel.backgroundColor = [UIColor clearColor];
    self.searchResultLabel.textColor = [UIColor colorWithRed:1.0 green:(CGFloat)63/255 blue:(CGFloat)63/255 alpha:1.0];
    self.searchResultLabel.alpha = 0.0;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Clear views
    self.completedButton = nil;
    self.completedLabel = nil;
    self.plannedButton = nil;
    self.plannedLabel = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    GMLog(@"GMHomeViewController - viewWillAppear()");
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    GMLog(@"GMHomeViewController - viewDidAppear()");
    
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    GMLog(@"GMHomeViewController - viewWillDisappear()");
    
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    GMLog(@"GMHomeViewController - viewDidDisappear()");
    
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//        return (interfaceOrientation == UIInterfaceOrientationPortrait);
//    } else {
//        return YES;
//    }
}


#pragma mark - UI actions

- (IBAction) addButtonPressed:(id)sender
{
    GMLog(@"GMHomeViewController - addButtonPressed()");
    
    GMAddGameFormController * formController = [[[GMAddGameFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil] autorelease];
    [self.navigationController pushViewController:formController animated:YES];
}

- (IBAction) completedButtonPressed:(id)sender
{
    GMCompletedGamesTableViewDSDL * dsdl = [[[GMCompletedGamesTableViewDSDL alloc] initWithModel:nil] autorelease];
    GMGamesTableViewController * controller = [[[GMGamesTableViewController alloc] 
                                                initWithNibName:[GMNib getNibName:@"GMGamesTableViewController"] 
                                                bundle:nil 
                                                title:NSLocalizedString(@"Completed", nil)
                                                model:nil
                                                dsdl:dsdl
                                                ] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) plannedButtonPressed:(id)sender
{
    GMPlannedGamesTableViewDSDL * dsdl = [[[GMPlannedGamesTableViewDSDL alloc] initWithModel:nil] autorelease];
    GMGamesTableViewController * controller = [[[GMGamesTableViewController alloc] 
                                                initWithNibName:[GMNib getNibName:@"GMGamesTableViewController"] 
                                                bundle:nil 
                                                title:NSLocalizedString(@"Planned", nil)
                                                model:nil
                                                dsdl:dsdl
                                                ] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UISearchBarDelegate impl

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    // Try to find something
    GMSearchGamesTableViewDSDL * dsdl = [[[GMSearchGamesTableViewDSDL alloc] initWithTitle:searchBar.text] autorelease];
    NSUInteger resultsCount = [dsdl resultsCount];
    
    if (resultsCount <= 0) {
        [UIView animateWithDuration:1.0
                         animations:^{
                             self.searchResultLabel.alpha = 1.0;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:3.0
                                              animations:^{
                                                  self.searchResultLabel.alpha = 0.0;
                                              }];
                         }];
    }
    else {
        // Something found - Open results view
        GMGamesTableViewController * controller = [[[GMGamesTableViewController alloc] 
                                                    initWithNibName:[GMNib getNibName:@"GMGamesTableViewController"] 
                                                    bundle:nil 
                                                    title:[NSString stringWithFormat:@"%@ (%d)", NSLocalizedString(@"Search results", nil), resultsCount]
                                                    model:nil
                                                    dsdl:dsdl
                                                    ] autorelease];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
