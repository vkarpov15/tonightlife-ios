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

@synthesize eventId, name, description, venueName, address, image, time, rsvp, cover, audio;

- (void) dealloc {
    [eventId release];
    [name release];
    [description release];
    [venueName release];
    [address release];
    [image release];
    [time release];
    [rsvp release];
    [cover release];
    [audio release];
    [super dealloc];
}

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
                    :(bool) inOnRadar
                    :(NSMutableDictionary*) inRsvp
                    :(NSString*) inCover
                    :(NSMutableDictionary*) inAudio {
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
        [self formatTime:inTime];
        onRadar = inOnRadar;
        rsvp = [inRsvp retain];
        cover = [inCover retain];
        audio = [inAudio retain];
    }
    return self;
}

-(void) formatTime: (NSString*) t {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
    //[dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDate *myDate = [dateFormatter dateFromString:t];
    [dateFormatter dealloc];
    
    time = [[TonightLifeTime alloc] initWithNsDate:myDate];
}

-(NSComparisonResult) compareTimes:(Event*) other {
    return [time compare:[other time]];
}

-(NSComparisonResult) compareRadarCounts:(Event*) other {
    if (radarCount > other->radarCount) {
        return NSOrderedDescending;
    } else if (radarCount < other->radarCount) {
        return NSOrderedAscending;
    }
    return NSOrderedSame;
}

@end
