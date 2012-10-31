//
//  GMDatesListTableViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/24/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMDatesListTableViewController.h"
#import "GMNotesViewController.h"
#import "GMDate.h"
#import "GMNib.h"

@implementation GMDatesListTableViewController

@synthesize navBarItem = _navBarItem;
@synthesize tableView = _tableView;

- (id) initWithTitle:(NSString *)title andData:(NSSet *)data
{
    self = [super initWithNibName:[GMNib getNibName:@"GMLinksListTableViewController"] bundle:nil];
    if (self) {
        title_ = [title retain];
        data_ = [[[data allObjects] sortedArrayUsingComparator:^(CompletedDate * obj1, CompletedDate * obj2) {
            return [obj1.completedDate compare:obj2.completedDate];
        }] retain];
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
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Title
    [self.navBarItem setTitle:title_];
    
    // Set BG
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[GMNib getBgImageName]]];
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [[[UIView alloc] init] autorelease];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor colorWithRed:(CGFloat)102/255 green:(CGFloat)102/255 blue:(CGFloat)102/255 alpha:1.0];
    
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
    self.tableView = nil;
    self.navBarItem = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Sync with DB
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table View datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Dates_List_Cell";
    
    UITableViewCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }        
    
    // Configure cell colors
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:(CGFloat)153/255 green:(CGFloat)204/255 blue:0.0 alpha:1.0]];
    
    // Configure the cell...
    NSString * title = [GMDate longDate:[(CompletedDate *) [data_ objectAtIndex:indexPath.row] completedDate]];
    NSString * details = [(CompletedDate *) [data_ objectAtIndex:indexPath.row] note];
    
    if (details && [details length] > 17) {
        details = [NSString stringWithFormat:@"%@...", [details substringToIndex:14]];
    }
    
    [cell.textLabel setText:title];
    [cell.detailTextLabel setText:details];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMNotesViewController * controller = [[[GMNotesViewController alloc] initWithTitle:NSLocalizedString(@"Completion notes", nil) andData:[(CompletedDate *)[data_ objectAtIndex:indexPath.row] note]] autorelease];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
