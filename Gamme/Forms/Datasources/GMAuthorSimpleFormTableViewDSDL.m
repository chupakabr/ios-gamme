//
//  GMAuthorSimpleFormTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAuthorSimpleFormTableViewDSDL.h"
#import "GMAddAuthorFormController.h"

@implementation GMAuthorSimpleFormTableViewDSDL

- (NSString *) getTitleForModel:(NSManagedObject *)obj
{
    if (![obj isKindOfClass:[Author class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid Author object of type %@", [obj class]];
    }
    
    return [(Author *) obj title];
}

- (NSFetchRequest *) getFetchRequest
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[ph authorEntityDescription]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    
    return fetchRequest;
}

- (GMAbstractFormController *) createEditFormControllerForSelectedData:(NSManagedObject *)selectedData
{
    if (selectedData != nil && ![selectedData isKindOfClass:[Author class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid selectedData object of type %@", [selectedData class]];
    }
    
    return [[[GMAddAuthorFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil andModel:selectedData] autorelease];
}

@end
