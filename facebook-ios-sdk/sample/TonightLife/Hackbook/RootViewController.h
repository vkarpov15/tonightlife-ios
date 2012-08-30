/*
 * Copyright 2010 Facebook
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "Event.h"
#import "EventTableCell.h"
#import "EventListHeader.h"
#import "RadarCommonController.h"
#import "TabChangeCallback.h"
#import "EventDetailsViewController.h"
#import "RadarMapViewController.h"
#import "PreferencesMenuViewController.h"


@interface RootViewController : UIViewController
<FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate,
UITableViewDataSource,
UITableViewDelegate,
UITabBarDelegate,
UIActionSheetDelegate> {
    NSArray* permissions;

    UIImageView* backgroundImageView;
    UITableView* menuTableView;

    UITabBar* tabBar;
    
    NSMutableArray* mainMenuItems;

    EventListHeader* headerView;
    PreferencesMenuViewController* menuController;
    
    UISegmentedControl* tabs;
    
    NSMutableArray* eventsList;
    RadarCommonController* commonController;
    
    NSMutableDictionary* imageCache;
    TabChangeCallback* tabChangeCallback;
    RadarMapViewController* mapViewController;

}


-(IBAction) prefButtonPressed;
-(void)request:(FBRequest *)request didLoad:(id)result;

@property (nonatomic, retain) NSArray* permissions;
@property (nonatomic, retain) UIImageView* backgroundImageView;
@property (nonatomic, retain) UITableView* menuTableView;
@property (nonatomic, retain) NSMutableArray* mainMenuItems;
@property (nonatomic, retain) EventListHeader* headerView;
@property (nonatomic, retain) UISegmentedControl* tabs;
@property (nonatomic, retain) NSMutableDictionary* imageCache;


@end
