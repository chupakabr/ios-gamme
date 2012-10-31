//
//  GMGamesTableViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/19/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMSimpleListFormTableViewController.h"
#import "GMGamesTableViewDSDL.h"

@interface GMGamesTableViewController : GMSimpleListFormTableViewController
{
@protected
    NSManagedObject * model_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil title:(NSString *)title model:(NSManagedObject *)model dsdl:(GMAbstractSimpleFormTableViewDSDL *)dsdl;

- (IBAction) infoButtonPressed:(id)sender;

@end
