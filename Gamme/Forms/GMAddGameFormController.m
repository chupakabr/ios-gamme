//
//  GMAddGameFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/27/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAddGameFormController.h"
#import "GMAppDelegate.h"
#import "GMExtraInfoFormController.h"
#import "GMAbstractSimpleFormTableViewDSDL.h"
#import "GMAuthorSimpleFormTableViewDSDL.h"
#import "GMGenreSimpleFormTableViewDSDL.h"
#import "GMPlatformSimpleFormTableViewDSDL.h"
#import "GMTextInputForCell.h"
#import "GMLog.h"


#define GM_GAME_TABLEVIEW_TITLEINPUT_TAG 100


@implementation GMAddGameFormController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // UI stuff
    if (model_) {
        [self.navBarItem setTitle:NSLocalizedString(@"Edit Game", nil)];
    } else {
        [self.navBarItem setTitle:NSLocalizedString(@"Add Game", nil)];
    }
}


#pragma mark - UI actions

- (void) saveForm
{
    GMLog(@"GMAddGameFormController - saveForm()");
    
    //
    // Get selected values
    NSString * title = [self getTextFieldValue:GM_GAME_TABLEVIEW_TITLEINPUT_TAG tableView:self.tableView];
    Genre * genre = (Genre *) [self getSelectedValue:@"genre" selector:@selector(genre)];
    Platform * platform = (Platform *) [self getSelectedValue:@"platform" selector:@selector(platform)];
    Author * author = (Author *) [self getSelectedValue:@"author" selector:@selector(author)];
    NSDate * releaseDate = (NSDate *) [self getSelectedValue:@"date" selector:@selector(releaseDate)];
    
    NSString * notes = (NSString *) [self getSelectedValue:@"notes" selector:@selector(notes)];
    NSNumber * rating = (NSNumber *) [self getSelectedValue:@"rating" selector:@selector(rating)];
    NSSet * links = (NSSet *) [self getSelectedValue:@"links" selector:@selector(links)];
    NSDate * plannedDate = (NSDate *) [self getSelectedValue:@"plannedDate" selector:@selector(plannedTillDate)];
    NSSet * completedDates = (NSSet *) [self getSelectedValue:@"completedDates" selector:@selector(completedDates)];
    
    int gameState = GM_STATE_COMPLETED;
    if ([completedDates count] > 0) {
        gameState = GM_STATE_COMPLETED;
    }
    else if (plannedDate) {
        gameState = GM_STATE_PLANNED;
    }
    
    
    //
    // Default values
    
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    
    if (!genre) {
        genre = [ph defaultGenre];
    }
    
    if (!platform) {
        platform = [ph defaultPlatform];
    }
    
    if (!author) {
        author = [ph defaultAuthor];
    }
    
    
    //
    // Save
    
    if (model_) {
        
        // Update
        [(Game *)model_ setTitle:title];
        [(Game *)model_ setGenre:genre];
        [(Game *)model_ setPlatform:platform];
        [(Game *)model_ setAuthor:author];
        [(Game *)model_ setReleaseDate:releaseDate];
        [(Game *)model_ setState:[NSNumber numberWithInt:gameState]];
        [(Game *)model_ setAddedDate:[NSDate date]];
        [(Game *)model_ setRating:rating];
        [(Game *)model_ setNotes:notes];
        [(Game *)model_ setPlannedTillDate:plannedDate];
        [(Game *)model_ prepareAndUpdateLinks:links];
        [(Game *)model_ prepareAndUpdateCompletedDates:completedDates];
        
        GMLog(@"Saving (updt) Game: %@", model_);
        [ph save];
    }
    else {
        
        // Create
        Game * game = [ph newGame];
        [ph insertObject:game];
        
        [game setTitle:title];
        [game setGenre:genre];
        [game setPlatform:platform];
        [game setAuthor:author];
        [game setReleaseDate:releaseDate];
        [game setState:[NSNumber numberWithInt:gameState]];
        [game setAddedDate:[NSDate date]];
        [game setRating:rating];
        [game setNotes:notes];
        [game setPlannedTillDate:plannedDate];
        [game prepareAndUpdateLinks:links];
        [game prepareAndUpdateCompletedDates:completedDates];
        
        GMLog(@"Saving (new) Game: %@", game);
        [ph save];
    }
}

