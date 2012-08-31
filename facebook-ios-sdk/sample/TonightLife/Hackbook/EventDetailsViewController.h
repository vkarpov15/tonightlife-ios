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
#import "Event.h"

@interface EventDetailsViewController : UIViewController {
    Event* event;
    UIImage* image;
    UIImageView* imgView;
    NSString* tonightlifeToken;
    RadarCommonController* commonController;
}

-(EventDetailsViewController*) initEventDetailsView:(Event*) e :(UIImage*) image :(NSString*) token :(RadarCommonController*) common;

@property (nonatomic, retain) IBOutlet UITextView* eventTitleOutlet;
@property (nonatomic, retain) IBOutlet UITextView* eventDescriptionOutlet;
@property (nonatomic, retain) IBOutlet UIView* imageWrapperOutlet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* addToLineupButtonOutlet;

@end
