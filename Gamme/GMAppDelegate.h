//
//  GMAppDelegate.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GMPersistenceHelper.h"
#import "GMNib.h"


@interface GMAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{

@private
    NSPersistentStoreCoordinator * persistentStoreCoordinator_;
    NSManagedObjectContext * managedObjectContext_;
    
    GMPersistenceHelper * persistenceHelper_;
}

+ (GMAppDelegate *)instance;

@property (assign, nonatomic, readonly) GMPersistenceHelper * persistenceHelper;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (strong, nonatomic, readonly) NSPersistentStoreCoordinator * persistentStoreCoordinator;
@property (strong, nonatomic, readonly) NSManagedObjectContext * managedObjectContext;

@end
