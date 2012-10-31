//
//  GMAbstractInfoViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMAbstractCommonFormTableViewController.h"
#import "GMAppDelegate.h"
#import "GMLog.h"
#import "GMDate.h"

@interface GMAbstractInfoViewController : UIViewController
                    <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
@protected
    NSManagedObject * model_;
}

@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UITableView * tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andModel:(NSManagedObject *)model;   // view

- (IBAction) backButtonPressed:(id)sender;
- (IBAction) editButtonPressed:(id)sender;
- (void) deleteButtonPressed:(id)sender;


//
// Custom abstract

- (GMAbstractCommonFormTableViewController *) getEditFormController;


//
// UI helpers

- (UITableViewCell *) makeCellForTableView:(UITableView *)tableView identifier:(NSString *)identifier title:(NSString *)title value:(NSString *)value emptyValueText:(NSString *)emptyValueText clickable:(BOOL)clickable;
- (UITableViewCell *) makeButtonCellForTableView:(UITableView *)tableView identifier:(NSString *)identifier title:(NSString *)title;
- (void) tryDeleteModel;

// UIAlertViewDelegate impl
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end
