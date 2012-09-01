/**
 *  RadarMapViewController.h
 *
 *  Created on: August 28, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for displaying events on a map with RadarMapView.xib layout
 *  
 */

#import "RadarMapViewController.h"

// Much easier to deal with miles as opposed to meters for map zoom. Silly iOS
#define METERS_PER_MILE 1609.344

@implementation RadarMapViewController

@synthesize mapViewOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(RadarMapViewController*) initWithCommonController: (RadarCommonController*) common {
    self = [super initWithNibName:@"RadarMapView" bundle:[NSBundle mainBundle]];
    if (self) {
        commonController = common;
        selectedEvent = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = @"Events Map";
    
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [mapViewOutlet setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.736968, -73.989183), 5 * METERS_PER_MILE, 5 * METERS_PER_MILE)];
    
    for (NSUInteger i = 0; i < [[commonController eventsList] count]; ++i) {
        Event* e = [[commonController eventsList] objectAtIndex:i];
        [mapViewOutlet addAnnotation:[[TonightlifeMarker alloc] initWithEvent:e]];
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
