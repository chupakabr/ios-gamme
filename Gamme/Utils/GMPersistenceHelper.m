//
//  GMPersistenceHelper.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/31/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMPersistenceHelper.h"
#import "GMLog.h"

@implementation GMPersistenceHelper

- (id) initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    self = [super init];
    if (self) {
        moc_ = [managedObjectContext retain];
    }
    
    return self;
}

- (void) dealloc
{
    [moc_ release];
    
    [super dealloc];
}

- (NSManagedObjectContext *) MOC
{
    return moc_;
}


#pragma mark - CRUD

- (void) save
{
    NSError * errors;
    if (![moc_ save:&errors])
    {
        NSArray* detailedErrors = [[errors userInfo] objectForKey:NSDetailedErrorsKey];
        if(detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                GMError(@"  DetailedError: %@", [detailedError userInfo]);
            }
        } else {
            GMError(@"  DetailedError2: %@", [errors userInfo]);
        }
        
        [NSException raise:NSInternalInconsistencyException format:@"Cannot save MOC: %@", [errors description]];
    }
}

- (void) deleteObject:(NSManagedObject *)obj
{
    if ([obj isKindOfClass:[Genre class]]) {
        NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[self gameEntityDescription]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"genre = %@", obj]];
        
        NSArray * result = [self.MOC executeFetchRequest:fetchRequest error:nil];
        if ([result count] > 0) {
            for (Game * e in result) {
                [e setGenre:[self defaultGenre]];
            }
            [self save];
        }
    }
    else if ([obj isKindOfClass:[Platform class]]) {
        NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[self gameEntityDescription]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"platform = %@", obj]];
        
        NSArray * result = [self.MOC executeFetchRequest:fetchRequest error:nil];
        if ([result count] > 0) {
            for (Game * e in result) {
                [e setPlatform:[self defaultPlatform]];
            }
            [self save];
        }
    }
    else if ([obj isKindOfClass:[Author class]]) {
        NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:[self gameEntityDescription]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"author = %@", obj]];
        
        NSArray * result = [self.MOC executeFetchRequest:fetchRequest error:nil];
        if ([result count] > 0) {
            for (Game * e in result) {
                [e setAuthor:[self defaultAuthor]];
            }
            [self save];
        }
    }
    
    [moc_ deleteObject:obj];
}

- (void) deleteObjectNow:(NSManagedObject *)obj
{
    [self deleteObject:obj];
    [self save];
}

- (void) insertObject:(NSManagedObject *)obj
{
    [moc_ insertObject:obj];
}

- (void) insertObjectNow:(NSManagedObject *)obj
{
    [moc_ insertObject:obj];
    [self save];
}

- (NSUInteger) countWithRequest:(NSFetchRequest *)fetchRequest
{
    NSError * errors;
    NSUInteger count = [moc_ countForFetchRequest:fetchRequest error:&errors];
    if (count == NSNotFound)
    {
        NSArray* detailedErrors = [[errors userInfo] objectForKey:NSDetailedErrorsKey];
        if (detailedErrors != nil && [detailedErrors count] > 0) {
            for(NSError* detailedError in detailedErrors) {
                GMError(@"  DetailedError: %@", [detailedError userInfo]);
            }
        } else {
            GMError(@"  %@", [errors userInfo]);
        }
        
        [NSException raise:NSInternalInconsistencyException format:@"Cannot count Entity(%@): %@", [[fetchRequest entity] name], [errors description]];
    }
    
    return count;
}


#pragma mark - Entity description

- (NSEntityDescription *) gameEntityDescription
{
    if (!gameED_) {
        gameED_ = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:moc_];
        if (!gameED_) {
            [NSException raise:NSInternalInconsistencyException format:@"Game Entity not found in MOC"];
        }        
    }
    
    return gameED_;
}

- (NSEntityDescription *) completedDateEntityDescription
{
    if (!completedDateED_) {
        completedDateED_ = [NSEntityDescription entityForName:@"CompletedDate" inManagedObjectContext:moc_];
        if (!completedDateED_) {
            [NSException raise:NSInternalInconsistencyException format:@"CompletedDate Entity not found in MOC"];
        }        
    }
    
    return completedDateED_;
}

