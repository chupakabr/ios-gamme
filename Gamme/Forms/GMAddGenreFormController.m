//
//  GMAddGenreFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/1/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAddGenreFormController.h"
#import "GMAppDelegate.h"
#import "GMLog.h"

#define GM_GENRE_TABLEVIEW_TITLE_TAG 100


@implementation GMAddGenreFormController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI stuff
    if (model_) {
        [self.navBarItem setTitle:NSLocalizedString(@"Edit Genre", nil)];
    } else {
        [self.navBarItem setTitle:NSLocalizedString(@"Add Genre", nil)];
    }
}


#pragma mark - UI actions

- (BOOL) validateForm
{
    NSString * title = [self getTextFieldValue:GM_GENRE_TABLEVIEW_TITLE_TAG tableView:self.tableView];
    
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
    
    //
    // Check it's already exists
    
    if (!model_ || ![[(Genre *) model_ title] isEqualToString:title]) {
        GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
        NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[ph genreEntityDescription]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title = %@", title]];
        
        NSArray * result = [[ph MOC] executeFetchRequest:fetchRequest error:nil];
        if ([result count] > 0) {
            [self.statusLabel setText:NSLocalizedString(@"Genre with this title already exists", nil)];
            return NO;
        }
    }
    
    // ret
    return YES;
}

- (void) saveForm
{
    NSString * title = [self getTextFieldValue:GM_GENRE_TABLEVIEW_TITLE_TAG tableView:self.tableView];
    
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    
    if (model_) {
        // Update
        [(Genre *)model_ setTitle:title];
        [ph save];
    }
    else {
        // Create
        Genre * genre = [ph newGenre];
        [genre setTitle:title];
        [ph insertObjectNow:genre];
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
                                            identifier:@"AddGenreForm_Cell_Title" 
                                                 title:NSLocalizedString(@"Title", nil) 
                                           placeholder:NSLocalizedString(@"Company name", nil) 
                                          keyboardType:UIKeyboardTypeDefault
                                           keyboardCap:UITextAutocapitalizationTypeWords
                                                   tag:GM_GENRE_TABLEVIEW_TITLE_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_GENRE_TABLEVIEW_TITLE_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Genre *) model_ title];
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
            return 1;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AddGenre table datasource, section=%d", section];
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
            return NSLocalizedString(@"Genre information", nil);
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AddGenre table datasource, section=%d", section];
    return nil;   // never reach here
}


@end
