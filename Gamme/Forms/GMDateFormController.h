//
//  GMDateFormController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMAbstractFormController.h"

@interface GMDateFormController : GMAbstractFormController

@property (strong, nonatomic, readwrite) NSString * uiTitle;
@property (strong, nonatomic, readwrite) NSString * resultKey;
@property (strong, nonatomic, readwrite) NSDate * initialValue;
@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UIDatePicker * datePicker;
@property (assign, nonatomic, readwrite) IBOutlet UISegmentedControl * onOffButton;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title andValue:(NSDate *)value andResultKey:(NSString *)resultKey;

- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) saveButtonPressed:(id)sender;
- (IBAction) onOffButtonPressed:(id)sender;

@end
