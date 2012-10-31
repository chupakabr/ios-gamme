//
//  GMAbstractCommonFormTableViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMSimpleListFormTableViewController.h"
#import "GMAbstractSimpleFormTableViewDSDL.h"
#import "GMAbstractFormController.h"
#import "GMTextInputForCell.h"
#import "GMModels.h"


typedef NSString * (^GMValueGetterType)(void);


@interface GMAbstractCommonFormTableViewController : GMAbstractFormController<UITableViewDataSource, UITableViewDelegate>
{
@protected
    NSManagedObject * model_;
}

@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UITableView * tableView;
@property (assign, nonatomic, readwrite) IBOutlet UILabel * statusLabel;
@property (assign, nonatomic, readwrite) BOOL canCreate;
@property (assign, nonatomic, readwrite) BOOL canDelete;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;   // create
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andModel:(NSManagedObject *)model;   // update

- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) saveButtonPressed:(id)sender;

// UI Helpers
- (NSObject *) getSelectedValue:(NSString *)resultKey selector:(SEL)modelValueGetterSelector;
- (UITableViewCell *) makeTextInputCellForTableView:(UITableView *)tableView identifier:(NSString *)identifier title:(NSString *)title placeholder:(NSString *)placeholder keyboardType:(UIKeyboardType)keyboardType keyboardCap:(UITextAutocapitalizationType)keyboardCap tag:(NSInteger)tag currentValueGetter:(GMValueGetterType)currentValueGetter;
- (UITableViewCell *) makeCommonCellForTableView:(UITableView *)tableView identifier:(NSString *)identifier title:(NSString *)title currentValueGetter:(GMValueGetterType)currentValueGetter;

// UI Helpers (show)
- (void) showListPickerFormWithTitle:(NSString *)title andDSDL:(GMAbstractSimpleFormTableViewDSDL *)dsdl andControllerClass:(Class)controllerClassOrNil;;

// Abstract methods to be implemented by child
- (BOOL) validateForm;
- (void) saveForm;

@end
