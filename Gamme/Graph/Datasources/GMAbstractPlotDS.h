//
//  GMAbstractPlotDS.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/26/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "GMPlotPoint.h"
#import "GMLog.h"
#import "GMAppDelegate.h"

#define GM_PLOT_PADDING 1
#define GM_PLOT_LABEL_OFFSET 10.0

@interface GMAbstractPlotDS : NSObject<CPTPlotDataSource>
{
@protected
    NSArray * data_;
}

@property (assign, nonatomic, readonly) CPTPlotRange * xRange;
@property (assign, nonatomic, readonly) CPTPlotRange * yRange;
@property (assign, nonatomic, readonly) BOOL hasData;

- (NSArray *) loadData;

@end
