//
//  GMDatesSimpleFormTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/8/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMDatesSimpleFormTableViewDSDL.h"
#import "GMCompletedDateFormController.h"
#import "GMLog.h"


@implementation GMDatesSimpleFormTableViewDSDL


#pragma mark - Abstract methods impl

- (NSString *) getTitleForModel:(NSManagedObject *)obj
{
    if (![obj isKindOfClass:[CompletedDate class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid CompletedDate object of type %@", [obj class]];
    }
    
    return [NSDateFormatter localizedStringFromDate:[(CompletedDate *) obj completedDate] dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
}

- (NSString *) getDetailForModel:(NSManagedObject *)obj
{
    if (![obj isKindOfClass:[CompletedDate class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid CompletedDate object of type %@", [obj class]];
    }
    
    NSString * descr = [(CompletedDate *) obj note];
    if (descr) {
        if ([descr length] > 32) {
            descr = [NSString stringWithFormat:@"%@...", [descr substringToIndex:29]];
        }
    }
    
    return descr;
}

- (GMAbstractFormController *) createEditFormControllerForSelectedData:(NSManagedObject *)selectedData
{
    if (selectedData != nil && ![selectedData isKindOfClass:[CompletedDate class]]) {
        [NSException raise:NSInternalInconsistencyException format:@"Invalid selectedData object of type %@", [selectedData class]];
    }
    
    if (selectedData == nil) {
        GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
        selectedData = [ph newCompletedDate];
        [updatedData_ addObject:selectedData];
    }
    
    return [[[GMCompletedDateFormController alloc] initWithNibName:[GMNib getNibName:@"GMCompletedDateFormController"] bundle:nil andTitle:NSLocalizedString(@"Completed on date", nil) andValue:(CompletedDate *)selectedData andResultKey:[self resultDataKey]] autorelease];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Do nothing
}


@end
