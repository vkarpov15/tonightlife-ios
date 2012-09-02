/**
 *  TonightlifeMarker.h
 *
 *  Created on: August 31, 2012
 *      Author: Valeri Karpov
 *      
 *  Wrapper around map markers
 *  
 */

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Event.h"

@interface TonightlifeMarker : NSObject <MKAnnotation> {
}

@property (nonatomic,retain) Event* event;
@property (nonatomic,copy) NSString* title;
@property (nonatomic,copy) NSString* subtitle;
@property (nonatomic,readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSUInteger index;

- (TonightlifeMarker*) initWithEvent: (Event*) e: (NSUInteger) index;

@end
