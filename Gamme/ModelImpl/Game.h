//
//  Game.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/27/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "GameState.h"

@class Author, CompletedDate, Genre, Link, Platform;

@interface Game : NSManagedObject

@property (nonatomic, retain) NSDate * addedDate;
@property (nonatomic, retain) NSDate * inProgressDate;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSDate * plannedTillDate;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSDate * releaseDate;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Author *author;
@property (nonatomic, retain) Genre *genre;
@property (nonatomic, retain) NSSet *links;
@property (nonatomic, retain) Platform *platform;
@property (nonatomic, retain) NSSet *completedDates;


// My stuff
- (void)prepareAndUpdateLinks:(NSSet *)values;
- (void)prepareAndUpdateCompletedDates:(NSSet *)values;

@end

@interface Game (CoreDataGeneratedAccessors)

- (void)addLinksObject:(Link *)value;
- (void)removeLinksObject:(Link *)value;
- (void)addLinks:(NSSet *)values;
- (void)removeLinks:(NSSet *)values;

- (void)addCompletedDatesObject:(CompletedDate *)value;
- (void)removeCompletedDatesObject:(CompletedDate *)value;
- (void)addCompletedDates:(NSSet *)values;
- (void)removeCompletedDates:(NSSet *)values;

@end
