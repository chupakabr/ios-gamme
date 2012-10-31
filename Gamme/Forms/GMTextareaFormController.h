//
//  GMTextareaFormController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/7/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMAbstractFormController.h"

@interface GMTextareaFormController : GMAbstractFormController

@property (strong, nonatomic, readwrite) NSString * uiTitle;
@property (strong, nonatomic, readwrite) NSString * resultKey;
@property (strong, nonatomic, readwrite) NSString * initialValue;
@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UITextView * textView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title andValue:(NSString *)value andResultKey:(NSString *)resultKey;

- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) saveButtonPressed:(id)sender;

@end
