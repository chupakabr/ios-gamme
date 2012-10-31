//
//  GMAbstractFormController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/1/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractFormController.h"
#import "GMDateFormController.h"
#import "GMTextareaFormController.h"
#import "GMRatingFormController.h"
#import "GMTextInputForCell.h"
#import "GMNib.h"
#import "GMLog.h"

@interface GMAbstractFormController (Privates)
- (GMAbstractFormController *) getParentController_;
@end

@implementation GMAbstractFormController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        resultData_ = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void) dealloc
{
    [resultData_ release];
    [super dealloc];
}

- (NSObject *) getResultData:(NSString *)key
{
    return [resultData_ valueForKey:key];
}

- (NSObject *) getOutgoingResultData:(NSString *)key
{
    return [[self getParentController_] getResultData:key];
}

- (void) setIncomingResultData:(NSObject *)resultData forKey:(NSString *)key
{
    [resultData_ setValue:resultData forKey:key];
}

- (void) setOutgoingResultData:(NSObject *)resultData forKey:(NSString *)key
{
    [[self getParentController_] setIncomingResultData:resultData forKey:key];
}

- (GMAbstractFormController *) getParentController_
{
    UIViewController * parentController = [self parentViewController];
    
    if (!parentController) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot get parent controller"];
    }
    
    if ([parentController isKindOfClass:[UINavigationController class]]) {
        NSArray * viewControllers = [(UINavigationController *) parentController viewControllers];
        parentController = [viewControllers objectAtIndex:(viewControllers.count-2)];
    }
    
    if (![parentController isKindOfClass:[GMAbstractFormController class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Parent controller is not kind of class GMAbstractFormController but %@", [parentController class]];
    }
    
    return (GMAbstractFormController *) parentController;
}


#pragma mark - UI helpers

- (NSString *) getTextFieldValue:(NSInteger)tag tableView:(UITableView *)tableView
{
    return [(GMTextInputForCell *)[self getFormControl:tag tableView:tableView] text];
}

- (UIView *) getFormControl:(NSInteger)tag tableView:(UITableView *)tableView
{
    NSIndexPath * idx;
    
    for (NSInteger i = 0; i < [tableView numberOfSections]; i++)
    {
        for (int j = 0; j < [tableView numberOfRowsInSection:i]; j++)
        {
            idx = [NSIndexPath indexPathForRow:j inSection:i];
            
            for (UIView * subview in [[tableView cellForRowAtIndexPath:idx] subviews])
            {
                if ([subview tag] == tag) {
                    return subview;
                }
            }
        }
    }
    
    return nil;
}

- (void) showDatepickerFormWithTitle:(NSString *)title andValue:(NSDate *)value andResultKey:(NSString *)resultKey
{
    GMDateFormController * controller = [[[GMDateFormController alloc] initWithNibName:[GMNib getNibName:@"GMDateFormController"] bundle:nil andTitle:title andValue:value andResultKey:resultKey] autorelease];
    [self.navigationController pushViewController:controller animated:YES];    
}

- (void) showTextareaFormWithTitle:(NSString *)title andValue:(NSString *)value andResultKey:(NSString *)resultKey
{
    GMTextareaFormController * controller = [[[GMTextareaFormController alloc] initWithNibName:[GMNib getNibName:@"GMTextareaFormController"] bundle:nil andTitle:title andValue:value andResultKey:resultKey] autorelease];
    [self.navigationController pushViewController:controller animated:YES];    
}

- (void) showRatingFormWithTitle:(NSString *)title andValue:(NSNumber *)value andResultKey:(NSString *)resultKey
{
    GMRatingFormController * controller = [[[GMRatingFormController alloc] initWithNibName:[GMNib getNibName:@"GMRatingFormController"] bundle:nil andTitle:title andValue:value andResultKey:resultKey] autorelease];
    [self.navigationController pushViewController:controller animated:YES];    
}

@end
