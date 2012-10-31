//
//  GMStatsViewController.h
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface GMStatsViewController : UIViewController

@property (assign, nonatomic, readwrite) IBOutlet UINavigationItem * navBarItem;
@property (assign, nonatomic, readwrite) IBOutlet UILabel * nameLabel;
@property (assign, nonatomic, readwrite) IBOutlet UILabel * noDataLabel;
@property (assign, nonatomic, readwrite) IBOutlet UIPageControl * pageControl;
@property (assign, nonatomic, readwrite) IBOutlet CPTGraphHostingView * chartView;

@property (retain, nonatomic, readwrite) CPTGraph * graph;

- (void) swipeLeft:(id)sender;
- (void) swipeRight:(id)sender;

- (int) currentChartIdx;
- (void) changeChart:(int)chartIdx;
- (void) redrawCurrentChart;

@end
