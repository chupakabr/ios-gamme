//
//  GMTextInputForCell.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/30/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMTextInputForCell.h"
#import "GMLog.h"


//
// Simple delegate for custom TextField

@interface GMTextInputForCellDelegate : NSObject<UITextFieldDelegate>
@end

@implementation GMTextInputForCellDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

@end


//
// TextField impl

@implementation GMTextInputForCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setAutoresizesSubviews:YES];
        [self setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        [self setBorderStyle:UITextBorderStyleNone];
        [self setReturnKeyType:UIReturnKeyDone];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        
        customDelegate_ = [[GMTextInputForCellDelegate alloc] init];
        [self setDelegate:customDelegate_];
    }
    
    return self;
}

- (void)dealloc
{
    self.delegate = nil;
    [customDelegate_ release];
    
    [super dealloc];
}


@end
