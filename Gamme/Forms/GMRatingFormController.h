//
//  GMRatingFormController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/8/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractFormController.h"

@interface GMRatingFormController : GMAbstractFormController

@property (strong, nonatomic, readwrite) NSString * uiTitle;
@property (strong, nonatomic, readwrite) NSString * resultKey;
@property (strong, nonatomic, readwrite) NSNumber * initialValue;
@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UISegmentedControl * segmentedControl;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andTitle:(NSString *)title andValue:(NSNumber *)value andResultKey:(NSString *)resultKey;

- (IBAction) cancelButtonPressed:(id)sender;
- (IBAction) saveButtonPressed:(id)sender;


@end
