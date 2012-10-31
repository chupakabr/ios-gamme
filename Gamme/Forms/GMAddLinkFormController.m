//
//  GMAddLinkFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/3/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAddLinkFormController.h"
#import "GMLog.h"

#define GM_LINKS_TABLEVIEW_TITLE_TAG 100
#define GM_LINKS_TABLEVIEW_SITE_TAG 101

@implementation GMAddLinkFormController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI stuff
    [self.navBarItem setTitle:NSLocalizedString(@"Link", nil)];
    
    // Add prefix to URL
    GMTextInputForCell * txtInput = (GMTextInputForCell *) [self getFormControl:GM_LINKS_TABLEVIEW_SITE_TAG tableView:self.tableView];
    if (![txtInput text] || [[txtInput text] length] <= 0) {
        [txtInput setText:@"http://"];
    }
}


#pragma mark - UI actions

- (IBAction) cancelButtonPressed:(id)sender
{
    // I like super calls!
    [super cancelButtonPressed:sender];
}

- (BOOL) validateForm
{
    NSString * title = [self getTextFieldValue:GM_LINKS_TABLEVIEW_TITLE_TAG tableView:self.tableView];
    NSString * site = [self getTextFieldValue:GM_LINKS_TABLEVIEW_SITE_TAG tableView:self.tableView];
    
    //
    // Check constraints
    
    if ([title length] <= 0) {
        [self.statusLabel setText:NSLocalizedString(@"'Title' must be set", nil)];
        return NO;
    }
    
    if ([title length] > 100) {
        [self.statusLabel setText:NSLocalizedString(@"'Title' is too long", nil)];
        return NO;
    }
    
    if ([site length] <= 0) {
        [self.statusLabel setText:NSLocalizedString(@"'URL' must be set", nil)];
        return NO;
    }
    
    if ([site length] > 1000) {
        [self.statusLabel setText:NSLocalizedString(@"'URL' is too long", nil)];
        return NO;
    }
    
    NSURL * url = [NSURL URLWithString:site];
    if (!url || !url.scheme || !url.host) {
        [self.statusLabel setText:NSLocalizedString(@"Invalid 'URL' format", nil)];
        return NO;
    }
    
    // ret
    return YES;
}

- (void) saveForm
{
    NSString * title = [self getTextFieldValue:GM_LINKS_TABLEVIEW_TITLE_TAG tableView:self.tableView];
    NSString * site = [self getTextFieldValue:GM_LINKS_TABLEVIEW_SITE_TAG tableView:self.tableView];
    
    [(Link *) model_ setTitle:title];
    [(Link *) model_ setUrl:site];
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Link title
        if (row == 0) {
            return [self makeTextInputCellForTableView:self.tableView 
                                            identifier:@"AddLinkForm_Cell_Title" 
                                                 title:NSLocalizedString(@"Name", nil) 
                                           placeholder:NSLocalizedString(@"Link name", nil) 
                                          keyboardType:UIKeyboardTypeDefault
                                           keyboardCap:UITextAutocapitalizationTypeWords
                                                   tag:GM_LINKS_TABLEVIEW_TITLE_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_LINKS_TABLEVIEW_TITLE_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Link *) model_ title];
                                        } else {
                                            return fieldValue;
                                        }
                                    }];
        }
        
        // Site
        else if (row == 1) {
            return [self makeTextInputCellForTableView:self.tableView 
                                            identifier:@"AddLinkForm_Cell_Site" 
                                                 title:NSLocalizedString(@"URL", nil) 
                                           placeholder:NSLocalizedString(@"URL", nil)
                                          keyboardType:UIKeyboardTypeURL
                                           keyboardCap:UITextAutocapitalizationTypeNone
                                                   tag:GM_LINKS_TABLEVIEW_SITE_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_LINKS_TABLEVIEW_SITE_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Link *) model_ url];
                                        } else {
                                            return fieldValue;
                                        }
                                    }];
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
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AddLink table datasource, section=%d", section];
    return 0;   // never reach here
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Link information", nil);
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AddLink table datasource, section=%d", section];
    return nil;   // never reach here
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMLog(@"AddLinkForm TableView selected");
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        if (row < 2) {
            return;
        }
    }    
    
    // Unknow section
    [NSException raise:@"InvalidTableViewSection" format:@"Invalid table view section=%d, row=%d", section, row];
}

@end
