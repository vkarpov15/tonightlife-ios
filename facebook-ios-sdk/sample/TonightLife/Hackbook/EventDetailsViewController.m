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

@implementation EventDetailsViewController

@synthesize eventTitleOutlet;
@synthesize imageWrapperOutlet;
@synthesize eventDescriptionOutlet;
@synthesize addToLineupButtonOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (EventDetailsViewController*) initEventDetailsView:(Event *)e :(UIImage *)img :(NSString *)token :(RadarCommonController*) common {
    self = [super initWithNibName:@"EventDetailsView" bundle:[NSBundle mainBundle]];
    if (self) {
        event = e;
        image = img;
        tonightlifeToken = token;
        commonController = common;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Event Details";
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"ios_app_header.png"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.eventTitleOutlet.text = [event name];
    self.eventDescriptionOutlet.text = [event description];
    
    // Initialize the event image
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 124)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = image;
    [self.imageWrapperOutlet addSubview:imgView];
    
    // Handle lineup button clicks
    [addToLineupButtonOutlet setAction:@selector(addToLineupClicked:)];
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
    
    if ([commonController addToLineup:event]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Dispatch request on separate thread
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
    }
    
}

@end
