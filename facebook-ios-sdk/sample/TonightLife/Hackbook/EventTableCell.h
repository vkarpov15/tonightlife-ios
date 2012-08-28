/**
 *  EventTableCell.h
 *
 *  Created on: August 23, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for design defined in EventCell.xib
 *  
 */

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventTableCell : UITableViewCell {
    Event* event;
}

@property (nonatomic, retain) Event* event;
@property (nonatomic, retain) IBOutlet UILabel *eventName;

@property (nonatomic, retain) IBOutlet UIView *imageWrapper;

- (void)setEvent:(Event*) inEvent;

@end
