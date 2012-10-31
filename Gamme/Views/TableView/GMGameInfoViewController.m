//
//  GMGameInfoViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMGameInfoViewController.h"
#import "GMAddGameFormController.h"
#import "GMLinksListTableViewController.h"
#import "GMPlatformInfoViewController.h"
#import "GMAuthorInfoViewController.h"
#import "GMNotesViewController.h"
#import "GMDatesListTableViewController.h"

@implementation GMGameInfoViewController

@synthesize scrollView = _scrollView;
@synthesize starsView = _starsView;
@synthesize star1Button = _star1Button;
@synthesize star2Button = _star2Button;
@synthesize star3Button = _star3Button;
@synthesize star4Button = _star4Button;
@synthesize star5Button = _star5Button;

- (id)initWithModel:(NSManagedObject *)model
{
    self = [super initWithNibName:[GMNib getNibName:@"GMGameInfoViewController"] bundle:nil andModel:model];
    if (self) {
    }
    
    return self;
}

- (void) dealloc
{
    if (starImage_) {
        [starImage_ release];
    }
    
    if (starInactiveImage_) {
        [starInactiveImage_ release];
    }
    
    [super dealloc];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Transparent BG
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.starsView.backgroundColor = [UIColor clearColor];
    
    // Images
    starImage_ = [UIImage imageNamed:@"star.png"];
    starInactiveImage_ = [UIImage imageNamed:@"star_inactive.png"];
}

- (void) viewDidUnload
{
    // Unload images
    [starImage_ release];
    [starInactiveImage_ release];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Title
    self.navBarItem.title = [(Game *) model_ title];
    
    // Stars
    switch ([[(Game *) model_ rating] intValue]) {
        case 1:
            [self starClicked:self.star1Button];
            break;
            
        case 2:
            [self starClicked:self.star2Button];
            break;
            
        case 3:
            [self starClicked:self.star3Button];
            break;
            
        case 4:
            [self starClicked:self.star4Button];
            break;
            
        case 5:
            [self starClicked:self.star5Button];
            break;
            
        default:
            [self starClicked:nil];
            break;
    }
}


#pragma mark - UI actions

- (IBAction) starClicked:(UIButton *)sender
{
    NSNumber * rating = nil;
    
    if (!sender) {
        // Null
        [self.star1Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star2Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star3Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star4Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star5Button setImage:starInactiveImage_ forState:UIControlStateNormal];
    }
    else if ([sender.titleLabel.text compare:@"1"] == NSOrderedSame) {
        rating = [NSNumber numberWithInt:1];
        [self.star1Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star2Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star3Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star4Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star5Button setImage:starInactiveImage_ forState:UIControlStateNormal];
    }
    else if ([sender.titleLabel.text compare:@"2"] == NSOrderedSame) {
        rating = [NSNumber numberWithInt:2];
        [self.star1Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star2Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star3Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star4Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star5Button setImage:starInactiveImage_ forState:UIControlStateNormal];
    }
    else if ([sender.titleLabel.text compare:@"3"] == NSOrderedSame) {
        rating = [NSNumber numberWithInt:3];
        [self.star1Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star2Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star3Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star4Button setImage:starInactiveImage_ forState:UIControlStateNormal];
        [self.star5Button setImage:starInactiveImage_ forState:UIControlStateNormal];
    }
    else if ([sender.titleLabel.text compare:@"4"] == NSOrderedSame) {
        rating = [NSNumber numberWithInt:4];
        [self.star1Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star2Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star3Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star4Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star5Button setImage:starInactiveImage_ forState:UIControlStateNormal];
    }
    else {
        // 5
        rating = [NSNumber numberWithInt:5];
        [self.star1Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star2Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star3Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star4Button setImage:starImage_ forState:UIControlStateNormal];
        [self.star5Button setImage:starImage_ forState:UIControlStateNormal];
    }
    
    [(Game *)model_ setRating:rating];
    [[[GMAppDelegate instance] persistenceHelper] save];
}


#pragma mark - Abstract implementation

// Header: rating

// Game information
// genre
// platform

// Publishing information
// author
// releaseDate

// Additional information
// notes
// links
// plannedDate
// completedDates

