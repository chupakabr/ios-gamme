//
//  GMSearchGamesTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/20/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMSearchGamesTableViewDSDL.h"

@implementation GMSearchGamesTableViewDSDL

- (id)initWithTitle:(NSString *)title
{
    self = [super initWithModel:nil];
    if (self) {
        title_ = [title retain];
    }
    
    return self;
}

- (void) dealloc
{
    [title_ release];
    [super dealloc];
}

- (NSFetchRequest *) getFetchRequest
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[ph gameEntityDescription]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", title_]];
    
    return fetchRequest;
}

- (NSUInteger) resultsCount
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[ph gameEntityDescription]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", title_]];
    
    return [[ph MOC] countForFetchRequest:fetchRequest error:nil];
}

@end
