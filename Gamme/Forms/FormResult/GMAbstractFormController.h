//
//  GMAbstractFormController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/1/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>

#define GM_TABLEVIEW_STYLE UITableViewCellStyleValue1

@interface GMAbstractFormController : UIViewController
{    
@private
    NSMutableDictionary * resultData_;
}

- (NSObject *) getResultData:(NSString *)key;
- (NSObject *) getOutgoingResultData:(NSString *)key;
- (void) setIncomingResultData:(NSObject *)resultData forKey:(NSString *)key;
- (void) setOutgoingResultData:(NSObject *)resultData forKey:(NSString *)key;

// UI helpers
- (UIView *) getFormControl:(NSInteger)tag tableView:(UITableView *)tableView;
- (NSString *) getTextFieldValue:(NSInteger)tag tableView:(UITableView *)tableView;

- (void) showDatepickerFormWithTitle:(NSString *)title andValue:(NSDate *)value andResultKey:(NSString *)resultKey;
- (void) showTextareaFormWithTitle:(NSString *)title andValue:(NSString *)value andResultKey:(NSString *)resultKey;
- (void) showRatingFormWithTitle:(NSString *)title andValue:(NSNumber *)value andResultKey:(NSString *)resultKey;

@end
