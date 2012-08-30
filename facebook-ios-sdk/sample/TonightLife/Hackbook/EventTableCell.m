/**
 *  EventTableCell.h
 *
 *  Created on: August 23, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for design defined in EventCell.xib
 *  
 */

#import "EventTableCell.h"

@implementation EventTableCell


@synthesize eventName;
@synthesize eventStartTime;
@synthesize eventVenueName;
@synthesize imageWrapper;
@synthesize event;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setEvent:(Event*) inEvent {
    event = [inEvent retain];
    eventName.text = [event name];
    eventStartTime.text = [event formattedTime];
    eventVenueName.text = [event venueName];
}

// Configure the view for the selected state
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor clearColor];
}



@end
