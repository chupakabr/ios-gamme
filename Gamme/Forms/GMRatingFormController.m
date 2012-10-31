//
//  GMRatingFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/8/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMRatingFormController.h"
#import "GMLog.h"
#import "GMNib.h"

@implementation GMRatingFormController

@synthesize uiTitle = _uiTitle;
@synthesize initialValue = _initialValue;
@synthesize resultKey = _resultKey;
@synthesize navBarItem = _navBarItem;
@synthesize segmentedControl = _segmentedControl;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title andValue:(NSNumber *)value andResultKey:(NSString *)resultKey
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.uiTitle = title;
        self.resultKey = resultKey;
        self.initialValue = value;
    }
    
    return self;
}

- (void) dealloc
{
    self.uiTitle = nil;
    self.resultKey = nil;
    self.initialValue = nil;
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
    
    // Setup BG
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:[GMNib getBgImageName]]]];
    
    // Custom
    if (self.initialValue) {
        [self.segmentedControl setSelectedSegmentIndex:([(NSNumber *)self.initialValue intValue]-1)];
    }
    
    [self.navBarItem setTitle:self.uiTitle];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.navBarItem = nil;
    self.segmentedControl = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI actions

- (IBAction) cancelButtonPressed:(id)sender
{
    GMLog(@"GMRatingFormController - cancelButtonPressed()");
    
    // go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) saveButtonPressed:(id)sender
{
    GMLog(@"GMRatingFormController - saveButtonPressed()");
    
    // store selected value
    [self setOutgoingResultData:[NSNumber numberWithInt:([self.segmentedControl selectedSegmentIndex]+1)] forKey:self.resultKey];
    
    // to know that this field was changed
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@_set", self.resultKey]];
    
    // go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

@end
