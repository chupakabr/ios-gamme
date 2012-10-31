//
//  Author.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game;

@interface Author : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * site;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSDate * foundationDate;
@property (nonatomic, retain) NSDate * closeDate;
@property (nonatomic, retain) NSSet *games;
@property (nonatomic, retain) NSNumber * isSystem;
@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;
@end
