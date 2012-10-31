//
//  GMAbstractSimpleFormTableViewDSDL.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMSimpleListFormTableViewController.h"
#import "GMAppDelegate.h"
#import "GMNib.h"
#import "GMDate.h"

@interface GMAbstractSimpleFormTableViewDSDL : NSObject<UITableViewDataSource, UITableViewDelegate>
{
@protected
    NSArray * data_;
    GMSimpleListFormTableViewController * parentController_;
}

- (id)initWithResultKey:(NSString *)resultDataKey;

@property (strong, nonatomic, readwrite) NSString * resultDataKey;
@property (assign, nonatomic, readwrite) BOOL canCreate;
@property (assign, nonatomic, readwrite) BOOL canDelete;

@property (weak, nonatomic, readonly) UITableView * tableView;  // for internal use
@property (weak, nonatomic, readwrite) UIViewController * parentController;


- (NSArray *) getData_:(BOOL)refresh;
- (NSManagedObject *) getDataAtIndex_:(NSInteger)idx;
- (void) deleteSelectedData:(NSObject *)obj;


// Abstract methods to override
- (NSString *) resultDataKey;
- (NSString *) getTitleForModel:(NSManagedObject *)obj;
- (NSString *) getDetailForModel:(NSManagedObject *)obj;
- (NSFetchRequest *) getFetchRequest;
- (GMAbstractFormController *) createEditFormControllerForSelectedData:(NSManagedObject *)selectedData;
- (void) customCellConfigaration:(UITableViewCell *)cell forRow:(NSInteger)row;

@end
