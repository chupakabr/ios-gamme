//
//  GMAbstractCommonFormTableViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractCommonFormTableViewController.h"
#import "GMAppDelegate.h"
#import "GMLog.h"


@implementation GMAbstractCommonFormTableViewController

@synthesize statusLabel = _statusLabel;
@synthesize navBarItem = _navBarItem;
@synthesize tableView = _tableView;
@synthesize canDelete = _canDelete;
@synthesize canCreate = _canCreate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.canCreate = YES;
        self.canDelete = YES;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andModel:(NSManagedObject *)model
{
    self = [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        model_ = [model retain];
    }
    
    return self;
}

- (void) dealloc
{
    [model_ release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - UI helpers

- (NSObject *) getSelectedValue:(NSString *)resultKey selector:(SEL)modelValueGetterSelector
{
    NSObject * res = (NSObject *) [self getResultData:resultKey];
    
    NSNumber * isSet = (NSNumber *) [self getResultData:[NSString stringWithFormat:@"%@_set", resultKey]];
    if (model_ && (isSet == nil || [isSet boolValue] == NO)) {
        res = [model_ performSelector:modelValueGetterSelector];
    }
    
    return res;
}

- (UITableViewCell *) makeTextInputCellForTableView:(UITableView *)tableView identifier:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType keyboardCap:(UITextAutocapitalizationType)keyboardCap tag:(NSInteger)tag currentValueGetter:(GMValueGetterType)currentValueGetter
{
    GMTextInputForCell * txtField;
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:GM_TABLEVIEW_STYLE reuseIdentifier:identifier] autorelease];
        
        [cell.textLabel setText:title];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
        txtField = [[[GMTextInputForCell alloc] initWithFrame:CGRectMake(110, 11, cell.frame.size.width - 130, cell.frame.size.height-20)] autorelease];
        [txtField setPlaceholder:placeholder];
        [txtField setTag:tag];
        [txtField setText:currentValueGetter()];
        [txtField setKeyboardType:keyboardType];
        [txtField setAutocapitalizationType:keyboardCap];
        
        [cell addSubview:txtField];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return cell;
}

- (UITableViewCell *) makeCommonCellForTableView:(UITableView *)tableView identifier:(NSString *)identifier title:(NSString *)title currentValueGetter:(GMValueGetterType)currentValueGetter
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:GM_TABLEVIEW_STYLE reuseIdentifier:identifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setText:title];
    }
    
    [cell.detailTextLabel setText:currentValueGetter()];
    
    return cell;    
}

- (void) showListPickerFormWithTitle:(NSString *)title andDSDL:(GMAbstractSimpleFormTableViewDSDL *)dsdl andControllerClass:(Class)controllerClassOrNil
{
    // Controller
    if (controllerClassOrNil == nil) {
        controllerClassOrNil = [GMSimpleListFormTableViewController class];
    }
    
    GMSimpleListFormTableViewController * controller = [[[controllerClassOrNil alloc] initWithNibName:[GMNib getNibName:@"GMSimpleListFormTableViewController"] bundle:nil title:title datasource:dsdl delegate:dsdl] autorelease];
    
    // Don't forget to tell DS and DL which controller is its parent
    [dsdl setParentController:controller];
    
    // Show view
    [self.navigationController pushViewController:controller animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self tableView:self.tableView heightForHeaderInSection:section];
    
    UIView * headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, height)] autorelease];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel * headerLabel;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.bounds.size.width-15, height)] autorelease];
    }
    else {
        headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 0, tableView.bounds.size.width-40, height)] autorelease];
    }
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.text = [self tableView:self.tableView titleForHeaderInSection:section];
    
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}


#pragma mark - Abstract

- (BOOL) validateForm
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract validateForm() must be implemented in the child"];
    return NO;
}

- (void) saveForm
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract saveForm() must be implemented in the child"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract cellForRowAtIndexPath() must be implemented in the child"];
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract numberOfRowsInSection() must be implemented in the child"];
    return 0;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Set BG
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[GMNib getBgImageName]]];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[[UIView alloc] init] autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.statusLabel.backgroundColor = [UIColor clearColor];
    self.statusLabel.textColor = [UIColor colorWithRed:1.0 green:(CGFloat)63/255 blue:(CGFloat)63/255 alpha:1.0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Unset BG
    self.view.backgroundColor = nil;
    
    // Release views
    self.statusLabel = nil;
    self.tableView = nil;
    self.navBarItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload table view data to apply latest Datasource changes
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UI actions

- (IBAction) cancelButtonPressed:(id)sender
{
    GMLog(@"GMAbstractCommonFormTableViewController - cancelButtonPressed()");
    
    // Go to prev view
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) saveButtonPressed:(id)sender
{
    GMLog(@"GMAbstractCommonFormTableViewController - saveButtonPressed()");
    
    if ([self validateForm]) {
        
        // Save form
        [self saveForm];
        
        // Go to prev view
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
