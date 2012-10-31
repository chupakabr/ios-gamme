//
//  GMCompletedGamesPlotDS.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/25/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMCompletedGamesPlotDS.h"

@implementation GMCompletedGamesPlotDS


#pragma mark - Abstract impl

- (NSArray *) loadData
{
    GMPersistenceHelper * ph = [[GMAppDelegate instance] persistenceHelper];
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:[ph gameEntityDescription]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY completedDates.completedDate != nil"]];
    
    NSMutableArray * result = [[[NSMutableArray alloc] init] autorelease];
    NSMutableDictionary * tmpData = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray * reqResult = [[ph MOC] executeFetchRequest:fetchRequest error:nil];
    if (reqResult && [reqResult count] > 0)
    {
        for (Game * game in reqResult) {
            
            NSMutableSet * dates = [[[NSMutableSet alloc] init] autorelease];
            for (CompletedDate * date in [game completedDates]) {
                NSDateComponents * components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:[date completedDate]];
                [dates addObject:[NSNumber numberWithInt:[components year]]];
            }
            
            for (NSNumber * year in dates) {
                NSNumber * val = [tmpData objectForKey:year];
                if (val == nil) {
                    [tmpData setObject:[NSNumber numberWithInt:1] forKey:year];
                }
                else {
                    [tmpData setObject:[NSNumber numberWithInt:([val intValue]+1)] forKey:year];
                }
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
                        
            GMPlotPoint * pp = [[[GMPlotPoint alloc] initWithX:curNum
                                                          andY:[[tmpData objectForKey:key] intValue]]
                                autorelease];
            [result addObject:pp];
        }
    }
    
    return result;
    
//    return [[NSArray alloc] initWithObjects:[GMPlotPoint plotPointWithX:2002 andY:24],
//                                             [GMPlotPoint plotPointWithX:2003 andY:34],
//                                             [GMPlotPoint plotPointWithX:2004 andY:14],
//                                             [GMPlotPoint plotPointWithX:2005 andY:8],
//                                             [GMPlotPoint plotPointWithX:2006 andY:0],
//                                             [GMPlotPoint plotPointWithX:2007 andY:70],
//                                             [GMPlotPoint plotPointWithX:2008 andY:10],
//                                             [GMPlotPoint plotPointWithX:2009 andY:45],
//                                             [GMPlotPoint plotPointWithX:2010 andY:25],
//                                             [GMPlotPoint plotPointWithX:2011 andY:10],
//                                             nil];
}

@end
