/**
 *  TabChangeCallback.m
 *
 *  Created on: August 24, 2012
 *      Author: Valeri Karpov
 *      
 *  Interface for EventListHeader to tell RootViewController that
 *  the user has selected a different tab
 *  
 */

#import "TabChangeCallback.h"

@implementation TabChangeCallback

@synthesize tableView;
@synthesize commonController;

-(TabChangeCallback*) initCallback :(UITableView*) notifyTableView :(RadarCommonController*) notifyCommonController {
    self = [super init];
    if (self) {
        tableView = notifyTableView;
        commonController = notifyCommonController;
    }
    return self;
}

-(void) onShortListClick {
    [commonController setCurrentToFeaturedList];
    [tableView reloadData];
}

-(void) onAllEventsClick {
    [commonController setCurrentToAllList];
    [tableView reloadData];
}

-(void) onLineupClick {
    [commonController setCurrentToRadarList];
    [tableView reloadData];
}

@end
