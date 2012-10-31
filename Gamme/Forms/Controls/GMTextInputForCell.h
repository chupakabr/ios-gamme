//
//  GMTextInputForCell.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/30/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMTextInputForCell : UITextField {
@private
    NSObject<UITextFieldDelegate> * customDelegate_;
}

@end
