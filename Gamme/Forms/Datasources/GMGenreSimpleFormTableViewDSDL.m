//
//  GMGenreSimpleFormTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMGenreSimpleFormTableViewDSDL.h"
#import "GMAddGenreFormController.h"

@implementation GMGenreSimpleFormTableViewDSDL

- (NSString *) getTitleForModel:(NSManagedObject *)obj
{
    if (![obj isKindOfClass:[Genre class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid Genre object of type %@", [obj class]];
    }
    
    return [(Genre *) obj title];
}

- (NSFetchRequest *) getFetchRequest
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[ph genreEntityDescription]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    
    return fetchRequest;
}

- (GMAbstractFormController *) createEditFormControllerForSelectedData:(NSManagedObject *)selectedData
{
    if (selectedData != nil && ![selectedData isKindOfClass:[Genre class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid selectedData object of type %@", [selectedData class]];
    }
    
    return [[[GMAddGenreFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil andModel:(Genre *)selectedData] autorelease];
}

@end
