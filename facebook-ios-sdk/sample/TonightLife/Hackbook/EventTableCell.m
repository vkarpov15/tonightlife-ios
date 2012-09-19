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
#import <QuartzCore/QuartzCore.h>

@implementation EventTableCell

@synthesize eventName;
@synthesize eventStartTime;
@synthesize eventVenueName;
@synthesize imageWrapper;
@synthesize event;
@synthesize activityIndicatorOutlet;
@synthesize eventCover;
@synthesize eventImageOutlet;

- (void) dealloc {
    // DO NOT release event here
    [eventName release];
    [eventStartTime release];
    [eventVenueName release];
    [imageWrapper release];
    [activityIndicatorOutlet release];
    [eventCover release];
    [eventImageOutlet release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setEvent:(Event*) inEvent {
    event = [inEvent retain];
    eventName.text = [event name];
    eventStartTime.text = [[event time] makeYourTime];
    eventVenueName.text = [event venueName];
    eventCover.text = [event cover];
    eventCover.layer.cornerRadius = 5.0;
    eventCover.clipsToBounds = YES;
    
}


// Configure the view for the selected state
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    //self.backgroundColor = [UIColor clearColor];
}



@end
