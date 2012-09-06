//
//  PreferencesMenuViewController.h
//  TonightLife
//
//  Created by Cesar Devers on 8/29/12.
//
//

#import <UIKit/UIKit.h>

@protocol PreferencesMenuDelegate <NSObject>

- (void) loadEventsFromServer;

@end

@interface PreferencesMenuViewController : UIViewController<UIActionSheetDelegate> {
    id <PreferencesMenuDelegate> delegate;
}

- (IBAction) showActionSheet:(id)sender;

@property (nonatomic, retain) id <PreferencesMenuDelegate> delegate;

@end