- (BOOL) validateForm
{
    NSString * title = [self getTextFieldValue:GM_GAME_TABLEVIEW_TITLEINPUT_TAG tableView:self.tableView];
    
    //
    // Check constraints
    
    if (!title || [title length] <= 0) {
        [self.statusLabel setText:NSLocalizedString(@"'Title' must be set", nil)];
        return NO;
    }
    
    if ([title length] > 200) {
        [self.statusLabel setText:NSLocalizedString(@"'Title' is too long", nil)];
        return NO;
    }
    
    
    // Get selected platform
    Platform * platform = (Platform *) [self getResultData:@"platform"];
    
    
    //
    // Check it's already exists
    
    if (!model_ || 
        (
         ![[(Game *) model_ title] isEqualToString:title]
         && [(Game *) model_ platform] == platform)
        )
    {
        GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
        NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[ph gameEntityDescription]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(title == %@) AND (platform == %@)", title, platform]];
        
        GMLog(@"Execute Validation Fetch for new Game: %@", [fetchRequest description]);
        
        NSArray * result = [[ph MOC] executeFetchRequest:fetchRequest error:nil];
        if ([result count] > 0) {
            [self.statusLabel setText:NSLocalizedString(@"Game with this title already exists for selected platform", nil)];
            return NO;
        }
    }
    
    // ret
    [self.statusLabel setText:@""];
    return YES;
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
                                            identifier:@"AddGameForm_Cell_Title" 
                                                 title:NSLocalizedString(@"Title", nil) 
                                           placeholder:NSLocalizedString(@"Game title", nil) 
                                          keyboardType:UIKeyboardTypeDefault
                                           keyboardCap:UITextAutocapitalizationTypeWords
                                                   tag:GM_GAME_TABLEVIEW_TITLEINPUT_TAG
                                    currentValueGetter:^{
                                        NSString * fieldValue = [self getTextFieldValue:GM_GAME_TABLEVIEW_TITLEINPUT_TAG tableView:self.tableView];
                                        if (fieldValue == nil && model_) {
                                            return [(Game *) model_ title];
                                        } else {
                                            return fieldValue;
                                        }
                                    }];
        }
        
        // Genre
        else if (row == 1) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddGameForm_Cell_Genre" 
                                              title:NSLocalizedString(@"Genre", nil)
                                 currentValueGetter:^{
                                     Genre * genre = (Genre *)[self getSelectedValue:@"genre" selector:@selector(genre)];
                                     if (genre) {
                                         return [genre title];
                                     } else {
                                         return NSLocalizedString(@"None", nil);
                                     }
                                 }];
        }
        
        // Platform
        else if (row == 2) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddGameForm_Cell_Platform" 
                                              title:NSLocalizedString(@"Platform", nil)
                                 currentValueGetter:^{
                                     Platform * platform = (Platform *)[self getSelectedValue:@"platform" selector:@selector(platform)];
                                     if (platform) {
                                         return [platform title];
                                     } else {
                                         return NSLocalizedString(@"None", nil);
                                     }
                                 }];
        }
        
        // Extras
        else if (row == 3) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddGameForm_Cell_Extras" 
                                              title:NSLocalizedString(@"Additional info", nil)
                                 currentValueGetter:^{
                                     return @"";
                                 }];
        }
        
        // Unknown row
        else {
            [NSException raise:@"InvalidTableViewRow" format:@"Invalid table view section=%d, row=%d", section, row];
        }
    }
    
    //
    // Section 2
    else if (section == 1) {
        
        // Publisher
        if (row == 0) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddGameForm_Cell_Author" 
                                              title:NSLocalizedString(@"Developer", nil)
                                 currentValueGetter:^{
                                     Author * author = (Author *)[self getSelectedValue:@"author" selector:@selector(author)];
                                     if (author) {
                                         return [author title];
                                     } else {
                                         return NSLocalizedString(@"None", nil);
                                     }
                                 }];
        }
        
        // Publish date
        else if (row == 1) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"AddGameForm_Cell_Date" 
                                              title:NSLocalizedString(@"Release date", nil)
                                 currentValueGetter:^{
                                     NSDate * date = (NSDate *)[self getSelectedValue:@"date" selector:@selector(releaseDate)];
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
            return 4;
        case 1:
            return 2;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to GMAddGameForm table datasource, section=%d", section];
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
            return NSLocalizedString(@"Game details", nil);
        case 1:
            return NSLocalizedString(@"Publishing details", nil);
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to GMAddGameForm table datasource, section=%d", section];
    return nil;   // never reach here
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Game title
        if (row == 0) {
            // do nothing
            return;
        }
        
        // Genre
        else if (row == 1) {
            [self showListPickerFormWithTitle:NSLocalizedString(@"Choose genre", nil) andDSDL:[[[GMGenreSimpleFormTableViewDSDL alloc] initWithResultKey:@"genre"] autorelease] andControllerClass:nil];
            return;
        }
        
        // Platform
        else if (row == 2) {
            GMPlatformSimpleFormTableViewDSDL * dsdl = [[[GMPlatformSimpleFormTableViewDSDL alloc] initWithResultKey:@"platform"] autorelease];
//            [dsdl setCanCreate:NO];
//            [dsdl setCanDelete:NO];
            
            [self showListPickerFormWithTitle:NSLocalizedString(@"Choose platform", nil) andDSDL:dsdl andControllerClass:nil];
            
            return;
        }
        
        // Additional information
        else if (row == 3) {
            GMExtraInfoFormController * controller = [[[GMExtraInfoFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil andModel:model_ andParentController:self] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        // Unknown row
        else {
            [NSException raise:@"InvalidTableViewRow" format:@"Invalid table view section=%d, row=%d", section, row];
        }
    }
    
    //
    // Section 2
    else if (section == 1) {
        
        // Publisher
        if (row == 0) {
            [self showListPickerFormWithTitle:NSLocalizedString(@"Choose developer", nil) andDSDL:[[[GMAuthorSimpleFormTableViewDSDL alloc] initWithResultKey:@"author"] autorelease] andControllerClass:nil];
            return;
        }
        
        // Publish date
        else if (row == 1) {
            [self showDatepickerFormWithTitle:NSLocalizedString(@"Release date", nil) andValue:(NSDate *)[self getSelectedValue:@"date" selector:@selector(releaseDate)] andResultKey:@"date"];
            return;
        }
        
        // Unknown row
        else {
            [NSException raise:@"InvalidTableViewRow" format:@"Invalid table view section=%d, row=%d", section, row];
        }
    }
    
    // Unknow section
    [NSException raise:@"InvalidTableViewSection" format:@"Invalid table view section=%d, row=%d", section, row];
}


@end
