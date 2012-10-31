//
//  GMDateFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMDateFormController.h"
#import "GMLog.h"
#import "GMNib.h"

@implementation GMDateFormController

@synthesize datePicker = _datePicker;
@synthesize uiTitle = _uiTitle;
@synthesize initialValue = _initialValue;
@synthesize resultKey = _resultKey;
@synthesize navBarItem = _navBarItem;
@synthesize onOffButton = _onOffButton;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title andValue:(NSDate *)value andResultKey:(NSString *)resultKey
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
        [self.datePicker setDate:self.initialValue];
    }
    
    [self.navBarItem setTitle:self.uiTitle];
    [self.onOffButton setTitle:NSLocalizedString(@"Date", nil) forSegmentAtIndex:0];
    [self.onOffButton setTitle:NSLocalizedString(@"None", nil) forSegmentAtIndex:1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.navBarItem = nil;
    self.datePicker = nil;
    self.onOffButton = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI actions

- (IBAction) cancelButtonPressed:(id)sender
{
    GMLog(@"GMDateFormController - cancelButtonPressed()");
    
    // go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) saveButtonPressed:(id)sender
{
    GMLog(@"GMDateFormController - saveButtonPressed()");
    
    // store selected value
    NSDate * date = nil;
    if ([self.onOffButton selectedSegmentIndex] == 0) {
        date = [self.datePicker date];
    }
    
    // the value
    [self setOutgoingResultData:date forKey:self.resultKey];
    
    // to know that this field was changed
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@_set", self.resultKey]];
    
    // go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) onOffButtonPressed:(id)sender
{
    GMLog(@"GMDateFormController - onOffButtonPressed(%d)", [self.onOffButton selectedSegmentIndex]);
    
    // Enable/Disable datepicker depending on OnOff control selection
    if ([self.onOffButton selectedSegmentIndex] == 0) {
        [self.datePicker setEnabled:YES];
    } else {
        [self.datePicker setEnabled:NO];
    }
}

@end
