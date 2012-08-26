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

@interface EventListHeader : UIView

@property (nonatomic, retain) IBOutlet UILabel* usernameOutlet;
@property (nonatomic, retain) IBOutlet UISegmentedControl* tabSwitcherOutlet;

-(IBAction) segmentedControlIndexChanged;

@end
