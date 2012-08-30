//
//  PreferencesMenuViewController.m
//  TonightLife
//
//  Created by Cesar Devers on 8/29/12.
//
//

#import "PreferencesMenuViewController.h"

@interface PreferencesMenuViewController ()

@end

@implementation PreferencesMenuViewController

-(IBAction)showActionSheet:(id)sender {
	
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Action Sheet" delegate:self cancelButtonTitle:@"Cancel Button" destructiveButtonTitle:@"Destructive Button" otherButtonTitles:@"Other Button 1", nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	
    [popupQuery showInView:self.view];
	
    [popupQuery release];
	
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if (buttonIndex == 0) {
		
		
    } else if (buttonIndex == 1) {
		
		
    } else if (buttonIndex == 2) {
		
		
    } else if (buttonIndex == 3) {
		
		
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
