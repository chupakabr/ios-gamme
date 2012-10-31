//
//  GMGenresPlotDS.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/26/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMGenresPlotDS.h"

@implementation GMGenresPlotDS

#pragma mark - Abstract impl

- (NSArray *) loadData
{
#warning TODO
    // TODO Get data from DB
    
    return [[NSArray alloc] initWithObjects:[GMPlotPoint plotPointWithX:2002 andY:24],
            [GMPlotPoint plotPointWithX:2003 andY:34],
            [GMPlotPoint plotPointWithX:2004 andY:14],
            [GMPlotPoint plotPointWithX:2005 andY:8],
            [GMPlotPoint plotPointWithX:2006 andY:0],
            [GMPlotPoint plotPointWithX:2007 andY:70],
            [GMPlotPoint plotPointWithX:2008 andY:10],
            [GMPlotPoint plotPointWithX:2009 andY:45],
            [GMPlotPoint plotPointWithX:2010 andY:25],
            [GMPlotPoint plotPointWithX:2011 andY:10],
            nil];
}

@end
