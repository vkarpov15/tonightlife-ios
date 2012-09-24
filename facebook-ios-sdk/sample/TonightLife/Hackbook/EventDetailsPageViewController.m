//
//  EventDetailsPageViewController.m
//  TonightLife
//
//  Created by Diego Netto on 9/21/12.
//  Copyright (c) 2012 Tabbie, Inc. All rights reserved.
//

#import "EventDetailsPageViewController.h"

@implementation EventDetailsPageViewController

@synthesize scrollView;
@synthesize pageControl;

- (void) dealloc {
    [pageControl release];
    [scrollView release];
    for (NSUInteger i = 0; i < [eventDetailsViews count]; ++i) {
        if (nil != [eventDetailsViews objectAtIndex:i]) {
            [[eventDetailsViews objectAtIndex:i] release];
        }
    }
    [eventDetailsViews release];
    [super dealloc];
}

- (EventDetailsPageViewController*) initEventDetailsPageView:(NSUInteger) eventIndex :(ImageCacheController*) cache :(NSString *)token :(RadarCommonController*) common {
    self = [super initWithNibName:@"EventDetailsPageViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        imageCache = [cache retain];
        tonightlifeToken = [token retain];
        commonController = [common retain];
        initPage = eventIndex;
        
        eventDetailsViews = [[NSMutableArray alloc] initWithCapacity:25];
        for (NSUInteger i = 0; i < [[commonController eventsList] count]; ++i) {
            [eventDetailsViews addObject:[[EventDetailsViewController alloc] initEventDetailsView:[[commonController eventsList] objectAtIndex:i] :imageCache :tonightlifeToken :commonController :self]];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Event Details";
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ios_app_header.png"] forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    pageControl.numberOfPages = [[commonController eventsList] count];
    pageControl.currentPage = initPage;
    
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * pageControl.numberOfPages, 1);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    pageControlUsed = NO;
    
    if (initPage > 0) {
        [self loadScrollViewWithPage:initPage - 1];
    }
    [self loadScrollViewWithPage:initPage];
    [self loadScrollViewWithPage:initPage + 1];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * initPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
}

- (void)loadScrollViewWithPage:(NSUInteger)page {
    if (page >= [[commonController eventsList] count]) {
        return;
    }
    
    EventDetailsViewController* eventDetails = [eventDetailsViews objectAtIndex:page];
    
    if (nil == eventDetails.view.superview) {
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        eventDetails.view.frame = frame;
        [scrollView addSubview:eventDetails.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    if (pageControlUsed) {
        return;
    }
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (IBAction)changePage:(id)sender {
    int page = pageControl.currentPage;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) launchMapViewWithEvent: (Event*) e {
    RadarMapViewController* mapViewController = [[RadarMapViewController alloc] initWithCommonController:commonController: tonightlifeToken: imageCache];
    [mapViewController setSelectedEvent:e];
    [self.navigationController pushViewController:mapViewController animated:NO];
    [mapViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
