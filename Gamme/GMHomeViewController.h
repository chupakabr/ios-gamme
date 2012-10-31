//
//  GMHomeViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMHomeViewController : UIViewController<UISearchBarDelegate>

@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UISearchBar * searchBar;
@property (assign, nonatomic, readwrite) IBOutlet UIButton * completedButton;
@property (assign, nonatomic, readwrite) IBOutlet UIButton * plannedButton;
@property (assign, nonatomic, readwrite) IBOutlet UILabel * completedLabel;
@property (assign, nonatomic, readwrite) IBOutlet UILabel * plannedLabel;
@property (assign, nonatomic, readwrite) IBOutlet UILabel * searchResultLabel;

- (IBAction) addButtonPressed:(id)sender;
- (IBAction) completedButtonPressed:(id)sender;
- (IBAction) plannedButtonPressed:(id)sender;

@end
