//
//  GMGameInfoViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractInfoViewController.h"

@interface GMGameInfoViewController : GMAbstractInfoViewController
{
@private
    UIImage * starImage_;
    UIImage * starInactiveImage_;
}

@property (assign, nonatomic, readwrite) IBOutlet UIScrollView * scrollView;
@property (assign, nonatomic, readwrite) IBOutlet UIView * starsView;
@property (assign, nonatomic, readwrite) IBOutlet UIButton * star1Button;
@property (assign, nonatomic, readwrite) IBOutlet UIButton * star2Button;
@property (assign, nonatomic, readwrite) IBOutlet UIButton * star3Button;
@property (assign, nonatomic, readwrite) IBOutlet UIButton * star4Button;
@property (assign, nonatomic, readwrite) IBOutlet UIButton * star5Button;

- (id)initWithModel:(NSManagedObject *)model;

- (IBAction) starClicked:(UIButton *)sender;

@end
