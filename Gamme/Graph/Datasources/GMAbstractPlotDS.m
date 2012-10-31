//
//  GMAbstractPlotDS.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/26/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAbstractPlotDS.h"

@implementation GMAbstractPlotDS

- (id) init
{
    self = [super init];
    if (self) {
        data_ = [[self loadData] retain];
    }
    
    return self;
}

- (void) dealloc
{
    [data_ release];
    [super dealloc];
}


#pragma mark - Abstract

- (NSArray *) loadData
{
    [NSException raise:NSInternalInconsistencyException format:@"loadData() must be implemented in child"];
    return nil;
}


#pragma mark - Getters

- (BOOL) hasData
{
    return ([data_ count] > 0);
}

- (CPTPlotRange *) xRange
{
    if ([data_ count] <= 0) {
        return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(0)];
    }
    
    NSInteger minVal = [(GMPlotPoint *) [data_ objectAtIndex:0] x];
    NSInteger maxVal = [(GMPlotPoint *) [data_ objectAtIndex:0] x];
    
    for (GMPlotPoint * pp in data_) {
        if (pp.x < minVal) {
            minVal = pp.x;
        }
        else if (pp.x > maxVal) {
            maxVal = pp.x;
        }
    }
    
    GMLog(@"X RANGE MIN(%d) MAX(%d) COUNT(%d)", minVal, maxVal, [data_ count]);
    
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(minVal-GM_PLOT_PADDING)
                                        length:CPTDecimalFromInt(maxVal-minVal+GM_PLOT_PADDING*2)];
}

- (CPTPlotRange *) yRange
{
    if ([data_ count] <= 0) {
        return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0) length:CPTDecimalFromInt(0)];
    }
    
    NSInteger minVal = [(GMPlotPoint *) [data_ objectAtIndex:0] y];
    NSInteger maxVal = [(GMPlotPoint *) [data_ objectAtIndex:0] y];
    
    for (GMPlotPoint * pp in data_) {
        if (pp.y < minVal) {
            minVal = pp.y;
        }
        else if (pp.y > maxVal) {
            maxVal = pp.y;
        }
    }
    
    GMLog(@"Y RANGE MIN(%d) MAX(%d) COUNT(%d)", minVal, maxVal, [data_ count]);
    
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(0)
                                        length:CPTDecimalFromInt(maxVal+GM_PLOT_PADDING+GM_PLOT_LABEL_OFFSET)];
}


#pragma mark - CPTPlotDataSource impl

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [data_ count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
    switch (fieldEnum) {
        case CPTScatterPlotFieldX:
            return [(GMPlotPoint *) [data_ objectAtIndex:index] xNumber];
        case CPTScatterPlotFieldY:
            return [(GMPlotPoint *) [data_ objectAtIndex:index] yNumber];
    }
    
    return nil;
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
    NSInteger val = [(GMPlotPoint *) [data_ objectAtIndex:index] y];
    
    if (val <= 0) {
        return nil;
    }
    
    CPTMutableTextStyle * style = [CPTMutableTextStyle textStyle];
    style.color = [CPTColor whiteColor];
    
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%d", val]];
    [textLayer setTextStyle:style];
    
    return textLayer;
}


@end
