//
//  EventDetailsPageViewController.h
//  TonightLife
//
//  Created by Diego Netto on 9/21/12.
//  Copyright (c) 2012 Tabbie, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadarCommonController.h"
#import "RadarMapViewController.h"
#import "ImageCacheController.h"
#import "Event.h"
#import "MapViewLauncherDelegate.h"

@interface EventDetailsPageViewController : UIViewController <UIScrollViewDelegate, MapViewLauncherDelegate> {
    ImageCacheController* imageCache;
    RadarCommonController* commonController;
    NSString* tonightlifeToken;
    BOOL pageControlUsed;
    NSUInteger initPage;
    
    NSMutableArray* eventDetailsViews;
}

- (void) dealloc;

- (EventDetailsPageViewController*) initEventDetailsPageView:(NSUInteger) eventIndex :(ImageCacheController*) cache :(NSString*)token :(RadarCommonController*) common;

- (void) launchMapViewWithEvent: (Event*) e;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

@end
