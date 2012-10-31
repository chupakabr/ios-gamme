//
//  GMGamesTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/19/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMGamesTableViewDSDL.h"
#import "GMGameInfoViewController.h"
#import "GMLog.h"

@implementation GMGamesTableViewDSDL

- (id)initWithModel:(NSManagedObject *)model
{
    GMLog(@"GMGamesTableViewDSDL - initWithModel()");
    
    self = [super init];
    if (self) {
        model_ = [model retain];
    }
    
    return self;
}

- (void) dealloc
{
    [model_ release];
    [super dealloc];
}


- (NSString *) getTitleForModel:(NSManagedObject *)obj
{
    if (![obj isKindOfClass:[Game class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid Game object of type %@", [obj class]];
    }
    
    return [(Game *) obj title];
}

- (NSString *) getDetailForModel:(NSManagedObject *)obj
{
    Game * game = (Game *) obj;
    NSMutableString * detail = [NSMutableString string];
    
    // Genre
    if ([game genre]) {
        [detail appendFormat:@"%@ ", [[game genre] title]];
    }
    
    // Platform
    [detail appendFormat:@"%@ %@", NSLocalizedString(@"on", nil), [[game platform] title]];
    
    // Author
    if ([game author]) {
        [detail appendFormat:@" %@ %@", NSLocalizedString(@"by", nil), [[game author] title]];
    }
    
    return detail;
}

- (NSFetchRequest *) getFetchRequest
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    [fetchRequest setEntity:[ph gameEntityDescription]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    
    if ([model_ isKindOfClass:[Platform class]]) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"platform = %@", model_]];
    }
    else if ([model_ isKindOfClass:[Author class]]) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"author = %@", model_]];
    }
    else if ([model_ isKindOfClass:[Genre class]]) {
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"genre = %@", model_]];
    }
    
    return fetchRequest;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Game * game = (Game *) [self getDataAtIndex_:indexPath.row];
    
    GMGameInfoViewController * controller = [[GMGameInfoViewController alloc] initWithModel:game];
    [self.parentController.navigationController pushViewController:controller animated:YES];
}


@end
