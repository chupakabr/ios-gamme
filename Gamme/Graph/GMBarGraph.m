//
//  GMBarGraph.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/26/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMBarGraph.h"

@implementation GMBarGraph

- (id) initWithFrame:(CGRect)newFrame DS:(GMAbstractPlotDS *)ds
{
    self = [super initWithFrame:newFrame];
    if (self)
    {
//        [self applyTheme:[CPTTheme themeNamed:kCPTDarkGradientTheme]];
        self.backgroundColor = [[UIColor clearColor] CGColor];
        self.paddingLeft = 10.0;
        self.paddingTop = 0.0;
        self.paddingRight = 10.0;
        self.paddingBottom = 0.0;
        self.plotAreaFrame.paddingLeft = 15.0;
        self.plotAreaFrame.paddingTop = 5.0;
        self.plotAreaFrame.paddingRight = 15.0;
        self.plotAreaFrame.paddingBottom = 30.0;
        
        
        // DS
        ds_ = [ds retain];
        
        // Plot
        CPTBarPlot * plot = [[[CPTBarPlot alloc] init] autorelease];
        plot.identifier = @"GMBarGraph";
        plot.dataSource = ds_;
        [self addPlot:plot];
        
        // Graph Plot space
        CPTXYPlotSpace * plotSpace = (CPTXYPlotSpace *) self.defaultPlotSpace;
        plotSpace.xRange = [ds xRange];
        plotSpace.yRange = [ds yRange];
        
        // Plot design
        CPTMutableTextStyle * textStyle = [CPTMutableTextStyle textStyle];
        textStyle.color = [CPTColor whiteColor];
        
        CPTMutableLineStyle * style = [CPTMutableLineStyle lineStyle];
        style.lineColor = [CPTColor whiteColor];
        style.lineWidth = 1.0f;
        
        CPTGradient * fillGradient = [CPTGradient gradientWithBeginningColor:[CPTColor greenColor] endingColor:[CPTColor blackColor]];
        fillGradient.angle = 0.0;
        [plot setFill:[CPTFill fillWithGradient:fillGradient]];
        
//        CPTPlotSymbol * plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
//        plotSymbol.fill = [CPTFill fillWithColor:[CPTColor greenColor]];
//        plotSymbol.size = CGSizeMake(4.0, 4.0);
//        
//        CPTMutableLineStyle *symbolLineStyle = [[plotSymbol.lineStyle mutableCopy] autorelease];
//        symbolLineStyle.lineColor = [CPTColor greenColor];
//        symbolLineStyle.lineWidth = 2.f;
//        plotSymbol.lineStyle = symbolLineStyle;
        
//        CPTGradient *areaGradient = 
//        [CPTGradient gradientWithBeginningColor:[CPTColor greenColor] 
//                                    endingColor:[CPTColor blackColor]];
//        areaGradient.angle = -90.0f;
//        plot.areaFill = [CPTFill fillWithGradient:areaGradient];
//        plot.areaBaseValue = CPTDecimalFromString(@"0");        
        
//        [plot setPlotSymbol:plotSymbol];
        
        // XY Axis
        CPTXYAxisSet * axisSet = (CPTXYAxisSet *) self.axisSet;
        CPTXYAxis * x = axisSet.xAxis;
        x.minorTicksPerInterval = 4;
        x.minorTickLength = 2.0f;
        x.minorTickLineStyle = style;
        x.majorIntervalLength = CPTDecimalFromInt(5);
        x.majorTickLineStyle = style;
        x.majorTickLength = 4.0f;
        x.axisLineStyle = style;
        x.labelOffset = 5.0f;
        x.labelTextStyle = textStyle;
        x.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
        
        NSNumberFormatter * formatter = [[[NSNumberFormatter alloc] init] autorelease];
        [formatter setFormatWidth:0];
        x.labelFormatter = formatter;
    }
    
    return self;
}

- (void) dealloc
{
    [ds_ release];
    [super dealloc];
}

@end
