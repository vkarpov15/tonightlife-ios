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
#import <AVFoundation/AVFoundation.h>
#import "MapViewLauncherDelegate.h"
#import "RadarCommonController.h"
#import "RadarMapViewController.h"
#import "ImageCacheController.h"
#import "Event.h"
#import "FriendsList.h"

@interface EventDetailsViewController : UIViewController {
    Event* event;
    UIImageView* imgView;
    NSString* tonightlifeToken;
    RadarCommonController* commonController;
    ImageCacheController* imageCache;
    id <MapViewLauncherDelegate> mapViewLauncher;
    
    AVAudioPlayer* audioPlayer;
    bool playing;
    bool readyToPlay;
}


-(EventDetailsViewController*) initEventDetailsView:(Event*) e :(ImageCacheController*) imageCache :(NSString*) token :(RadarCommonController*) common: (id <MapViewLauncherDelegate>) delegate;

-(void) onLocateClicked:(id) sender;
-(void) onRsvpClicked:(id) sender;
-(void) startPlaying;

@property (nonatomic, retain) IBOutlet UITextView* eventTitleOutlet;
@property (nonatomic, retain) IBOutlet UITextView* eventStartTimeOutlet;
@property (nonatomic, retain) IBOutlet UITextView* eventDescriptionOutlet;
@property (nonatomic, retain) IBOutlet UIView* imageWrapperOutlet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* addToLineupButtonOutlet;
@property (nonatomic, retain) IBOutlet UIBarItem* addToLineupBarItemOutlet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* locateButtonOutlet;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* rsvpButtonOutlet;
@property (nonatomic, retain) IBOutlet UIView* friendsList;
@property (nonatomic, retain) IBOutlet UILabel* eventCover;
@property (nonatomic, retain) IBOutlet UIButton* playButtonOutlet;
@property (nonatomic, retain) IBOutlet UISlider* aSlider;
@property (nonatomic, retain) NSTimer* timer;


//@property (nonatomic, retain) IBOutlet UILabel* sliderTimer;


-(IBAction) displayFriendsListView:(id)sender;

-(IBAction) playPauseBtnClicked:(id) sender;

-(IBAction)slide:(id)sender;

- (IBAction)sliderChanged:(UISlider *)sender;

@end
