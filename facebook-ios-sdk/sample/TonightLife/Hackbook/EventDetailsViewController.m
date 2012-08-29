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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (EventDetailsViewController*) initWithEventAndImage:(Event*) e: (UIImage*) img {
    self = [super initWithNibName:@"EventDetailsView" bundle:[NSBundle mainBundle]];
    if (self) {
        event = e;
        image = img;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = @"Event Details";
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    [self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.eventTitleOutlet.text = [event name];
    self.eventDescriptionOutlet.text = [event description];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 310, 124)];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.image = image;
    [self.imageWrapperOutlet addSubview:imgView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
