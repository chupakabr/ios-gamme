//
//  GMTextareaFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/7/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMTextareaFormController.h"
#import "GMLog.h"
#import "GMNib.h"

@implementation GMTextareaFormController

@synthesize uiTitle = _uiTitle;
@synthesize initialValue = _initialValue;
@synthesize resultKey = _resultKey;
@synthesize navBarItem = _navBarItem;
@synthesize textView = _textView;


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title andValue:(NSString *)value andResultKey:(NSString *)resultKey
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
        [self.textView setText:self.initialValue];
    }
    
    [self.navBarItem setTitle:self.uiTitle];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.navBarItem = nil;
    self.textView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UI actions

- (IBAction) cancelButtonPressed:(id)sender
{
    GMLog(@"GMTextareaFormController - cancelButtonPressed()");
    
    // go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) saveButtonPressed:(id)sender
{
    GMLog(@"GMTextareaFormController - saveButtonPressed()");
    
    // store selected value
    [self setOutgoingResultData:[self.textView text] forKey:self.resultKey];
    
    // to know that this field was changed
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@_set", self.resultKey]];
    
    // go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

@end
