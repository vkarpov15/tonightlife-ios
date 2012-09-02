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

@interface RadarMapViewController : UIViewController <MKMapViewDelegate> {
    RadarCommonController* commonController;
    Event* selectedEvent;
}

-(RadarMapViewController*) initWithCommonController: (RadarCommonController*) common;

//-(void) setSelectedEvent: (Event*) e;

- (void) onAnnotationClicked:(UIButton*) sender;

@property (nonatomic, retain) IBOutlet MKMapView* mapViewOutlet;

@end
