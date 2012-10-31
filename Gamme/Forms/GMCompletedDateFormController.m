//
//  GMCompletedDateFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/8/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMCompletedDateFormController.h"
#import "GMLog.h"
#import "GMNib.h"

@implementation GMCompletedDateFormController

@synthesize uiTitle = _uiTitle;
@synthesize initialValue = _initialValue;
@synthesize resultKey = _resultKey;
@synthesize navBarItem = _navBarItem;
@synthesize textView = _textView;
@synthesize datePicker = _datePicker;
@synthesize textLabel = _textLabel;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title andValue:(CompletedDate *)value andResultKey:(NSString *)resultKey
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
    
    // Initial values
    if (self.initialValue) {
        [self.textView setText:[self.initialValue note]];
        if ([self.initialValue completedDate]) {
            [self.datePicker setDate:[self.initialValue completedDate]];
        }
    }
    
    // Navigation
    [self.navBarItem setTitle:self.uiTitle];
    
    // Label
    [self.textLabel setText:NSLocalizedString(@"Tap here to hide the keyboard", nil)];
    UITapGestureRecognizer * tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideKeyboard:)] autorelease];
    [tapGesture setNumberOfTapsRequired:1];
    [self.textLabel addGestureRecognizer:tapGesture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.navBarItem = nil;
    self.textView = nil;
    self.datePicker = nil;
    self.textLabel = nil;
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

#pragma mark - UI actions

- (IBAction) cancelButtonPressed:(id)sender
{
    GMLog(@"GMCompletedDateFormController - cancelButtonPressed()");
    
    // go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) saveButtonPressed:(id)sender
{
    GMLog(@"GMCompletedDateFormController - saveButtonPressed()");
    
    // Update CompletedDate object with selected values
    [self.initialValue setCompletedDate:[self.datePicker date]];
    [self.initialValue setNote:[self.textView text]];
    
    // store selected value
    [self setOutgoingResultData:self.initialValue forKey:self.resultKey];
    
    // to know that this field was changed
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@_set", self.resultKey]];
    
    // go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) tapHideKeyboard:(id)sender
{
    [self.textView resignFirstResponder];
}

@end
