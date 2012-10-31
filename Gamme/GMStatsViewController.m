//
//  GMStatsViewController.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMStatsViewController.h"
#import "GMCompletedGamesPlotDS.h"
#import "GMReldateGamesPlotDS.h"
#import "GMGenresPlotDS.h"
#import "GMBarGraph.h"
#import "GMLog.h"

#define GM_CHART_IDX_COMPLETED 0
#define GM_CHART_IDX_RELDATE 1

#define GM_FIRST_PAGE GM_CHART_IDX_COMPLETED
#define GM_LAST_PAGE GM_CHART_IDX_RELDATE

#define GM_CHART_NAME_COMPLETED NSLocalizedString(@"Games completed by year", nil)
#define GM_CHART_NAME_RELDATE NSLocalizedString(@"Games count by release year", nil)

@implementation GMStatsViewController

@synthesize navBarItem = _navBarItem;
@synthesize nameLabel = _nameLabel;
@synthesize noDataLabel = _noDataLabel;
@synthesize pageControl = _pageControl;
@synthesize chartView = _chartView;
@synthesize graph = _graph;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    GMLog(@"GMStatsViewController - initWithNibName()");
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Stats", @"Stats");
        self.tabBarItem.image = [UIImage imageNamed:@"tab-stats"];
    }
    return self;
}

- (void) dealloc
{
    self.graph = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    GMLog(@"GMStatsViewController - didReceiveMemoryWarning()");
    
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    GMLog(@"GMStatsViewController - viewDidLoad()");
    
    [super viewDidLoad];
    
    //
	// UI set up
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[GMNib getBgImageName]]];
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.pageControl.backgroundColor = [UIColor clearColor];
    self.chartView.backgroundColor = [UIColor clearColor];
    
    [self.navBarItem setTitle:NSLocalizedString(@"Stats", nil)];
    [self.nameLabel setText:GM_CHART_NAME_COMPLETED];
    
    [self.noDataLabel setText:NSLocalizedString(@"No data", nil)];
    [self.noDataLabel setBackgroundColor:[UIColor clearColor]];
    [self.noDataLabel setFont:[UIFont fontWithName:@"helvetica" size:36]];
    [self.noDataLabel setTextColor:[UIColor colorWithRed:1.0 green:(CGFloat)63/255 blue:(CGFloat)63/255 alpha:1.0]];
    
    [self.pageControl setNumberOfPages:GM_LAST_PAGE+1];
    [self.pageControl setCurrentPage:GM_FIRST_PAGE];
    
    
    //
    // Init gestures
    
    UISwipeGestureRecognizer * swipeLeft = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)] autorelease];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.pageControl addGestureRecognizer:swipeLeft];
    [self.chartView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer * swipeRight = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)] autorelease];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.pageControl addGestureRecognizer:swipeRight];    
    [self.chartView addGestureRecognizer:swipeRight];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Unset BG
    self.view.backgroundColor = nil;
    
    // Release resources
    self.nameLabel = nil;
    self.noDataLabel = nil;
    self.pageControl = nil;
    self.navBarItem = nil;
    
    // Release charts
    self.chartView = nil;
    self.graph = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Redraw current chart
    [self redrawCurrentChart];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Swipe Gestures

- (void) swipeLeft:(id)sender
{
    NSInteger curPage = [self.pageControl currentPage];
    NSInteger nextPage;
    
    if (curPage == GM_LAST_PAGE) {
        nextPage = GM_FIRST_PAGE;
    } else {
        nextPage = curPage + 1;
    }
    [self.pageControl setCurrentPage:nextPage];
    
    // Change chart
    [self changeChart:nextPage];
}

- (void) swipeRight:(id)sender
{
    NSInteger curPage = [self.pageControl currentPage];
    NSInteger nextPage;
    
    if (curPage == GM_FIRST_PAGE) {
        nextPage = GM_LAST_PAGE;
    } else {
        nextPage = curPage - 1;
    }
    [self.pageControl setCurrentPage:nextPage];
    
    // Change chart
    [self changeChart:nextPage];
}


#pragma mark - Chart impl

- (int) currentChartIdx
{
    return [self.pageControl currentPage];
}

- (void) changeChart:(int)chartIdx
{
    GMLog(@"Stats - changeChart() to %d", chartIdx);
    
    //
    // Change chart label
    
    switch (chartIdx) {
        case GM_CHART_IDX_RELDATE:
            [self.nameLabel setText:GM_CHART_NAME_RELDATE];
            break;
            
        case GM_CHART_IDX_COMPLETED:
        default:
            [self.nameLabel setText:GM_CHART_NAME_COMPLETED];
            break;
    }
    
    [self redrawCurrentChart];
}

- (void) redrawCurrentChart
{
    int curChartIdx = [self currentChartIdx];
    GMLog(@"Stats - redrawCurrentChart(%d)", curChartIdx);
    
    
    //
    // Release current chart data
    
    self.chartView.hostedGraph = nil;
    self.graph = nil;
    
    
    //
    // Create & Display a chart
    
    switch (curChartIdx) {
        
        case GM_CHART_IDX_RELDATE:
        {
            GMReldateGamesPlotDS * ds = [[[GMReldateGamesPlotDS alloc] init] autorelease];
            if ([ds hasData]) {
                self.noDataLabel.hidden = YES;
                
                self.graph = [[[GMBarGraph alloc] initWithFrame:self.chartView.frame DS:ds] autorelease];
                self.chartView.hostedGraph = self.graph;
            }
            else {
                self.noDataLabel.hidden = NO;
            }
            break;
        }
        
        case GM_CHART_IDX_COMPLETED:
        default:
        {
            GMCompletedGamesPlotDS * ds = [[[GMCompletedGamesPlotDS alloc] init] autorelease];
            if ([ds hasData]) {
                self.noDataLabel.hidden = YES;
                
                self.graph = [[[GMBarGraph alloc] initWithFrame:self.chartView.frame DS:ds] autorelease];
                self.chartView.hostedGraph = self.graph;
            }
            else {
                self.noDataLabel.hidden = NO;
            }
            break;
        }
    }
    
}


@end
