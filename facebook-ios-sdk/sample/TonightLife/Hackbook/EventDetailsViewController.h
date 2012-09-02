/**
 *  EventDetailsViewController.h
 *
 *  Created on: August 27, 2012
 *      Author: Valeri Karpov
 *      
 *  Controller for EventDetailsView.xib
 *  
 */

#import <UIKit/UIKit.h>
#import "RadarCommonController.h"
#import "RadarMapViewController.h"
#import "Event.h"

@interface EventDetailsViewController : UIViewController {
    Event* event;
    UIImageView* imgView;
    NSString* tonightlifeToken;
    RadarCommonController* commonController;
    NSMutableDictionary* imageCache;
}

-(EventDetailsViewController*) initEventDetailsView:(Event*) e :(NSMutableDictionary*) imageCache :(NSString*) token :(RadarCommonController*) common;

-(void) onLocateClicked:(id) sender;
-(void) onRsvpClicked:(id) sender;

@property (nonatomic, retain) IBOutlet UITextView* eventTitleOutlet;
@property (nonatomic, retain) IBOutlet UITextView* eventDescriptionOutlet;
@property (nonatomic, retain) IBOutlet UIView* imageWrapperOutlet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* addToLineupButtonOutlet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* locateButtonOutlet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* rsvpButtonOutlet;

@end
