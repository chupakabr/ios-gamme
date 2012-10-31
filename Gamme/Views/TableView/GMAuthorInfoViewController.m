//
//  GMAuthorInfoViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAuthorInfoViewController.h"
#import "GMAddAuthorFormController.h"

@implementation GMAuthorInfoViewController

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
    self.navBarItem.title = [(Author *) model_ title];
}


#pragma mark - Abstract implementation

// country
// foundationDate
// closeDate
// site

- (GMAbstractCommonFormTableViewController *) getEditFormController
{
    GMAddAuthorFormController * controller = [[[GMAddAuthorFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil andModel:(Platform *)model_] autorelease];
    return controller;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Country
        if (row == 0) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"AuthorInfo_Cell_Country"
                                        title:NSLocalizedString(@"Headquarters", nil)
                                        value:[(Author *)model_ country]
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:NO];
        }
        
        // Foundation date
        else if (row == 1) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"AuthorInfo_Cell_Date"
                                        title:NSLocalizedString(@"Founded", nil)
                                        value:[GMDate longDate:[(Author *)model_ foundationDate]]
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:NO];
        }
        
        // Close date
        NSUInteger siteRow = 2;
        if ([(Author *)model_ closeDate]) {
            
            siteRow = 3;
            
            if (row == 2) {
                return [self makeCellForTableView:tableView 
                                       identifier:@"AuthorInfo_Cell_Date"
                                            title:NSLocalizedString(@"Defunct", nil)
                                            value:[GMDate longDate:[(Author *)model_ closeDate]]
                                   emptyValueText:NSLocalizedString(@"Unknown", nil)
                                        clickable:NO];
            }
        }
        
        // Site
        if (row == siteRow) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"AuthorInfo_Cell_Siteate"
                                        title:NSLocalizedString(@"Company site", nil)
                                        value:[(Author *)model_ site]
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:NO];
        }
    }
    
    //
    // Section 2
    
    else if (section == 1) {
        
        // Notes
        if (row == 0) {
            return [self makeButtonCellForTableView:tableView
                                         identifier:@"AuthorInfo_Cell_Button"
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
            if ([(Author *)model_ closeDate]) {
                return 4;
            }
            else {
                return 3;
            }
        case 1:
            return 1;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AuthorInfo table datasource, section=%d", section];
    return 0;   // never reach here
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([[(Author *)model_ isSystem] boolValue]) {
        NSLog(@"11111");
        return 1;
    }
    else {
        NSLog(@"22222");
        return 2;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Developer information", nil);
        case 1:
            return nil;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AuthorInfo table datasource, section=%d", section];
    return nil;   // never reach here
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        NSUInteger siteRow = 2;
        if ([(Author *)model_ closeDate]) {
            siteRow = 3;
        }
        
        if (row == siteRow) {
            if ([(Author *)model_ site]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(Author *)model_ site]]];
            }
        }
        
        return;
    }
    
    //
    // Section 2
    
    else if (section == 1) {
        
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
