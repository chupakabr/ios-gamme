//
//  GMPlannedGamesTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/20/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMPlannedGamesTableViewDSDL.h"

@implementation GMPlannedGamesTableViewDSDL

- (NSString *) getDetailForModel:(NSManagedObject *)obj
{
    return [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Planned till", nil), [GMDate mediumDate:[(Game *) obj plannedTillDate]]];
}

- (NSFetchRequest *) getFetchRequest
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[ph gameEntityDescription]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"plannedTillDate != nil"]];
    
    return fetchRequest;
}

@end
