/**
 *  Event.m
 *
 *  Created on: August 19, 2012
 *      Author: Valeri Karpov
 *      
 *  Storage class for events
 *  
 */

#import "Event.h"

@implementation Event

@synthesize eventId, name, description, venueName, address, image, time;

-(Event*) initEvent :(NSString*) inEventId
                    :(NSString*) inName
                    :(NSString*) inDescription
                    :(NSString*) inVenueName
                    :(NSString*) inAddress
                    :(NSURL*) inImage
                    :(double) inLat
                    :(double) inLon
                    :(int) inRadarCount
                    :(bool) inFeatured
                    :(NSString*) inTime
                    :(bool) inOnRadar {
    self = [super init];
    if (self) {
        eventId = [inEventId retain];
        name = [inName retain];
        description = [inDescription retain];
        venueName = [inVenueName retain];
        address = [inAddress retain];
        image = [inImage retain];
        lat = inLat;
        lon = inLon;
        radarCount = inRadarCount;
        featured = inFeatured;
        time = [inTime retain];
        onRadar = inOnRadar;
    }
    return self;
}

-(NSString*) formattedTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    assert(dateFormatter!=nil);
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *myDate = [dateFormatter dateFromString:time];
    [dateFormatter dealloc];
    
    NSDateFormatter *visibleDateFormatter = [[NSDateFormatter alloc] init];
    assert(visibleDateFormatter!=nil);
    [visibleDateFormatter setDateFormat:@"h:mm a"];
    NSString* myTime = [visibleDateFormatter stringFromDate:myDate];
    [visibleDateFormatter dealloc];
    return myTime;
}

@end
