//
//  GMCompletedDateFormController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/8/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractFormController.h"
#import "GMModels.h"

@interface GMCompletedDateFormController : GMAbstractFormController

@property (strong, nonatomic, readwrite) NSString * uiTitle;
@property (strong, nonatomic, readwrite) NSString * resultKey;
@property (strong, nonatomic, readwrite) CompletedDate * initialValue;
@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UITextView * textView;
@property (assign, nonatomic, readwrite) IBOutlet UIDatePicker * datePicker;
@property (assign, nonatomic, readwrite) IBOutlet UILabel * textLabel;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title andValue:(CompletedDate *)value andResultKey:(NSString *)resultKey;

- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) saveButtonPressed:(id)sender;
- (IBAction) tapHideKeyboard:(id)sender;

@end
