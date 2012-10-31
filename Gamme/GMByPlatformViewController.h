//
//  GMByPlatformViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMPlatformNiceTableViewDSDL.h"

@interface GMByPlatformViewController : UIViewController

@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UITableView * tableView;
@property (strong, nonatomic, readwrite) GMPlatformNiceTableViewDSDL * dsdl;

- (IBAction) addButtonPressed:(id)sender;

@end
