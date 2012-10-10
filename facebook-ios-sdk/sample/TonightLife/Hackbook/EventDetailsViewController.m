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



- (void) dealloc {
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
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (EventDetailsViewController*) initEventDetailsView:(Event *)e :(ImageCacheController*) cache :(NSString *)token :(RadarCommonController*) common: (id <MapViewLauncherDelegate>) delegate {
    self = [super initWithNibName:@"EventDetailsView" bundle:[NSBundle mainBundle]];
    if (self) {
        event = e;
        imageCache = cache;
        tonightlifeToken = token;
        commonController = common;
        mapViewLauncher = delegate;
        playing = NO;
        readyToPlay = NO;
        
        if ([[event audio] count] > 0) {
            NSLog(@"SHOWING!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL* crockett = [[NSURL alloc] initWithString:@"http://api.soundcloud.com/tracks/18951694/stream?client_id=33cc81d646623d460ba86b112badf67b"];
                NSData* data = [NSData dataWithContentsOfURL:crockett];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSError* err = nil;
                    audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&err];
                    [audioPlayer prepareToPlay];
                    if (playing) {

                        [audioPlayer play];
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

    if ([[event audio] count] == 0) {
        self.playButtonOutlet.hidden = YES;
    }
    
    aSlider.value=(0);
    [aSlider setThumbImage:[UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];

    
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
    //imgView.image = [imageCache objectForKey:[event->image absoluteString]];
    [imageCache setImage:event->image :[[AsyncImageCallback alloc] initWithImageView:imgView]];
    [self.imageWrapperOutlet addSubview:imgView];
    [self.imageWrapperOutlet bringSubviewToFront:eventTitleOutlet];	
    [self.imageWrapperOutlet bringSubviewToFront:eventCover];
    
       
    // Handle lineup button clicks
    [addToLineupButtonOutlet setAction:@selector(addToLineupClicked:)];
    [locateButtonOutlet setAction:@selector(onLocateClicked:)];
    [rsvpButtonOutlet setAction:@selector(onRsvpClicked:)];
    if (nil == [[event rsvp] objectForKey:@"url"] && nil == [[event rsvp] objectForKey:@"email"]) {
        [rsvpButtonOutlet setEnabled:NO];
    } else {
        [rsvpButtonOutlet setEnabled:YES];
    }

    
}

-(IBAction)displayFriendsListView:(id)sender {
    [[NSBundle mainBundle] loadNibNamed:@"FriendsList" owner:self options:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [imgView release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)addToLineupClicked:(UITapGestureRecognizer*)tapCallback {
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

-(void) onLocateClicked:(id) sender {
    [mapViewLauncher launchMapViewWithEvent:event];
}

-(void) onRsvpClicked:(id) sender {
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
        [mailto release];
    } else {
        return;
    }
}

- (IBAction)slide {
    audioPlayer.currentTime = aSlider.value;
}


-(void)updateSlider {
    aSlider.value=audioPlayer.currentTime;
}

- (IBAction)sliderChanged:(UISlider *)sender {
    // Fast skip the music when user scroll the UISlide
    [audioPlayer stop];
    [audioPlayer setCurrentTime:aSlider.value];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}


-(IBAction) playPauseBtnClicked:(id) sender {
    if (playing) {
        [[self playButtonOutlet] setTitle:@"Play" forState:UIControlStateNormal];
        playing = NO;
        if (readyToPlay) {
            [audioPlayer pause];
       
        }
    } else {
        [[self playButtonOutlet] setTitle:@"Pause" forState:UIControlStateNormal];
        playing = YES;
        if (readyToPlay) {
            //set timer which gets current music time every second
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
            //maximum value of slider to duration
            aSlider.maximumValue= audioPlayer.duration;
            //set valueChanged target
            
            [aSlider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
            [audioPlayer play];
            
                    }
    }
}

@end
