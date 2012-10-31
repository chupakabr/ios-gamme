//
//  GMExtraInfoFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/6/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMExtraInfoFormController.h"
#import "GMLinksSimpleFormTableViewDSDL.h"
#import "GMDatesSimpleFormTableViewDSDL.h"
#import "GMBackButtonListFormTableViewController.h"
#import "GMAppDelegate.h"
#import "GMLog.h"

// Info:
//   Rating
//   Notes
//   Links
// Dates:
//   Planned Till Date
//   Completed Dates
//   In Progress Date???

@implementation GMExtraInfoFormController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andModel:(NSManagedObject *)model andParentController:(GMAbstractCommonFormTableViewController *)parentController
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil andModel:model];
    if (self) {
        parentController_ = parentController;
    }
    
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //
    // Setup initial values from parent form
    
    [self setIncomingResultData:[parentController_ getSelectedValue:@"notes" selector:@selector(notes)] forKey:@"notes"];
    [self setIncomingResultData:[parentController_ getSelectedValue:@"rating" selector:@selector(rating)] forKey:@"rating"];
    [self setIncomingResultData:[parentController_ getSelectedValue:@"links" selector:@selector(links)] forKey:@"links"];
    [self setIncomingResultData:[parentController_ getSelectedValue:@"plannedDate" selector:@selector(plannedTillDate)] forKey:@"plannedDate"];
    [self setIncomingResultData:[parentController_ getSelectedValue:@"completedDates" selector:@selector(completedDates)] forKey:@"completedDates"];
    
    // to know that these fields were changed
    [self setIncomingResultData:[NSNumber numberWithBool:YES] forKey:@"rating_set"];
    [self setIncomingResultData:[NSNumber numberWithBool:YES] forKey:@"notes_set"];
    [self setIncomingResultData:[NSNumber numberWithBool:YES] forKey:@"links_set"];
    [self setIncomingResultData:[NSNumber numberWithBool:YES] forKey:@"plannedDate_set"];
    [self setIncomingResultData:[NSNumber numberWithBool:YES] forKey:@"completedDates_set"];
    
    
    //
    // UI stuff
    
    [self.navBarItem setTitle:NSLocalizedString(@"Additional info", nil)];
    
    // Rename Cancel button to Back button and call saveButtonPresses() instead on cancel
    UIBarButtonItem * btn = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(saveButtonPressed:)] autorelease];
    [self.navBarItem setLeftBarButtonItem:btn];
    
    // Remove right button
    [self.navBarItem setRightBarButtonItem:nil];
}


#pragma mark - UI actions

- (BOOL) validateForm
{
    return YES;
}

- (void) saveForm
{
    // Pass parameters to parent form
    NSNumber * rating = (NSNumber *)[self getSelectedValue:@"rating" selector:@selector(rating)];
    NSString * notes = (NSString *)[self getSelectedValue:@"notes" selector:@selector(notes)];
    NSSet * links = (NSSet *)[self getSelectedValue:@"links" selector:@selector(links)];
    NSDate * plannedDate = (NSDate *)[self getSelectedValue:@"plannedDate" selector:@selector(plannedTillDate)];
    NSSet * completedDates = (NSSet *)[self getSelectedValue:@"completedDates" selector:@selector(completedDates)];
    
    [self setOutgoingResultData:rating forKey:@"rating"];
    [self setOutgoingResultData:notes forKey:@"notes"];
    [self setOutgoingResultData:links forKey:@"links"];
    [self setOutgoingResultData:plannedDate forKey:@"plannedDate"];
    [self setOutgoingResultData:completedDates forKey:@"completedDates"];
    
    // to know that these fields were changed
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:@"rating_set"];
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:@"notes_set"];
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:@"links_set"];
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:@"plannedDate_set"];
    [self setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:@"completedDates_set"];
}


