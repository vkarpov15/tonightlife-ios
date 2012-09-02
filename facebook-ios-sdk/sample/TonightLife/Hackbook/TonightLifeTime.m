/**
 *  TonightLifeTime.m
 *
 *  Created on: September 1, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for event times
 *  
 */

#import "TonightLifeTime.h"

@implementation TonightLifeTime

@synthesize date;

- (TonightLifeTime*) initWithNsDate: (NSDate*) d {
    self = [super init];
    if (self) {
        date = [d retain];
    }
    return self;
}

- (NSString*) makeYourTime {
    NSDateFormatter *visibleDateFormatter = [[NSDateFormatter alloc] init];
    [visibleDateFormatter setDateFormat:@"h:mm a"];
    NSString* myTime = [visibleDateFormatter stringFromDate:date];
    [visibleDateFormatter dealloc];
    return myTime;
}

- (NSComparisonResult) compare: (TonightLifeTime*)other {
    return [date compare:[other date]];
}

@end
