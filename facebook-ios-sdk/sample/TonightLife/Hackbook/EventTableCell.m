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
    
    
    // TODO I have no idea what the fuck I'm doing #Justin
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    assert(dateFormatter!=nil);
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *myDate = [dateFormatter dateFromString:[event time]];
    [dateFormatter dealloc];
    
    NSDateFormatter *visibleDateFormatter = [[NSDateFormatter alloc] init];
    assert(visibleDateFormatter!=nil);
    [visibleDateFormatter setDateFormat:@"HH:mm"];
    eventStartTime.text = [visibleDateFormatter stringFromDate:myDate];
    [visibleDateFormatter dealloc];
}

// Configure the view for the selected state
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor clearColor];
    
    
    //self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"event_table_cell_background.png"]];
}



@end
