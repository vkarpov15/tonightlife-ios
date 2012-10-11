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
#import "TonightLifeTime.h"

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
  TonightLifeTime* time;
  bool onRadar;
  NSMutableDictionary* rsvp;
  NSString* cover;
  NSMutableArray* audio;
}

- (Event *)initEvent :(NSString *) eventId
                     :(NSString *) name
                     :(NSString *) description
                     :(NSString *) venueName
                     :(NSString *) address
                     :(NSURL *) image
                     :(double) lat
                     :(double) lon
                     :(int) radarCount
                     :(bool) featured
                     :(NSString *) time
                     :(bool) onRadar
                     :(NSMutableDictionary *) rsvp
                     :(NSString *) cover
                     :(NSMutableArray *) audio;

- (void)formatTime:(NSString *)time;

- (NSComparisonResult)compareTimes:(Event *) other;
- (NSComparisonResult)compareRadarCounts:(Event *) other;

@property (nonatomic,retain,readonly) NSString* eventId;
@property (nonatomic,retain,readonly) NSString* name;
@property (nonatomic,retain,readonly) NSString* description;
@property (nonatomic,retain,readonly) NSString* venueName;
@property (nonatomic,retain,readonly) NSString* address;
@property (nonatomic,retain,readonly) NSURL* image;
@property (nonatomic,retain,readonly) TonightLifeTime* time;
@property (nonatomic,retain,readonly) NSMutableDictionary* rsvp;
@property (nonatomic,retain,readonly) NSString* cover;
@property (nonatomic,retain,readonly) NSMutableArray* audio;

@end
