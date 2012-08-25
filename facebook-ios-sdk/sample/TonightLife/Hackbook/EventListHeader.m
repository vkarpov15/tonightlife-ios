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

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
