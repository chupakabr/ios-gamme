//
//  GMBarGraph.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 2/26/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "GMAbstractPlotDS.h"

@interface GMBarGraph : CPTXYGraph
{
@protected
    GMAbstractPlotDS * ds_;
}

- (id) initWithFrame:(CGRect)newFrame DS:(GMAbstractPlotDS *)ds;

@end
