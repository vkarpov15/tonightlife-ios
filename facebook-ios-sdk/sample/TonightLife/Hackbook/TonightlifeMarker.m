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

@synthesize event;
@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize index;

- (TonightlifeMarker*) initWithEvent: (Event*) e: (NSUInteger) ind {
  self = [super init];
  if (self) {
    [self setEvent:e];
    self.index = ind;
    self->title = [e name];
    self->subtitle = [e address]; //[[[e time] makeYourTime] copy];
    self->coordinate = CLLocationCoordinate2DMake(e->lat, e->lon);
  }
  return self;
}

@end
