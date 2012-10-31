//
//  GMPlatformSimpleFormTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/2/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMPlatformSimpleFormTableViewDSDL.h"
#import "GMAddPlatformFormController.h"

@implementation GMPlatformSimpleFormTableViewDSDL

- (NSString *) getTitleForModel:(NSManagedObject *)obj
{
    if (![obj isKindOfClass:[Platform class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid Platform object of type %@", [obj class]];
    }
    
    return [(Platform *) obj title];
}

- (NSFetchRequest *) getFetchRequest
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[ph platformEntityDescription]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    
    return fetchRequest;
}

- (GMAbstractFormController *) createEditFormControllerForSelectedData:(NSManagedObject *)selectedData
{
    if (selectedData != nil && ![selectedData isKindOfClass:[Platform class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid selectedData object of type %@", [selectedData class]];
    }
    
    GMAddPlatformFormController * controller = [[[GMAddPlatformFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil andModel:(Platform *)selectedData] autorelease];
//    [controller setCanCreate:NO];
//    [controller setCanDelete:NO];
    
    return controller;
}


@end
