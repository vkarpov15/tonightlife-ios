/**
 *  TabChangeCallback.h
 *
 *  Created on: August 24, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for EventListHeader to tell RootViewController that
 *  the user has selected a different tab
 *  
 */

#import <Foundation/Foundation.h>
#import "RadarCommonController.h"

@interface TabChangeCallback : NSObject

@property (nonatomic,retain) UITableView* tableView;
@property (nonatomic,retain) RadarCommonController* commonController;

-(TabChangeCallback*) initCallback :(UITableView*) notifyTableView :(RadarCommonController*) notifyCommonController;

-(void) onShortListClick;
-(void) onAllEventsClick;
-(void) onLineupClick;

@end
