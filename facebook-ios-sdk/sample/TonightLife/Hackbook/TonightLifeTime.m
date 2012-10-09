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

- (void) dealloc {
    [date release];
    [super dealloc];
}

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

- (NSTimeInterval) secondsUntil: (TonightLifeTime*) other {
    return [[other date] timeIntervalSinceDate:[self date]];
}

- (BOOL) beforeNoon {
    NSDate* now = [[NSDate alloc] init];
    
    NSCalendar* cal = [NSCalendar currentCalendar];
    [cal setTimeZone:[NSTimeZone localTimeZone]];
    [cal setLocale:[NSLocale currentLocale]];
    NSDateComponents* timeComponents = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    
    if (timeComponents.hour < 12) {
        return YES;
    }
    
    return NO;
}

@end
