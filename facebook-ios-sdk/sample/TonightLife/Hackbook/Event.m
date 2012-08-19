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
        eventId = inEventId;
        name = inName;
        description = inDescription;
        venueName = inVenueName;
        address = inAddress;
        image = inImage;
        lat = inLat;
        lon = inLon;
        radarCount = inRadarCount;
        featured = inFeatured;
        time = inTime;
        onRadar = inOnRadar;
    }
    return self;
}
@end
