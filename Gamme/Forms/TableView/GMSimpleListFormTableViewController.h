//
//  GMSimpleListFormTableViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMModels.h"
#import "GMAbstractFormController.h"

@interface GMSimpleListFormTableViewController : GMAbstractFormController
{
@protected
    NSString * defaultTitle_;
    id<UITableViewDataSource> datasource_;
    id<UITableViewDelegate> delegate_;
}

@property (assign, nonatomic, readwrite) IBOutlet UITableView * tableView;
@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title datasource:(id<UITableViewDataSource>)datasource delegate:(id<UITableViewDelegate>)delegate;

- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) editButtonPressed:(id)sender;

@end
