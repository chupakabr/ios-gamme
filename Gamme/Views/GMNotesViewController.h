//
//  GMNotesViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/24/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMNotesViewController : UIViewController
{
@protected
    NSString * data_;
    NSString * title_;
}

@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UITextView * textView;

- (id) initWithTitle:(NSString *)title andData:(NSString *)data;

- (IBAction) backButtonPressed:(id)sender;

@end
