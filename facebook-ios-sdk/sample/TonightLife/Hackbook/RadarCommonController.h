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

#import "Event.h"

@interface RadarCommonController : NSObject {
    NSMutableDictionary* eventIdToEventMap;
    
    NSMutableArray* featuredList;
    NSMutableArray* eventsList;
    NSMutableArray* radarList;
    NSMutableArray* current;
    NSMutableSet* radarIds;
}

@property (nonatomic,retain,readonly) NSMutableDictionary* eventIdToEventMap;
@property (nonatomic,retain,readonly) NSMutableArray* featuredList;
@property (nonatomic,retain,readonly) NSMutableArray* eventsList;
@property (nonatomic,retain,readonly) NSMutableArray* radarList;
@property (nonatomic,retain,readonly) NSMutableArray* current;
@property (nonatomic,retain,readonly) NSMutableSet* radarIds;

-(NSInteger) defaultOrdering:(Event*) e1 :(Event*) e2 :(void*) context;

-(RadarCommonController*) initDefault;
-(void) addEvent: (Event*) e;
-(BOOL) addToLineup: (Event*) e;
-(BOOL) removeFromLineup: (Event*) e;

-(void) clearAll;

-(void) setCurrentToFeaturedList;
-(void) setCurrentToAllList;
-(void) setCurrentToRadarList;

-(void) order;

@end