#pragma mark - UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Rating
        if (row == 0) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"ExtraInfoForm_Cell_Rating" 
                                              title:NSLocalizedString(@"Game rating", nil)
                                 currentValueGetter:^{
                                     NSNumber * rating = (NSNumber *)[self getSelectedValue:@"rating" selector:@selector(rating)];
                                     if (rating) {
                                         return [NSString stringWithFormat:@"%d", [rating intValue]];
                                     } else {
                                         return NSLocalizedString(@"None", nil);
                                     }
                                 }];
        }
        
        // Notes 
        else if (row == 1) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"ExtraInfoForm_Cell_Notes" 
                                              title:NSLocalizedString(@"Notes", nil)
                                 currentValueGetter:^{
                                     NSString * notes = (NSString *)[self getSelectedValue:@"notes" selector:@selector(notes)];
                                     if (notes) {
                                         if ([notes length] > 12) {
                                             return [NSString stringWithFormat:@"%@...", [notes substringToIndex:9]];
                                         } else {
                                             return notes;
                                         }
                                     } else {
                                         return NSLocalizedString(@"None", nil);
                                     }
                                 }];
        }
        
        // Links
        else if (row == 2) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"ExtraInfoForm_Cell_Links" 
                                              title:NSLocalizedString(@"Links", nil)
                                 currentValueGetter:^{
                                     int count = 0;
                                     NSSet * links = (NSSet *)[self getSelectedValue:@"links" selector:@selector(links)];
                                     
                                     if (links) {
                                         count = [links count];
                                     }
                                     
                                     return [NSString stringWithFormat:@"%d", count];
                                 }];
        }
    }
    
    //
    // Section 2
    
    if (section == 1) {
        
        // Planned till date
        if (row == 0) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"ExtraInfoForm_Cell_PlannedDate" 
                                              title:NSLocalizedString(@"Planned till date", nil)
                                 currentValueGetter:^{
                                     NSDate * date = (NSDate *)[self getSelectedValue:@"plannedDate" selector:@selector(plannedTillDate)];
                                     if (date) {
                                         return [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
                                     } else {
                                         return NSLocalizedString(@"None", nil);
                                     }
                                 }];
        }
        
        // Completed dates
        else if (row == 1) {
            return [self makeCommonCellForTableView:self.tableView 
                                         identifier:@"ExtraInfoForm_Cell_CompletedDate" 
                                              title:NSLocalizedString(@"Completed on dates", nil)
                                 currentValueGetter:^{
                                     int count = 0;
                                     NSSet * dates = (NSSet *)[self getSelectedValue:@"completedDates" selector:@selector(completedDates)];
                                     
                                     if (dates) {
                                         count = [dates count];
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
            return 3;
        case 1:
            return 2;
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to ExtraInfoForm table datasource, section=%d", section];
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
            return NSLocalizedString(@"Information", nil);
        case 1:
            return NSLocalizedString(@"Dates", nil);
    }
    
    [NSException raise:@"InvalidTableSectionIndex" format:@"Unknown index passed to ExtraInfoForm table datasource, section=%d", section];
    return nil;   // never reach here
}


#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMLog(@"ExtraInfoForm TableView selected");
    
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    
    
    //
    // Section 1
    
    if (section == 0) {
        
        // Rating
        if (row == 0) {
            [self showRatingFormWithTitle:NSLocalizedString(@"Game rating", nil) andValue:(NSNumber *)[self getSelectedValue:@"rating" selector:@selector(rating)] andResultKey:@"rating"];
            return;
        }
        
        // Notes
        else if (row == 1) {
            [self showTextareaFormWithTitle:NSLocalizedString(@"Notes", nil) andValue:(NSString *)[self getSelectedValue:@"notes" selector:@selector(notes)] andResultKey:@"notes"];
            return;
        }
        
        // Links
        else if (row == 2) {
            [self showListPickerFormWithTitle:NSLocalizedString(@"Links", nil)
                                      andDSDL:[[[GMLinksSimpleFormTableViewDSDL alloc] initWithResultKey:@"links" andData:(NSSet *)[self getSelectedValue:@"links" selector:@selector(links)]] autorelease]
                           andControllerClass:[GMBackButtonListFormTableViewController class]];
            return;
        }
    }
    
    //
    // Section 2
    
    if (section == 1) {
        
        // Planned till date
        if (row == 0) {
            [self showDatepickerFormWithTitle:NSLocalizedString(@"Planned till date", nil) andValue:(NSDate *)[self getSelectedValue:@"plannedDate" selector:@selector(releaseDate)] andResultKey:@"plannedDate"];
            return;
        }
        
        // Completed dates
        else if (row == 1) {
            [self showListPickerFormWithTitle:NSLocalizedString(@"Completed on", nil)
                                      andDSDL:[[[GMDatesSimpleFormTableViewDSDL alloc] initWithResultKey:@"completedDates" andData:(NSSet *)[self getSelectedValue:@"completedDates" selector:@selector(completedDates)]] autorelease]
                           andControllerClass:[GMBackButtonListFormTableViewController class]];
            return;
        }
    }
    
    
    // Unknow section
    [NSException raise:@"InvalidTableViewSection" format:@"Invalid table view section=%d, row=%d", section, row];
}

@end
