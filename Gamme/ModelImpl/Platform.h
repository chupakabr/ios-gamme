//
//  Platform.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Game, Link;

@interface Platform : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * site;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSSet *gameShopLinks;
@property (nonatomic, retain) NSSet *games;
@property (nonatomic, retain) NSNumber * isSystem;

// my custom
- (void) prepareAndUpdateGameShopLinks:(NSSet *)values;

@end

@interface Platform (CoreDataGeneratedAccessors)

- (void)addGameShopLinksObject:(Link *)value;
- (void)removeGameShopLinksObject:(Link *)value;
- (void)addGameShopLinks:(NSSet *)values;
- (void)removeGameShopLinks:(NSSet *)values;

- (void)addGamesObject:(Game *)value;
- (void)removeGamesObject:(Game *)value;
- (void)addGames:(NSSet *)values;
- (void)removeGames:(NSSet *)values;

@end
