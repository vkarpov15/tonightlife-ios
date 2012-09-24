/**
 *  MapViewLauncherDelegate.h
 *
 *  Created on: September 23, 2012
 *      Author: Valeri Karpov
 *      
 *  Callback for launching a map view from somewhere that shouldn't
 *  have a navigation controller reference
 *  
 */

#import <Foundation/Foundation.h>
#import "Event.h"

@protocol MapViewLauncherDelegate <NSObject>
@required
- (void) launchMapViewWithEvent: (Event*) e;
@end
