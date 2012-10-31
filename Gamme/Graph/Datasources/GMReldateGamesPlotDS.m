//
//  GMReldateGamesPlotDS.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/26/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMReldateGamesPlotDS.h"

@implementation GMReldateGamesPlotDS

#pragma mark - Abstract impl

- (NSArray *) loadData
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[ph gameEntityDescription]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"releaseDate != nil"]];
    
    NSMutableArray * result = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary * tmpData = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray * reqResult = [[ph MOC] executeFetchRequest:fetchRequest error:nil];
    if (reqResult && [reqResult count] > 0)
    {
        for (Game * game in reqResult) {
            
            NSDateComponents * components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[game releaseDate]];
            NSNumber * year = [NSNumber numberWithInt:[components year]];
            
            NSNumber * val = [tmpData objectForKey:year];
            if (val == nil) {
                [tmpData setObject:[NSNumber numberWithInt:1] forKey:year];
            }
            else {
                [tmpData setObject:[NSNumber numberWithInt:([val intValue]+1)] forKey:year];
            }
        }
        
        NSArray * sortedKeys = [tmpData keysSortedByValueUsingComparator:^(NSNumber * obj1, NSNumber * obj2) {
            
            if ([obj1 intValue] > [obj2 intValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            
            if ([obj1 intValue] < [obj2 intValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        NSInteger prevNum = [[sortedKeys objectAtIndex:0] intValue];
        for (NSNumber * key in sortedKeys) {
            
            NSInteger curNum = [key intValue];
            for (prevNum = prevNum-1; prevNum >= curNum; prevNum--) {
                GMPlotPoint * pp = [[[GMPlotPoint alloc] initWithX:prevNum andY:0] autorelease];
                [result addObject:pp];
            }
            
            GMPlotPoint * pp = [[[GMPlotPoint alloc] initWithX:[key intValue]
                                                          andY:[[tmpData objectForKey:key] intValue]]
                                autorelease];
            [result addObject:pp];
        }
    }
    
    return result;
}

@end