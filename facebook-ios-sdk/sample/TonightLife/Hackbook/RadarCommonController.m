/**
 *  RadarCommonController.h
 *
 *  Created on: August 24, 2012
 *      Author: Valeri Karpov
 *      
 *  Event collection with interface for performing operations like
 *  adding an event to your radar/lineup. Roughly equivalent to
 *  RadarCommonController in the android app.
 *  
 */

#import "RadarCommonController.h"

@implementation RadarCommonController

@synthesize eventIdToEventMap;
@synthesize featuredList;
@synthesize eventsList;
@synthesize radarList;
@synthesize current;

-(RadarCommonController*) initDefault {
    self = [super init];
    if (self) {
        eventIdToEventMap = [[NSMutableDictionary alloc] initWithCapacity:25];
        featuredList = [[NSMutableArray alloc] initWithCapacity:25];
        eventsList = [[NSMutableArray alloc] initWithCapacity:25];
        radarList = [[NSMutableArray alloc] initWithCapacity:25];
        radarIds = [[NSMutableSet alloc] initWithCapacity:25];
        
        current = featuredList;
    }
    return self;
}

-(void) addEvent: (Event*) e {
    [eventIdToEventMap setObject:e forKey:e->eventId];
    [eventsList addObject:e];
    if (e->featured) {
        [featuredList addObject:e];
    }
    if (e->onRadar) {
        [radarIds addObject:[e eventId]];
        [radarList addObject:e];
    }
}

-(BOOL) addToLineup: (Event*) e {
    if ([radarIds containsObject:[e eventId]]) {
        return NO;
    }
    [radarIds addObject:[e eventId]];
    [radarList addObject:e];
    e->onRadar = YES;
    return YES;
}

-(BOOL) removeFromLineup: (Event*) e {
    if (![radarIds containsObject:[e eventId]]) {
        return NO;
    }
    [radarIds removeObject:[e eventId]];
    [radarList removeObject:e];
    e->onRadar = NO;
    return YES;
}

-(void) setCurrentToFeaturedList {
    current = featuredList;
}

-(void) setCurrentToAllList {
    current = eventsList;
}

-(void) setCurrentToRadarList {
    current = radarList;
}

-(void) order {
    [featuredList sortUsingSelector:@selector(compareRadarCounts:)];
    [eventsList sortUsingSelector:@selector(compareTimes:)];
    [radarList sortUsingSelector:@selector(compareTimes:)];
}

@end
