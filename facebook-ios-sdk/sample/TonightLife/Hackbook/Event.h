/**
 *  Event.h
 *
 *  Created on: August 19, 2012
 *      Author: Valeri Karpov
 *      
 *  Storage class for events
 *  
 */

#import <UIKit/UIKit.h>

@interface Event : NSObject {
    @public
    NSString* eventId;
    NSString* name;
    NSString* description;
    NSString* venueName;
    NSString* address;
    NSURL* image;
    double lat;
    double lon;
    int radarCount;
    bool featured;
    NSString* time;
    bool onRadar;
}

-(Event*) initEvent :(NSString*) eventId
                    :(NSString*) name
                    :(NSString*) description
                    :(NSString*) venueName
                    :(NSString*) address
                    :(NSURL*) image
                    :(double) lat
                    :(double) lon
                    :(int) radarCount
                    :(bool) featured
                    :(NSString*) time
                    :(bool) onRadar;

@property (nonatomic,retain,readonly) NSString* eventId;
@property (nonatomic,retain,readonly) NSString* name;
@property (nonatomic,retain,readonly) NSString* description;
@property (nonatomic,retain,readonly) NSString* venueName;
@property (nonatomic,retain,readonly) NSString* address;
@property (nonatomic,retain,readonly) NSURL* image;
@property (nonatomic,retain,readonly) NSString* time;

@end
