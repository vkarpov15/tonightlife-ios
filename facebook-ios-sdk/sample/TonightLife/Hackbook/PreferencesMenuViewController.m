//
//  PreferencesMenuViewController.m
//  TonightLife
//
//  Created by Cesar Devers on 8/29/12.
//
//

#import "PreferencesMenuViewController.h"

@implementation PreferencesMenuViewController

@synthesize delegate;

-(IBAction)showActionSheet:(id)sender {
	
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Preferences" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Refresh", @"Send Feedback", nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	
    [popupQuery showInView:self.view];
	
    [popupQuery release];
	
}


-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	switch (buttonIndex) {
        case 0:
            [delegate loadEventsFromServer];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"mailto:founders@tonight-life.com?subject=TonightLife%20iPhone%20Feedback"]]];
            break;
        case 2:
        default:
            break;
    }
	
}



- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
