//
//  GMPlatformInfoViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMPlatformInfoViewController.h"
#import "GMAddPlatformFormController.h"
#import "GMLinksListTableViewController.h"

@implementation GMPlatformInfoViewController

- (id)initWithModel:(NSManagedObject *)model
{
    self = [super initWithNibName:[GMNib getNibName:@"GMInfoViewController"] bundle:nil andModel:model];
    if (self) {
    }
    
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Title
    self.navBarItem.title = [(Platform *) model_ title];
}


#pragma mark - Abstract implementation

// releaseDate
// site
// gameShopLinks

- (GMAbstractCommonFormTableViewController *) getEditFormController
{
    GMAddPlatformFormController * controller = [[[GMAddPlatformFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil andModel:(Platform *)model_] autorelease];
    return controller;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Release date
        if (row == 0) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"PlatformInfo_Cell_Date"
                                        title:NSLocalizedString(@"Release date", nil)
                                        value:[GMDate longDate:[(Platform *)model_ releaseDate]]
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:NO];
        }
        
        // Site
        else if (row == 1) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"PlatformInfo_Cell_Site"
                                        title:NSLocalizedString(@"Site", nil)
                                        value:[(Platform *)model_ site]
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:NO];
        }
    }
    
    //
    // Section 2
    
    // Links
    else if (section == 1) {
        
        // Links
        if (row == 0) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"PlatformInfo_Cell_Links"
                                        title:NSLocalizedString(@"Game shop links", nil)
                                        value:[NSString stringWithFormat:@"%d", [[(Platform *)model_ gameShopLinks] count]]
                               emptyValueText:@"0"
                                    clickable:YES];
        }
    }
    
    //
    // Section 3
    
    else if (section == 2) {
        
        // Notes
        if (row == 0) {
            return [self makeButtonCellForTableView:tableView
                                         identifier:@"PlatformInfo_Cell_Button"
                                              title:NSLocalizedString(@"Delete", nil)];
        }
    }
    
    
    // Unknow section
    [NSException raise:@"InvalidTableViewSection" format:@"Invalid table view section=%d, row=%d", section, row];
    return nil; // cannot reach here
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return 1;
        case 2:
            return 1;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to PlatformInfo table datasource, section=%d", section];
    return 0;   // never reach here
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[(Platform *)model_ isSystem] boolValue]) {
        return 2;
    }
    else {
        return 3;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Platform information", nil);
        case 1:
            return NSLocalizedString(@"Additional information", nil);
        case 2:
            return nil;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to PlatformInfo table datasource, section=%d", section];
    return nil;   // never reach here
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Release date
        if (row == 0) {
            return;
        }
        
        // Site
        else if (row == 1) {
            if ([(Platform *)model_ site]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(Platform *)model_ site]]];
            }
            return;
        }
    }
    
    
    //
    // Section 2
    
    else if (section == 1) {
        
        // Links
        if (row == 0) {
            GMLinksListTableViewController * controller = [[[GMLinksListTableViewController alloc] initWithTitle:NSLocalizedString(@"Game shop links", nil) andData:[(Platform *)model_ gameShopLinks]] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
    
    
    //
    // Section 3
    
    else if (section == 2) {
        
        // Delete button
        if (row == 0) {
            [self tryDeleteModel];
            return;
        }
    }
    
    
    // Unknow section
    [NSException raise:@"InvalidTableViewSection" format:@"Invalid table view section=%d, row=%d", section, row];
}


@end
