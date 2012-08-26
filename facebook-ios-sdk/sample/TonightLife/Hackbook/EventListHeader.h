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
}

@property (nonatomic, retain) IBOutlet UILabel* usernameOutlet;
@property (nonatomic, retain) IBOutlet UISegmentedControl* tabSwitcherOutlet;
@property (nonatomic, retain) TabChangeCallback* tabChangeCallback;

-(IBAction) segmentedControlIndexChanged;

@end
