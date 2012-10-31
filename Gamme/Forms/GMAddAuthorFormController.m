//
//  GMAddAuthorFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAddAuthorFormController.h"
#import "GMAppDelegate.h"
#import "GMLog.h"

#define GM_AUTHOR_TABLEVIEW_TITLE_TAG 100
#define GM_AUTHOR_TABLEVIEW_COUNTRY_TAG 101
#define GM_AUTHOR_TABLEVIEW_SITE_TAG 102


@implementation GMAddAuthorFormController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI stuff
    if (model_) {
        [self.navBarItem setTitle:NSLocalizedString(@"Edit Developer", nil)];
    } else {
        [self.navBarItem setTitle:NSLocalizedString(@"Add Developer", nil)];
    }
}


#pragma mark - UI actions

- (BOOL) validateForm
{
    NSString * title = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_TITLE_TAG tableView:self.tableView];
    NSString * country = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_COUNTRY_TAG tableView:self.tableView];
    NSString * site = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_SITE_TAG tableView:self.tableView];
    
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
    
    if ([country length] > 100) {
        [self.statusLabel setText:NSLocalizedString(@"'Country' is too long", nil)];
        return NO;
    }
    
    if ([site length] > 1000) {
        [self.statusLabel setText:NSLocalizedString(@"'URL' is too long", nil)];
        return NO;
    }
    
    //
    // Check it's already exists
    
    if (!model_ || ![[(Author *) model_ title] isEqualToString:title]) {
        GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
        NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[ph authorEntityDescription]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title = %@", title]];
        
        NSArray * result = [[ph MOC] executeFetchRequest:fetchRequest error:nil];
        if ([result count] > 0) {
            [self.statusLabel setText:NSLocalizedString(@"Developer with this title already exists", nil)];
            return NO;
        }
    }
    
    // ret
    return YES;
}

- (void) saveForm
{
    NSString * title = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_TITLE_TAG tableView:self.tableView];
    NSString * country = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_COUNTRY_TAG tableView:self.tableView];
    NSString * site = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_SITE_TAG tableView:self.tableView];
    NSDate * foundationDate = (NSDate *) [self getSelectedValue:@"foundationDate" selector:@selector(foundationDate)];
    NSDate * closedDate = (NSDate *) [self getSelectedValue:@"closedDate" selector:@selector(closeDate)];
    
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    
    if (model_) {
        // Update
        [(Author *)model_ setTitle:title];
        [(Author *)model_ setCountry:country];
        [(Author *)model_ setSite:site];
        [(Author *)model_ setFoundationDate:foundationDate];
        [(Author *)model_ setCloseDate:closedDate];
        [ph save];
    }
    else {
        // Create
        Author * author = [ph newAuthor];
        [author setTitle:title];
        [author setCountry:country];
        [author setSite:site];
        [author setFoundationDate:foundationDate];
        [author setCloseDate:closedDate];
        [ph insertObjectNow:author];
    }
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Game title
        if (row == 0) {
            return [self makeTextInputCellForTableView:self.tableView 
                                            identifier:@"AddAuthorForm_Cell_Title" 
                                                 title:NSLocalizedString(@"Title", nil) 
                                           placeholder:NSLocalizedString(@"Company name", nil) 
                                          keyboardType:UIKeyboardTypeDefault
                                           keyboardCap:UITextAutocapitalizationTypeWords
                                                   tag:GM_AUTHOR_TABLEVIEW_TITLE_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_TITLE_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Author *) model_ title];
                                        } else {
                                            return fieldValue;
                                        }
                                    }];
        }
        
        // Country
        else if (row == 1) {
            return [self makeTextInputCellForTableView:self.tableView 
                                            identifier:@"AddAuthorForm_Cell_Country" 
                                                 title:NSLocalizedString(@"Country", nil) 
                                           placeholder:NSLocalizedString(@"Headquarter's country", nil) 
                                          keyboardType:UIKeyboardTypeDefault
                                           keyboardCap:UITextAutocapitalizationTypeWords
                                                   tag:GM_AUTHOR_TABLEVIEW_COUNTRY_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_COUNTRY_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Author *) model_ country];
                                        } else {
                                            return fieldValue;
                                        }
                                    }];
        }
        
        // Site
        else if (row == 2) {
            return [self makeTextInputCellForTableView:self.tableView 
                                            identifier:@"AddAuthorForm_Cell_Site" 
                                                 title:NSLocalizedString(@"URL", nil) 
                                           placeholder:NSLocalizedString(@"Company site", nil)
                                          keyboardType:UIKeyboardTypeURL
                                           keyboardCap:UITextAutocapitalizationTypeNone
                                                   tag:GM_AUTHOR_TABLEVIEW_SITE_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_AUTHOR_TABLEVIEW_SITE_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Author *) model_ site];
                                        } else {
                                            return fieldValue;
                                        }
                                    }];
        }
        
        // Foundation date
        else if (row == 3) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddAuthorForm_Cell_Date" 
                                              title:NSLocalizedString(@"Foundation date", nil)
                                 currentValueGetter:^{
                                     NSDate * date = (NSDate *)[self getSelectedValue:@"foundationDate" selector:@selector(foundationDate)];
                                     if (date) {
                                         return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
                                     } else {
                                         return NSLocalizedString(@"None", nil);
                                     }
                                 }];
        }
        
        // Closed date
        else if (row == 4) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddAuthorForm_Cell_Date" 
                                              title:NSLocalizedString(@"Closing date", nil)
                                 currentValueGetter:^{
                                     NSDate * date = (NSDate *)[self getSelectedValue:@"closedDate" selector:@selector(closeDate)];
                                     if (date) {
                                         return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
                                     } else {
                                         return NSLocalizedString(@"None", nil);
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
            return 5;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AddAuthor table datasource, section=%d", section];
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
            return NSLocalizedString(@"Developer information", nil);
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AddAuthor table datasource, section=%d", section];
    return nil;   // never reach here
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMLog(@"AddAuthorForm TableView selected");
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        if (row < 3) {
            return;
        }
        
        // Foundation date
        else if (row == 3) {
            [self showDatepickerFormWithTitle:NSLocalizedString(@"Foundation date", nil) andValue:(NSDate *)[self getSelectedValue:@"foundationDate" selector:@selector(foundationDate)] andResultKey:@"foundationDate"];
            return;
        }
        
        // Closed date
        else if (row == 4) {
            [self showDatepickerFormWithTitle:NSLocalizedString(@"Closing date", nil) andValue:(NSDate *)[self getSelectedValue:@"closedDate" selector:@selector(closeDate)] andResultKey:@"closedDate"];
            return;
        }
    }
    
    // Unknow section
    [NSException raise:@"InvalidTableViewSection" format:@"Invalid table view section=%d, row=%d", section, row];
}

@end
