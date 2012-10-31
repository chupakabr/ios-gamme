//
//  Game.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/27/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "Game.h"
#import "Author.h"
#import "CompletedDate.h"
#import "Genre.h"
#import "Link.h"
#import "Platform.h"


@implementation Game

@dynamic addedDate;
@dynamic inProgressDate;
@dynamic notes;
@dynamic plannedTillDate;
@dynamic rating;
@dynamic releaseDate;
@dynamic state;
@dynamic title;
@dynamic author;
@dynamic genre;
@dynamic links;
@dynamic platform;
@dynamic completedDates;


- (NSString *) description
{
    return [NSString stringWithFormat:@"Game: addedDate(%@) inProgressDate(%@) notes(%@) plannedTillDate(%@)"
                                      " rating(%@) releaseDate(%@) state(%@) title(%@) author(%@)"
                                      " genre(%@) platform(%@)",
                self.addedDate, self.inProgressDate, self.notes, self.plannedTillDate,
                self.rating, self.releaseDate, self.state, self.title, self.author,
                self.genre, self.platform];
}


#pragma mark - My custom huerga

- (void) prepareAndUpdateLinks:(NSSet *)values
{
    NSManagedObjectContext * moc = self.managedObjectContext;
    
    if (moc) {
        
        // Update existing values
        
        for (Link * lnk in values) {
            if (![[self links] containsObject:lnk]) {
                [moc insertObject:lnk];
            }
        }
        
        for (Link * lnk in [self links]) {
            if (![values containsObject:lnk]) {
                [moc deleteObject:lnk];
            }
        }
    }
    
    [self addLinks:values];
}

- (void) prepareAndUpdateCompletedDates:(NSSet *)values
{
    NSManagedObjectContext * moc = self.managedObjectContext;
    
    if (moc) {
        
        // Update existing values
        
        for (CompletedDate * cd in values) {
            if (![[self completedDates] containsObject:cd]) {
                [moc insertObject:cd];
            }
        }
        
        for (CompletedDate * cd in [self completedDates]) {
            if (![values containsObject:cd]) {
                [moc deleteObject:cd];
            }
        }
    }
    
    [self addCompletedDates:values];
}

@end
