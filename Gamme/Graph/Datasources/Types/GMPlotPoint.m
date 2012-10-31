//
//  GMPlotPoint.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/25/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMPlotPoint.h"

@implementation GMPlotPoint

@synthesize x = _x;
@synthesize y = _y;

- (NSNumber *) xNumber
{
    return [NSNumber numberWithInt:self.x];
}

- (NSNumber *) yNumber
{
    return [NSNumber numberWithInt:self.y];
}

- (id) initWithX:(NSInteger)x andY:(NSInteger)y
{
    self = [super init];
    if (self) {
        self.x = x;
        self.y = y;
    }
    
    return self;
}

+ (id) plotPointWithX:(NSInteger)x andY:(NSInteger)y
{
    return [[[GMPlotPoint alloc] initWithX:x andY:y] autorelease];
}

@end
