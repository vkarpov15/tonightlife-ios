/**
 *  TonightlifeMarker.m
 *
 *  Created on: August 31, 2012
 *      Author: Valeri Karpov
 *      
 *  Wrapper around map markers
 *  
 */

#import "TonightlifeMarker.h"

@implementation TonightlifeMarker

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

- (TonightlifeMarker*) initWithEvent: (Event*) e {
    self = [super init];
    if (self) {
        self->title = [e name];
        self->subtitle = [[e formattedTime] copy];
        self->coordinate = CLLocationCoordinate2DMake(e->lat, e->lon);
    }
    return self;
}

@end
