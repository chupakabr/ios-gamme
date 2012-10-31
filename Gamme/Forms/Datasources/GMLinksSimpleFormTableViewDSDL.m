//
//  GMLinksSimpleFormTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/3/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMLinksSimpleFormTableViewDSDL.h"
#import "GMAddLinkFormController.h"
#import "GMLog.h"

@implementation GMLinksSimpleFormTableViewDSDL

- (id)initWithResultKey:(NSString *)resultDataKey andData:(NSSet *)data
{
    self = [super initWithResultKey:resultDataKey];
    if (self) {
        if (data) {
            updatedData_ = [data mutableCopy];
        }
        else {
            updatedData_ = [[NSMutableSet alloc] init];
        }
    }
    
    return self;
}

- (void) dealloc
{
    [updatedData_ release];
    [super dealloc];
}


#pragma mark - Abstract methods impl

- (NSString *) getTitleForModel:(NSManagedObject *)obj
{
    if (![obj isKindOfClass:[Link class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid Link object of type %@", [obj class]];
    }
    
    return [(Link *) obj title];
}

- (NSString *) getDetailForModel:(NSManagedObject *)obj
{
    if (![obj isKindOfClass:[Link class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid Link object of type %@", [obj class]];
    }
    
    return [(Link *) obj url];
}

- (NSArray *) getData_:(BOOL)refresh
{
    if (!data_ || refresh) {
        for (NSManagedObject * obj in [updatedData_ allObjects]) {
            if (![self getTitleForModel:obj] || ![self getDetailForModel:obj]) {
                [updatedData_ removeObject:obj];
            }
        }
        
        [data_ release];
        data_ = [[updatedData_ allObjects] copy];
    }
    
    return data_;
}

- (GMAbstractFormController *) createEditFormControllerForSelectedData:(NSManagedObject *)selectedData
{
    if (selectedData != nil && ![selectedData isKindOfClass:[Link class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid selectedData object of type %@", [selectedData class]];
    }
    
    if (selectedData == nil) {
        GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
        selectedData = [ph newLink];
        [updatedData_ addObject:selectedData];
    }
    
    return [[[GMAddLinkFormController alloc] initWithNibName:[GMNib getNibName:@"GMCommonFormTableViewController"] bundle:nil andModel:(Link *)selectedData] autorelease];
}

- (void) deleteSelectedData:(NSObject *)obj
{
    [updatedData_ removeObject:obj];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject * selectedData = [self getDataAtIndex_:[indexPath row]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[(Link *)selectedData url]]];
}

// Specific
- (void) applyNewData
{
    GMLog(@"GMLinksSimpleFormTableViewDSDL - applyNewData() with size %d", [updatedData_ count]);
    
    [parentController_ setOutgoingResultData:updatedData_ forKey:[self resultDataKey]];
    [parentController_ setOutgoingResultData:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%@_set", [self resultDataKey]]];
}

@end
