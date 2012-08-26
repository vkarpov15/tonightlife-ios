/**
 *  EventListHeader.h
 *
 *  Created on: August 24, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for design defined in EventListHeader.xib
 *  
 */

#import "EventListHeader.h"

@implementation EventListHeader

@synthesize usernameOutlet;
@synthesize tabSwitcherOutlet;
@synthesize tabChangeCallback;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(IBAction) segmentedControlIndexChanged {
    NSLog(@"My index is %d", self.tabSwitcherOutlet.selectedSegmentIndex);
    if (nil != tabChangeCallback) {
        if (0 == self.tabSwitcherOutlet.selectedSegmentIndex) {
            [tabChangeCallback onShortListClick];
        } else if (1 == self.tabSwitcherOutlet.selectedSegmentIndex) {
            [tabChangeCallback onAllEventsClick];
        } else {
            [tabChangeCallback onLineupClick];
        }
    }
}

@end