- (GMAbstractCommonFormTableViewController *) getEditFormController
{
    GMAddGameFormController * controller = [[[GMAddGameFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil andModel:(Game *)model_] autorelease];
    return controller;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Genre
        if (row == 0) {
            
            NSString * val = nil;
            if ([(Game *)model_ genre]) {
                val = [[(Game *)model_ genre] title];
            }
            
            return [self makeCellForTableView:tableView 
                                   identifier:@"GameInfo_Cell_Genre"
                                        title:NSLocalizedString(@"Genre", nil)
                                        value:val
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:NO];
        }
        
        // Platform
        else if (row == 1) {
            
            NSString * val = nil;
            if ([(Game *)model_ platform]) {
                val = [[(Game *)model_ platform] title];
            }
            
            return [self makeCellForTableView:tableView 
                                   identifier:@"GameInfo_Cell_Platform"
                                        title:NSLocalizedString(@"Platform", nil)
                                        value:val
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:YES];
        }
    }
    
    //
    // Section 2
    
    else if (section == 1) {
        
        // Developer
        if (row == 0) {
            
            NSString * val = nil;
            if ([(Game *)model_ author]) {
                val = [[(Game *)model_ author] title];
            }
            
            return [self makeCellForTableView:tableView 
                                   identifier:@"GameInfo_Cell_Developer"
                                        title:NSLocalizedString(@"Developer", nil)
                                        value:val
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:YES];
        }
        
        // Release date
        else if (row == 1) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"GameInfo_Cell_Date"
                                        title:NSLocalizedString(@"Release date", nil)
                                        value:[GMDate longDate:[(Game *)model_ releaseDate]]
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:NO];
        }
    }
    
    //
    // Section 3
    
    else if (section == 2) {
        
        // Notes
        if (row == 0) {
            NSString * val = nil;
            if ([(Game *)model_ notes]) {
                if ([[(Game *)model_ notes] length] > 12) {
                    val = [NSString stringWithFormat:@"%@...", [[(Game *)model_ notes] substringToIndex:9]];
                }
                else {
                    val = [(Game *)model_ notes];
                }
            }
            
            return [self makeCellForTableView:tableView
                                   identifier:@"GameInfo_Cell_Notes"
                                        title:NSLocalizedString(@"Notes", nil)
                                        value:val
                               emptyValueText:@""
                                    clickable:YES];
        }
        
        // Links
        else if (row == 1) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"GameInfo_Cell_Links"
                                        title:NSLocalizedString(@"Links", nil)
                                        value:[NSString stringWithFormat:@"%d", [[(Game *)model_ links] count]]
                               emptyValueText:@"0"
                                    clickable:YES];
        }
        
        // Completed dates
        else if (row == 2) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"GameInfo_Cell_Completed"
                                        title:NSLocalizedString(@"Completed times", nil)
                                        value:[NSString stringWithFormat:@"%d", [[(Game *)model_ completedDates] count]]
                               emptyValueText:@"0"
                                    clickable:YES];
        }
        
        // Planned till
        else if (row == 3) {
            return [self makeCellForTableView:tableView 
                                   identifier:@"GameInfo_Cell_Planned"
                                        title:NSLocalizedString(@"Planned till", nil)
                                        value:[GMDate longDate:[(Game *)model_ plannedTillDate]]
                               emptyValueText:NSLocalizedString(@"Unknown", nil)
                                    clickable:NO];
        }
    }
    
    //
    // Section 4
    
    else if (section == 3) {
        
        // Notes
        if (row == 0) {
            return [self makeButtonCellForTableView:tableView
                                         identifier:@"GameInfo_Cell_Button"
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
            return 2;
        case 2:
            if ([(Game *)model_ plannedTillDate]) {
                return 4;
            }
            else {
                return 3;
            }
        case 3:
            return 1;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to GameInfo table datasource, section=%d", section];
    return 0;   // never reach here
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Game information", nil);
        case 1:
            return NSLocalizedString(@"Publishing information", nil);
        case 2:
            return NSLocalizedString(@"Additional information", nil);
        case 3:
            return nil;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to GameInfo table datasource, section=%d", section];
    return nil;   // never reach here
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Genre
        if (row == 0) {
            return;
        }
        
        // Platform
        else if (row == 1) {
            GMPlatformInfoViewController * controller = [[GMPlatformInfoViewController alloc] initWithModel:[(Game *)model_ platform]];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
    }
    
    //
    // Section 2
    
    else if (section == 1) {
        
        // Developer
        if (row == 0) {
            GMAuthorInfoViewController * controller = [[GMAuthorInfoViewController alloc] initWithModel:[(Game *)model_ author]];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        // Release date
        else if (row == 1) {
            return;
        }
    }
    
    //
    // Section 3
    
    else if (section == 2) {
        
        // Notes
        if (row == 0) {
            GMNotesViewController * controller = [[[GMNotesViewController alloc] initWithTitle:NSLocalizedString(@"Game notes", nil) andData:[(Game *)model_ notes]] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        // Links
        else if (row == 1) {
            GMLinksListTableViewController * controller = [[[GMLinksListTableViewController alloc] initWithTitle:NSLocalizedString(@"Game links", nil) andData:[(Game *)model_ links]] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        // Completed dates
        else if (row == 2) {
            GMDatesListTableViewController * controller = [[[GMDatesListTableViewController alloc] initWithTitle:NSLocalizedString(@"Game completed dates", nil) andData:[(Game *)model_ completedDates]] autorelease];
            [self.navigationController pushViewController:controller animated:YES];
            return;
        }
        
        // Planned date
        else if (row == 3) {
            return;
        }
    }
    
    //
    // Section 4
    
    else if (section == 3) {
        
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
