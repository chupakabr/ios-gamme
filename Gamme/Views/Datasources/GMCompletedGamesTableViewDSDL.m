//
//  GMCompletedGamesTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/20/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMCompletedGamesTableViewDSDL.h"

@implementation GMCompletedGamesTableViewDSDL

- (NSString *) getDetailForModel:(NSManagedObject *)obj
{
    NSDate * lastDate = nil;
    for (CompletedDate * cd in [(Game *) obj completedDates]) {
        if (!lastDate) {
            lastDate = [cd completedDate];
        }
        else if ([lastDate compare:[cd completedDate]] == NSOrderedAscending) {
            lastDate = [cd completedDate];
        }
    }
    
    return [NSString stringWithFormat:@"%@ %@ (%d)",
            NSLocalizedString(@"Last completed on", nil),
            [GMDate mediumDate:lastDate],
            [[(Game *) obj completedDates] count]
            ];
}

- (NSFetchRequest *) getFetchRequest
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[ph gameEntityDescription]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY completedDates.completedDate != nil"]];
    
    return fetchRequest;
}

@end
