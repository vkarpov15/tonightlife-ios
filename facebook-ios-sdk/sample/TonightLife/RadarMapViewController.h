/**
 *  RadarMapViewController.h
 *
 *  Created on: August 28, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for displaying events on a map with RadarMapView.xib layout
 *  
 */

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Event.h"
#import "RadarCommonController.h"
#import "TonightlifeMarker.h"
#import "EventDetailsViewController.h"

@interface RadarMapViewController : UIViewController <MKMapViewDelegate> {
    RadarCommonController* commonController;
    Event* selectedEvent;
    NSString* tonightlifeToken;
    NSMutableDictionary* imageCache;
    
    UIView* header;
    UITabBar* tabs;
}

-(RadarMapViewController*) initWithCommonController: (RadarCommonController*) common: (NSString*) token: (NSMutableDictionary*) cache;

-(void) setHeaderViewAndTabs: (UIView*) header: (UITabBar*) tabs;

-(void) setSelectedEvent: (Event*) e;

-(void)viewWillAppear: (BOOL)animated;

-(void) onAnnotationClicked: (UIButton*) sender;

@property (nonatomic, retain) IBOutlet MKMapView* mapViewOutlet;

@end
