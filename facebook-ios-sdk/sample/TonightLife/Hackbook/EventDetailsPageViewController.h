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

@interface EventDetailsPageViewController : UIViewController <UIScrollViewDelegate> {
    ImageCacheController* imageCache;
    RadarCommonController* commonController;
    NSString* tonightlifeToken;
    BOOL pageControlUsed;
    NSUInteger initPage;
    
    NSMutableArray* eventDetailsViews;
}

- (void) dealloc;

- (EventDetailsPageViewController*) initEventDetailsPageView:(NSUInteger) eventIndex :(ImageCacheController*) cache :(NSString*)token :(RadarCommonController*) common;

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;

@end
