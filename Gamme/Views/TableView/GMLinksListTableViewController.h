//
//  GMLinksListTableViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMModels.h"

@interface GMLinksListTableViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
@protected
    NSArray * data_;
    NSString * title_;
}

@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UITableView * tableView;

- (id) initWithTitle:(NSString *)title andData:(NSSet *)data;

- (IBAction) backButtonPressed:(id)sender;

@end
