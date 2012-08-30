/**
 *  EventListHeader.h
 *
 *  Created on: August 24, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for design defined in EventListHeader.xib
 *  
 */

#import <UIKit/UIKit.h>
#import "TabChangeCallback.h"

@interface EventListHeader : UIView {
    TabChangeCallback* tabChangeCallback;
    UIButton* preferencesButton;
}

@property (nonatomic, retain) IBOutlet UILabel* usernameOutlet;
@property (nonatomic, retain) IBOutlet UIButton* preferencesButton;

@end
