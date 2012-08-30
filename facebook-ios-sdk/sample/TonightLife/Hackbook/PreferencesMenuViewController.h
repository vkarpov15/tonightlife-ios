//
//  PreferencesMenuViewController.h
//  TonightLife
//
//  Created by Cesar Devers on 8/29/12.
//
//

#import <UIKit/UIKit.h>

@interface PreferencesMenuViewController : UIViewController<UIActionSheetDelegate> {
    IBOutlet UILabel *label;
}

@property (nonatomic,retain) UILabel *label;
-(IBAction)showActionSheet:(id)sender;

@end
