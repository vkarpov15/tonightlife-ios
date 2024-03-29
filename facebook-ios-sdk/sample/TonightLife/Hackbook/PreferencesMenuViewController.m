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
        case 1: {
                /* create mail subject */
                NSString *subject = [NSString stringWithFormat:@"TonightLife for iPhone Feedback"];
            
                /* define email address */
                NSString *mail = [NSString stringWithFormat:@"founders@tonight-life.com"];
            
                /* create the URL */
                NSURL *toOpen = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@", 
                                                        [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], 
                                                        [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
                if ([[UIApplication sharedApplication] canOpenURL:toOpen]) {
                    [[UIApplication sharedApplication] openURL:toOpen];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No email client found" 
                                                                    message:@"Sorry, we can't seem to launch your iPhone's email client. Please sent an email to founders@tonight-life.com with your feedback. Thanks!" 
                                                                   delegate:nil 
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                [toOpen release];
            }
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
