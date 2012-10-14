/**
 *  EventDetailsViewController.h
 *
 *  Created on: August 27, 2012
 *      Author: Valeri Karpov
 *      
 *  Controller for EventDetailsView.xib
 *  
 */

#import "EventDetailsViewController.h"
#import "FriendsList.h"
#import <QuartzCore/QuartzCore.h>

@implementation EventDetailsViewController
@synthesize eventTitleOutlet;
@synthesize imageWrapperOutlet;
@synthesize eventDescriptionOutlet;
@synthesize addToLineupButtonOutlet;
@synthesize addToLineupBarItemOutlet;
@synthesize locateButtonOutlet;
@synthesize rsvpButtonOutlet;
@synthesize eventStartTimeOutlet;
@synthesize eventCover;
@synthesize aSlider;
@synthesize timer;
@synthesize songTime;
@synthesize listenButtonOutlet;
@synthesize audioPlayer;
@synthesize songTotalTime;


- (void)dealloc {
  if (nil != audioPlayer) {
    [audioPlayer release];
  }
  
  [eventTitleOutlet release];
  [imageWrapperOutlet release];
  [eventDescriptionOutlet release];
  [addToLineupButtonOutlet release];
  [addToLineupBarItemOutlet release];
  [locateButtonOutlet release];
  [rsvpButtonOutlet release];
  [eventStartTimeOutlet release];
  [eventCover release];
  [aSlider release];
  [listenButtonOutlet release];
  
  [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (EventDetailsViewController *) initEventDetailsView:(Event *)e
                                                    :(ImageCacheController *) cache
                                                    :(NSString *)token
                                                    :(RadarCommonController *) common
                                                    :(id <MapViewLauncherDelegate>) delegate
{
  self = [super initWithNibName:@"EventDetailsView" bundle:[NSBundle mainBundle]];
  if (self) {
    event = e;
    imageCache = cache;
    tonightlifeToken = token;
    commonController = common;
    mapViewLauncher = delegate;
    playing = NO;
    readyToPlay = NO;
    audioPlayer = nil;
    
    if ([[event audio] count] > 0) {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL* crockett = [[NSURL alloc] initWithString:@"http://api.soundcloud.com/tracks/18951694/stream?client_id=33cc81d646623d460ba86b112badf67b"];
        NSData* data = [NSData dataWithContentsOfURL:crockett];
        
        dispatch_async(dispatch_get_main_queue(), ^{
          NSError* err = nil;
          audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&err];
          if (playing) {
            [self startPlaying];
            [self.audioLoadingIndicatorOutlet stopAnimating];
            [self.audioLoadingIndicatorOutlet setHidden:YES];
          }
          readyToPlay = YES;
        });
        
      });
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.audioTitleLabelOutlet.hidden = YES;
  self.playButtonOutlet.hidden = YES;
  self.aSlider.hidden = YES;
  self.songTime.hidden = YES;
  self.audioLoadingIndicatorOutlet.hidden = YES;
  
  if ([[event audio] count] == 0) {
    // No audio - hide everything to do with it and grow
    // eventDescriptionOutlet
    self.listenButtonOutlet.hidden = YES;
    [self.eventDescriptionOutlet setFrame:CGRectMake(self.eventDescriptionOutlet.frame.origin.x,
                                                     self.eventDescriptionOutlet.frame.origin.y - self.listenButtonOutlet.frame.size.height,
                                                     self.eventDescriptionOutlet.frame.size.width,
                                                     self.eventDescriptionOutlet.frame.size.height + self.listenButtonOutlet.frame.size.height)];
  } else {
    // Have audio - pull audio name and show it
    NSMutableDictionary* audioDict;
    NSString* audioName;
    for (NSMutableDictionary* el in [event audio]) {
      // For now only care about the first
      audioDict = el;
      for (NSString* key in [el allKeys]) {
        audioName = key;
      }
      break;
    }
    [self.audioTitleLabelOutlet setText:audioName];
    [self showPlayer];
  }
  
  aSlider.value = 0;
  [aSlider setThumbImage:[UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
  [aSlider setContinuous:YES];
  
  songTime.text=@"00:00:00";
 
  

  
  self.eventTitleOutlet.text = [event name];
  self.eventStartTimeOutlet.text=[[event time] makeYourTime];
  self.eventDescriptionOutlet.text = [event description];
  if (0 == [[event cover] length]) {
    self.eventCover.text = @"Free";
  } else {
    self.eventCover.text = [event cover];
  }
  eventCover.layer.cornerRadius = 5.0;
  eventCover.clipsToBounds = YES;
  
  [self.addToLineupBarItemOutlet setImage:[UIImage imageNamed:(event->onRadar ? @"lineup_button_w.png" : @"lineup_button.png")]];
  
  
  // Initialize the event image
  imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 124)];
  imgView.contentMode = UIViewContentModeScaleAspectFill;
  [imageCache setImage:event->image :[[AsyncImageCallback alloc] initWithImageView:imgView]];
  [self.imageWrapperOutlet addSubview:imgView];
  [self.imageWrapperOutlet bringSubviewToFront:eventTitleOutlet];
  [self.imageWrapperOutlet bringSubviewToFront:eventCover];
  
  
  // Handle toolbar button clicks
  [addToLineupButtonOutlet setAction:@selector(addToLineupClicked:)];
  [locateButtonOutlet setAction:@selector(onLocateClicked:)];
  [rsvpButtonOutlet setAction:@selector(onRsvpClicked:)];
  if (nil == [[event rsvp] objectForKey:@"url"] && nil == [[event rsvp] objectForKey:@"email"]) {
    [rsvpButtonOutlet setEnabled:NO];
  } else {
    [rsvpButtonOutlet setEnabled:YES];
  }
}

- (IBAction)displayFriendsListView:(id)sender {
  [[NSBundle mainBundle] loadNibNamed:@"FriendsList" owner:self options:nil];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [imgView release];
}

- (void)viewWillDisappear:(BOOL)animated {
  if (nil != audioPlayer) {
    [self stopPlaying];
  }
  [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)addToLineupClicked:(UITapGestureRecognizer *)tapCallback {
  NSLog(@"Clicked addtolineup");
  
  if (!event->onRadar && [commonController addToLineup:event]) {
    // White star image
    [self.addToLineupBarItemOutlet setImage:[UIImage imageNamed:@"lineup_button_w.png"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      // Dispatch "add to radar" request
      NSString* url = [NSString stringWithFormat:@"http://tonight-life.com/mobile/radar/%@.json", [event eventId]];
      NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
      NSString* params = [NSString stringWithFormat:@"auth_token=%@", tonightlifeToken];
      [req setHTTPMethod:@"POST"];
      [req setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
      NSURLResponse* response = nil;
      NSError* error;
      NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
      
      NSDictionary* ret = [NSJSONSerialization JSONObjectWithData:data
                                                          options:kNilOptions
                                                            error:&error];
      
      NSLog(@"Request done %@", ret);
    });
  } else if (event->onRadar && [commonController removeFromLineup:event]) {
    // Empty star image
    [self.addToLineupBarItemOutlet setImage:[UIImage imageNamed:@"lineup_button.png"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      // Dispatch "remove from radar" request
      NSString* url = [NSString stringWithFormat:@"http://tonight-life.com/mobile/radar/%@.json?auth_token=%@", [event eventId], tonightlifeToken];
      NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
      [req setHTTPMethod:@"DELETE"];
      //[req setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
      NSURLResponse* response = nil;
      NSError* error;
      NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
      
      NSDictionary* ret = [NSJSONSerialization JSONObjectWithData:data
                                                          options:kNilOptions
                                                            error:&error];
      
      NSLog(@"Request done %@", ret);
    });
  }
}

- (void)onLocateClicked:(id)sender {
  [mapViewLauncher launchMapViewWithEvent:event];
}

- (void)onRsvpClicked:(id)sender {
  if (nil != [[event rsvp] objectForKey:@"url"]) {
    NSString* url = [[event rsvp] objectForKey:@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
  } else if (nil != [[event rsvp] objectForKey:@"email"]) {
    NSString* email = [[event rsvp] objectForKey:@"email"];
    /* create mail subject */
    NSString* subject = [NSString stringWithFormat:@"TonightLife RSVP Request for %@", [event name]];
    
    /* define email address */
    NSString* mail = [[event rsvp] objectForKey:@"email"];
    
    /* create the URL */
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
      [[UIApplication sharedApplication] openURL:url];
    } else {
      NSString* msg = [[NSString alloc] initWithFormat:@"Sorry, we can't seem to launch your iPhone's email client. Please sent an email to %@ to RSVP for this event!", email];
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No email client found"
                                                      message:msg
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
      [alert show];
      [alert release];
      [msg release];
    }
    [url release];
  } else {
    return;
  }
}

- (void)startPlaying {
  //set timer which gets current music time every second
  timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
  //maximum value of slider to duration
  aSlider.maximumValue= audioPlayer.duration;
  //set valueChanged target
  [aSlider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
  [audioPlayer prepareToPlay];
  [audioPlayer play];
  
  [self.playButtonOutlet setImage:[UIImage imageNamed:@"pauseButton.png"] forState:UIControlStateNormal];
}

- (void)stopPlaying {
  [audioPlayer pause];
  [self.playButtonOutlet setImage:[UIImage imageNamed:@"Play-icon2.png"] forState:UIControlStateNormal];
}

- (IBAction)slide {
  audioPlayer.currentTime = aSlider.value;
}

- (IBAction)hideListenButton{
  [self.listenButtonOutlet setHidden:YES];
}

- (IBAction)showPlayer {
  [self hideListenButton];
  self.audioTitleLabelOutlet.hidden = NO;
  self.playButtonOutlet.hidden = NO;
  self.aSlider.hidden = NO;
  self.songTime.hidden = NO;
}

- (void)updateSlider {
  aSlider.value=audioPlayer.currentTime;
  int progress= (int)roundf(audioPlayer.currentTime);
  int hours =  progress / 3600;
  int minutes= (progress % 3600)/60;
  int seconds= progress % 60;
  
  songTime.text=[NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
  
  int totalTime= (int)roundf(audioPlayer.duration);
  
  int hours2 =  totalTime / 3600;
  int minutes2= ( totalTime % 3600)/60;
  int seconds2=  totalTime % 60;
  
  songTotalTime.text=[NSString stringWithFormat:@"%02d:%02d:%02d", hours2, minutes2, seconds2];

}

 

- (IBAction)sliderChanged:(UISlider *)sender {
  // Fast skip the music when user scroll the UISlide
  NSLog(@"Slider changed");
  [audioPlayer stop];
  [audioPlayer setCurrentTime:aSlider.value];
  [audioPlayer prepareToPlay];
  [audioPlayer play];
}


- (IBAction)playPauseBtnClicked:(id)sender {
  if (playing) {
    [[self playButtonOutlet] setTitle:@"Play" forState:UIControlStateNormal];
    playing = NO;
    if (readyToPlay) {
      [self stopPlaying];
    }
  } else {
    [[self playButtonOutlet] setTitle:@"Pause" forState:UIControlStateNormal];
    playing = YES;
    if (readyToPlay) {
      [self startPlaying];
    } else {
      [self.audioLoadingIndicatorOutlet startAnimating];
      [self.audioLoadingIndicatorOutlet setHidden:NO];
    }
  }
}

@end
