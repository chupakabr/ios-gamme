//
//  GMPersistenceHelper.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/31/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMModels.h"

@interface GMPersistenceHelper : NSObject
{
@private
    NSManagedObjectContext * moc_;
    
    NSEntityDescription * gameED_;
    NSEntityDescription * completedDateED_;
    NSEntityDescription * platformED_;
    NSEntityDescription * authorED_;
    NSEntityDescription * linkED_;
    NSEntityDescription * genreED_;
}

///
/// Retain ManagedObjectContext instance !!!!!
///
- (id) initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (NSManagedObjectContext *) MOC;

// CRUD
- (void) save;
- (void) deleteObject:(NSManagedObject *)obj;
- (void) deleteObjectNow:(NSManagedObject *)obj;
- (void) insertObject:(NSManagedObject *)obj;
- (void) insertObjectNow:(NSManagedObject *)obj;
- (NSUInteger) countWithRequest:(NSFetchRequest *)entity;

// Entity description
- (NSEntityDescription *) gameEntityDescription;
- (NSEntityDescription *) completedDateEntityDescription;
- (NSEntityDescription *) platformEntityDescription;
- (NSEntityDescription *) authorEntityDescription;
- (NSEntityDescription *) linkEntityDescription;
- (NSEntityDescription *) genreEntityDescription;

// Entity instance
- (Game *) newGame;
- (Game *) newGameInContext;
- (CompletedDate *) newCompletedDate;
- (Platform *) newPlatform;
- (Author *) newAuthor;
- (Link *) newLink;
- (Genre *) newGenre;

// System entities
- (Genre *) defaultGenre;
- (Author *) defaultAuthor;
- (Platform *) defaultPlatform;

@end
