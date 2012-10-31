//
//  GMExtraInfoFormController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/6/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMAbstractCommonFormTableViewController.h"

@interface GMExtraInfoFormController : GMAbstractCommonFormTableViewController
{
@private
    GMAbstractCommonFormTableViewController * parentController_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andModel:(NSManagedObject *)model andParentController:(GMAbstractCommonFormTableViewController *)parentController;

@end
