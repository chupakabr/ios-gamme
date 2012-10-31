//
//  GMAddPlatformFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/3/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAddPlatformFormController.h"
#import "GMLinksSimpleFormTableViewDSDL.h"
#import "GMBackButtonListFormTableViewController.h"
#import "GMAppDelegate.h"
#import "GMLog.h"

#define GM_PLATFORM_TABLEVIEW_TITLE_TAG 100
#define GM_PLATFORM_TABLEVIEW_SITE_TAG 101


@implementation GMAddPlatformFormController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI stuff
    if (model_) {
        [self.navBarItem setTitle:[(Platform *)model_ title]];
    } else {
        [self.navBarItem setTitle:NSLocalizedString(@"Add Platform", nil)];
    }
}


#pragma mark - UI actions

- (BOOL) validateForm
{
    NSString * title = [self getTextFieldValue:GM_PLATFORM_TABLEVIEW_TITLE_TAG tableView:self.tableView];
    NSString * site = [self getTextFieldValue:GM_PLATFORM_TABLEVIEW_SITE_TAG tableView:self.tableView];
    
    //
    // Check constraints
    
    if (self.canCreate) {
        if ([title length] <= 0) {
            [self.statusLabel setText:NSLocalizedString(@"'Title' must be set", nil)];
            return NO;
        }
        
        if ([title length] > 100) {
            [self.statusLabel setText:NSLocalizedString(@"'Title' is too long", nil)];
            return NO;
        }
    }
    
    if ([site length] > 1000) {
        [self.statusLabel setText:NSLocalizedString(@"'URL' is too long", nil)];
        return NO;
    }
    
    //
    // Check it's already exists
    
    if (!model_ || ![[(Platform *) model_ title] isEqualToString:title]) {
        GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
        NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[ph platformEntityDescription]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title = %@", title]];
        
        NSArray * result = [[ph MOC] executeFetchRequest:fetchRequest error:nil];
        if ([result count] > 0) {
            [self.statusLabel setText:NSLocalizedString(@"Platform with this title already exists", nil)];
            return NO;
        }
    }
    
    // ret
    return YES;
}

- (void) saveForm
{
    NSString * title = [self getTextFieldValue:GM_PLATFORM_TABLEVIEW_TITLE_TAG tableView:self.tableView];
    NSString * site = [self getTextFieldValue:GM_PLATFORM_TABLEVIEW_SITE_TAG tableView:self.tableView];
    NSDate * releaseDate = (NSDate *) [self getSelectedValue:@"releaseDate" selector:@selector(releaseDate)];
    NSSet * links = (NSSet *) [self getSelectedValue:@"links" selector:@selector(gameShopLinks)];
    
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    
    if (model_) {
        
        // Update
        [(Platform *)model_ prepareAndUpdateGameShopLinks:links];
        [(Platform *)model_ setSite:site];
        [(Platform *)model_ setReleaseDate:releaseDate];
        
        if (self.canCreate) {
            [(Platform *)model_ setTitle:title];
        }
        
        [ph save];
    }
    else {
        
        // Create
        Platform * platform = [ph newPlatform];
        [ph insertObject:platform];
        
        [platform prepareAndUpdateGameShopLinks:links];
        [platform setTitle:title];
        [platform setSite:site];
        [platform setReleaseDate:releaseDate];
        
        [ph save];
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
        
        if (!self.canCreate) {
            row++;
        }
        
        // Game title
        if (row == 0) {
            return [self makeTextInputCellForTableView:self.tableView 
                                            identifier:@"AddPlatformForm_Cell_Title" 
                                                 title:NSLocalizedString(@"Title", nil) 
                                           placeholder:NSLocalizedString(@"Platform name", nil) 
                                          keyboardType:UIKeyboardTypeDefault
                                           keyboardCap:UITextAutocapitalizationTypeWords
                                                   tag:GM_PLATFORM_TABLEVIEW_TITLE_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_PLATFORM_TABLEVIEW_TITLE_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Platform *) model_ title];
                                        } else {
                                            return fieldValue;
                                        }
                                    }];
        }
        
        // Site
        else if (row == 1) {
            return [self makeTextInputCellForTableView:self.tableView 
                                            identifier:@"AddPlatformForm_Cell_Site" 
                                                 title:NSLocalizedString(@"URL", nil) 
                                           placeholder:NSLocalizedString(@"Official site", nil)
                                          keyboardType:UIKeyboardTypeURL
                                           keyboardCap:UITextAutocapitalizationTypeNone
                                                   tag:GM_PLATFORM_TABLEVIEW_SITE_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_PLATFORM_TABLEVIEW_SITE_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Platform *) model_ site];
                                        } else {
                                            return fieldValue;
                                        }
                                    }];
        }
        
        // Release date
        else if (row == 2) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddPlatformForm_Cell_Date" 
                                              title:NSLocalizedString(@"Release date", nil)
                                 currentValueGetter:^{
                                     NSDate * date = (NSDate *)[self getSelectedValue:@"releaseDate" selector:@selector(releaseDate)];
                                     if (date) {
                                         return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
                                     } else {
                                         return NSLocalizedString(@"None", nil);
                                     }
                                 }];
        }
    }
    
    //
    // Section 2
    
    // Links
    else if (section == 1) {
        
        // Links
        if (row == 0) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddPlatformForm_Cell_Links" 
                                              title:NSLocalizedString(@"Game shop links", nil)
                                 currentValueGetter:^{
                                     int count = 0;
                                     NSSet * links = (NSSet *)[self getSelectedValue:@"links" selector:@selector(gameShopLinks)];
                                     
                                     if (links) {
                                         count = [links count];
                                     }
                                     
                                     return [NSString stringWithFormat:@"%d", count];
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
            return (self.canCreate ? 3 : 2);
        case 1:
            return 1;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AddPlatform table datasource, section=%d", section];
    return 0;   // never reach here
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Platform information", nil);
        case 1:
            return NSLocalizedString(@"Additional information", nil);
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to AddPlatform table datasource, section=%d", section];
    return nil;   // never reach here
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMLog(@"AddPlatformForm TableView selected");
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        if (!self.canCreate) {
            row++;
        }
        
        if (row < 2) {
            return;
        }
        
        // Release date
        else if (row == 2) {
            [self showDatepickerFormWithTitle:NSLocalizedString(@"Release date", nil) andValue:(NSDate *)[self getSelectedValue:@"releaseDate" selector:@selector(releaseDate)] andResultKey:@"releaseDate"];
            return;
        }
    }
    
    //
    // Section 2
    
    if (section == 1) {
        
        // Links
        if (row == 0) {
            [self showListPickerFormWithTitle:NSLocalizedString(@"Game shop links", nil)
                                      andDSDL:[[[GMLinksSimpleFormTableViewDSDL alloc] initWithResultKey:@"links" andData:(NSSet *)[self getSelectedValue:@"links" selector:@selector(gameShopLinks)]] autorelease]
                           andControllerClass:[GMBackButtonListFormTableViewController class]];
            return;
        }
    }
    
    
    // Unknow section
    [NSException raise:@"InvalidTableViewSection" format:@"Invalid table view section=%d, row=%d", section, row];
}

@end
