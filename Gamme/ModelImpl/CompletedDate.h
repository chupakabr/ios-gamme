//
//  CompletedDate.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/27/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface CompletedDate : NSManagedObject

@property (nonatomic, retain) NSDate * completedDate;
@property (nonatomic, retain) NSString * note;
@property (nonatomic, retain) Game *game;

@end