- (NSEntityDescription *) platformEntityDescription
{
    if (!platformED_) {
        platformED_ = [NSEntityDescription entityForName:@"Platform" inManagedObjectContext:moc_];
        if (!platformED_) {
            [NSException raise:NSInternalInconsistencyException format:@"Platform Entity not found in MOC"];
        }        
    }
    
    return platformED_;
}

- (NSEntityDescription *) authorEntityDescription
{
    if (!authorED_) {
        authorED_ = [NSEntityDescription entityForName:@"Author" inManagedObjectContext:moc_];
        if (!authorED_) {
            [NSException raise:NSInternalInconsistencyException format:@"Author Entity not found in MOC"];
        }        
    }
    
    return authorED_;
}

- (NSEntityDescription *) linkEntityDescription
{
    if (!linkED_) {
        linkED_ = [NSEntityDescription entityForName:@"Link" inManagedObjectContext:moc_];
        if (!linkED_) {
            [NSException raise:NSInternalInconsistencyException format:@"Link Entity not found in MOC"];
        }        
    }
    
    return linkED_;
}

- (NSEntityDescription *) genreEntityDescription
{
    if (!genreED_) {
        genreED_ = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:moc_];
        if (!genreED_) {
            [NSException raise:NSInternalInconsistencyException format:@"Genre Entity not found in MOC"];
        }        
    }
    
    return genreED_;
}


#pragma mark - Entity instance

- (Game *) newGame
{
    return [[[Game alloc] initWithEntity:self.gameEntityDescription insertIntoManagedObjectContext:nil] autorelease];
}

- (Game *) newGameInContext
{
    return [[[Game alloc] initWithEntity:self.gameEntityDescription insertIntoManagedObjectContext:moc_] autorelease];
}

- (CompletedDate *) newCompletedDate
{
    return [[[CompletedDate alloc] initWithEntity:self.completedDateEntityDescription insertIntoManagedObjectContext:nil] autorelease];
}

- (Platform *) newPlatform
{
    return [[[Platform alloc] initWithEntity:self.platformEntityDescription insertIntoManagedObjectContext:nil] autorelease];
}

- (Author *) newAuthor
{
    return [[[Author alloc] initWithEntity:self.authorEntityDescription insertIntoManagedObjectContext:nil] autorelease];
}

- (Link *) newLink
{
    return [[[Link alloc] initWithEntity:self.linkEntityDescription insertIntoManagedObjectContext:nil] autorelease];
}

- (Genre *) newGenre
{
    return [[[Genre alloc] initWithEntity:self.genreEntityDescription insertIntoManagedObjectContext:nil] autorelease];
}


#pragma mark - Default entities

- (Genre *) defaultGenre
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self genreEntityDescription]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isSystem = %@", [NSNumber numberWithBool:YES]]];
    
    NSError * errors;
    NSArray * result = [self.MOC executeFetchRequest:fetchRequest error:&errors];
    if (!result) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot execute fetch query for Default Platform: %@", [errors description]];
    }
    
    if ([result count] <= 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot find Default Genre"];
    }
    
    return (Genre *) [result objectAtIndex:0];
}

- (Author *) defaultAuthor
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self authorEntityDescription]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isSystem = %@", [NSNumber numberWithBool:YES]]];
    
    NSError * errors;
    NSArray * result = [self.MOC executeFetchRequest:fetchRequest error:&errors];
    if (!result) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot execute fetch query for Default Author: %@", [errors description]];
    }
    
    if ([result count] <= 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot find Default Author"];
    }
    
    return (Author *) [result objectAtIndex:0];
}

- (Platform *) defaultPlatform
{
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[self platformEntityDescription]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isSystem = %@", [NSNumber numberWithBool:YES]]];
    
    NSError * errors;
    NSArray * result = [self.MOC executeFetchRequest:fetchRequest error:&errors];
    if (!result) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot execute fetch query for Default Platform: %@", [errors description]];
    }
    
    if ([result count] <= 0) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot find Default Platform"];
    }
    
    return (Platform *) [result objectAtIndex:0];
}


@end
