//
//  GMPlatformNiceTableViewDSDL.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/19/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMPlatformNiceTableViewDSDL.h"
#import "GMGamesTableViewController.h"
#import "GMLog.h"

@implementation GMPlatformNiceTableViewDSDL


- (id) initWithParentController:(UIViewController *)parentController
{
    GMLog(@"GMPlatformNiceTableViewDSDL - initWithParentController()");
    
    self = [super init];
    if (self) {
        [self setParentController:parentController];
    }
    
    return self;
}


///
/// Cell rendering
///
- (void) customCellConfigaration:(UITableViewCell *)cell forRow:(NSInteger)row
{
    // UI
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    //
    // Number of games
    
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[ph gameEntityDescription]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"platform = %@", [self getDataAtIndex_:row]]];
    
    NSUInteger count = [ph countWithRequest:fetchRequest];
    [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@: %d", NSLocalizedString(@"Games", nil), count]];
}

///
/// On row selected
///
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GMLog(@"GMPlatformNiceTableViewDSDL - row selected %d", indexPath.row);
    
    NSManagedObject * selectedData = [self getDataAtIndex_:[indexPath row]];
    
    GMGamesTableViewDSDL * dsdl = [[[GMGamesTableViewDSDL alloc] initWithModel:selectedData] autorelease];
    GMGamesTableViewController * controller = [[[GMGamesTableViewController alloc] 
                                                initWithNibName:[GMNib getNibName:@"GMGamesTableViewController"] 
                                                bundle:nil 
                                                title:[(Platform *)selectedData title] 
                                                model:selectedData
                                                dsdl:dsdl
                                                ] autorelease];
    [self.parentController.navigationController pushViewController:controller animated:YES];
}


@end
