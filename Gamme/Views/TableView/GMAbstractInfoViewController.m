//
//  GMAbstractInfoViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractInfoViewController.h"
#import "GMAppDelegate.h"

@implementation GMAbstractInfoViewController

@synthesize navBarItem = _navBarItem;
@synthesize tableView = _tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andModel:(NSManagedObject *)model
{
    if (!model) {
        [NSException raise:NSInternalInconsistencyException format:@"model must be set"];
        return nil;
    }
    
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


#pragma mark - UI Actions

- (IBAction) backButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) editButtonPressed:(id)sender
{
    GMAbstractCommonFormTableViewController * controller = [self getEditFormController];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - Table View

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
        headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(45, 0, tableView.bounds.size.width-45, height)] autorelease];
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


#pragma mark - Abstract UITableView

- (GMAbstractCommonFormTableViewController *) getEditFormController
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract getEditFormController() must be implemented in the child"];
    return nil;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract numberOfSections() must be implemented in the child"];
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract titleForHeaderInSection() must be implemented in the child"];
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract titleForHeaderInSection() must be implemented in the child"];
}

- (void) deleteButtonPressed:(id)sender
{
    [NSException raise:NSInternalInconsistencyException format:@"Abstract deleteButtonPressed() must be implemented in the child"];
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
    
    // Nav bar back button title
    UIBarButtonItem * btn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(backButtonPressed:)] autorelease];
    [self.navBarItem setLeftBarButtonItem:btn];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Unset BG
    self.view.backgroundColor = nil;
    
    // Release views
    self.tableView = nil;
    self.navBarItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Reload table view data to apply latest Datasource changes
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - UI helpers

- (UITableViewCell *) makeCellForTableView:(UITableView *)tableView identifier:(NSString *)identifier title:(NSString *)title value:(NSString *)value emptyValueText:(NSString *)emptyValueText clickable:(BOOL)clickable
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:GM_TABLEVIEW_STYLE reuseIdentifier:identifier] autorelease];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setText:title];
        
        if (clickable) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    // Value
    if (value == nil || ([value isKindOfClass:[NSString class]] && [value performSelector:@selector(length)] <= 0)) {
        value = emptyValueText;
    }
    [cell.detailTextLabel setText:value];
    
    return cell;    
}

- (UITableViewCell *) makeButtonCellForTableView:(UITableView *)tableView identifier:(NSString *)identifier title:(NSString *)title
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setText:title];
    }
    
    return cell;    
}


#pragma mark - Delete button helpers

- (void) tryDeleteModel
{
    NSString * title;
    NSString * message = NSLocalizedString(@"Are you sure?", nil);
    
    if ([model_ isKindOfClass:[Game class]]) {
        title = NSLocalizedString(@"Delete Game", nil);
    }
    else if ([model_ isKindOfClass:[Platform class]]) {
        title = NSLocalizedString(@"Delete Platform", nil);
    }
    else if ([model_ isKindOfClass:[Author class]]) {
        title = NSLocalizedString(@"Delete Author", nil);
    }
    else {
        [NSException raise:NSInternalInconsistencyException format:@"Trying to delete unknown model: %@", model_];
    }
    
    
    UIAlertView * alertView = [[[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Delete", nil), nil] autorelease];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    switch (buttonIndex) {
        case 1:
            // OK - Delete
            if ([model_ isKindOfClass:[Game class]]) {
            }
            else if ([model_ isKindOfClass:[Platform class]]) {
            }
            else if ([model_ isKindOfClass:[Author class]]) {
            }
            else {
                [NSException raise:NSInternalInconsistencyException format:@"Trying to DELETE unknown model: %@", model_];
            }
            
            GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
            [ph deleteObjectNow:model_];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            break;
            
        default:
            // Cancel
            break;
    }
}


@end
