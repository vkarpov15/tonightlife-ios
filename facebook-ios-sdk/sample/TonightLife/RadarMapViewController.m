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

-(RadarMapViewController*) initWithCommonController: (RadarCommonController*) common: (NSString*) token: (ImageCacheController*) cache {
    self = [super initWithNibName:@"RadarMapView" bundle:[NSBundle mainBundle]];
    if (self) {
        commonController = common;
        tonightlifeToken = token;
        imageCache = cache;
        selectedEvent = nil;
        header = nil;
        tabs = nil;
    }
    return self;
}

-(void) setSelectedEvent: (Event*) e {
    selectedEvent = e;
}

-(void) setHeaderViewAndTabs: (UIView*) inHeader: (UITabBar*) inTabs {
    header = inHeader;
    tabs = inTabs;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (nil == selectedEvent) {
        [mapViewOutlet setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(40.736968, -73.989183), 5 * METERS_PER_MILE, 5 * METERS_PER_MILE)];
    } else {
        [mapViewOutlet setRegion:MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(selectedEvent->lat, selectedEvent->lon), 1 * METERS_PER_MILE, 1 * METERS_PER_MILE)];
    }
    
    for (NSUInteger i = 0; i < [[commonController eventsList] count]; ++i) {
        Event* e = [[commonController eventsList] objectAtIndex:i];
        [mapViewOutlet addAnnotation:[[TonightlifeMarker alloc] initWithEvent:e:i]];
    }
    
    if (nil == header) {
        // Not launching with header and tabs (i.e. launched from clicking on tab, not in EventDetailsView
        self.navigationItem.title = @"Events Map";
        
        self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:nil action:nil] autorelease];
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    } else {
        // Launched from clicking on tab - populate with tabs and header, no navigation
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        [self.view addSubview:header];
        [self.view addSubview:tabs];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (nil == header) {
        // Make sure navigation controller is showing if launched from EventDetailsView
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    } else {
        // Make sure nav controller is hidden if launched from root view
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (MKAnnotationView*) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString* identifier = @"TonightlifeMarker";
    if ([annotation isKindOfClass:[TonightlifeMarker class]]) {
        TonightlifeMarker* marker = annotation;
        MKPinAnnotationView* annotationView = (MKPinAnnotationView*) [mapViewOutlet dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (nil == annotationView) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed:@"marker.png"];
        annotationView.centerOffset = CGPointMake(0, -5);
        
        UIButton* rightButton = [UIButton buttonWithType:
                                 UIButtonTypeDetailDisclosure];
        [rightButton setTag:[marker index]];
        [rightButton addTarget:self action:@selector(onAnnotationClicked:)
              forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = rightButton;
        
        return annotationView;
    }
    return nil;
}

- (void) onAnnotationClicked:(UIButton*) sender {
    Event* e = [[commonController eventsList] objectAtIndex:[sender tag]];
    EventDetailsViewController* detailsViewController = [[EventDetailsViewController alloc] initEventDetailsView: e: imageCache: tonightlifeToken: commonController];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    [detailsViewController release];
}

@end
