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

#import <AudioToolbox/AudioToolbox.h>
#import "RootViewController.h"
#import "HackbookAppDelegate.h"
#import "FBConnect.h"


@implementation RootViewController

@synthesize permissions;
@synthesize backgroundImageView;
@synthesize menuTableView;
@synthesize mainMenuItems;
@synthesize headerView;
@synthesize imageCache;
@synthesize eventCover;

- (void)dealloc {
    [permissions release];
    [backgroundImageView release];
    [menuTableView release];
    [mainMenuItems release];
    [headerView release];
    [imageCache release];
    [commonController release];
    [menuController release];
    [mapViewController release];
    [eventCover release];
    if (nil != lastUpdate) {
        [lastUpdate release];
    }
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    NSLog(@"GOT LOW MEMORY WARNING");
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Facebook API Calls
/**
 * Make a Graph API Call to get information about the current logged in user.
 */
- (void)apiFQLIMe {
    // Using the "pic" picture since this currently has a maximum width of 100 pixels
    // and since the minimum profile picture size is 180 pixels wide we should be able
    // to get a 100 pixel wide version of the profile picture
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"SELECT uid, name, first_name, last_name FROM user WHERE uid=me()", @"query",
                                   nil];
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithMethodName:@"fql.query"
                                     andParams:params
                                 andHttpMethod:@"POST"
                                   andDelegate:self];
}

- (void)apiGraphUserPermissions {
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] requestWithGraphPath:@"me/permissions" andDelegate:self];
}


#pragma - Private Helper Methods

/**
 * Show the logged in menu
 */

- (void)showLoggedIn {
    
    self.backgroundImageView.hidden = YES;
    self.menuTableView.hidden = NO;
    self.headerView.hidden = NO;
    tabBar.hidden = NO;
    loggedIn = YES;
    
    //[self apiFQLIMe];
}

/**
 * Show the logged out menu
 */

- (void)showLoggedOut {
    
    self.menuTableView.hidden = YES;
    self.backgroundImageView.hidden = NO;
    loggedIn = NO;
    
    // Clear personal info
    headerView.usernameOutlet.text = @"";
}

/**
 * Show the authorization dialog.
 */
- (void)login {
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        NSLog(@"Requesting permissions %@", permissions);
        [[delegate facebook] authorize:permissions];
    } else {
        [self apiFQLIMe];
    }
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[delegate facebook] logout];
}

#pragma mark - View lifecycle
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    lastUpdate = nil;
    loggedIn = NO;
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen
                                                  mainScreen].applicationFrame];
    [view setBackgroundColor:[UIColor whiteColor]];
    self.view = view;
    [view release];
    
    imageCache = [[ImageCacheController alloc] initDefault];
    commonController = [[RadarCommonController alloc] initDefault];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    
    // Background Image
    backgroundImageView = [[UIImageView alloc]
                           initWithFrame:CGRectMake(0,0,
                                                    self.view.bounds.size.width,
                                                    self.view.bounds.size.height)];
    [backgroundImageView setImage:[UIImage imageNamed:@"Default.png"]];
    [self.view addSubview:backgroundImageView];
    
    // Activity spinner
    loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [loadingSpinner setFrame:CGRectMake((self.view.bounds.size.width - 40) / 2, self.view.bounds.size.height - 40 - 10, 40, 40)];
    [self.view addSubview:loadingSpinner];
    [loadingSpinner startAnimating];
    
    // Main Menu Table
    menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 100)
                                                 style:UITableViewStylePlain];
    [menuTableView setBackgroundColor:[UIColor colorWithRed:0/255 green: 0/255 blue: 0/255 alpha: 1.0]];
    menuTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    menuTableView.separatorColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.1];
    menuTableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    menuTableView.dataSource = self;
    menuTableView.delegate = self;
    menuTableView.hidden = YES;
    
    emptyTableView = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    emptyTableView.hidden = YES;
    [emptyTableView setBackgroundColor:[UIColor colorWithRed:255/255 green: 255/255 blue: 255/255 alpha: 1.0]];
    [emptyTableView setTextColor:[UIColor whiteColor]];
    [emptyTableView setTextAlignment:UITextAlignmentCenter];
    emptyTableView.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"noEvents.png"]];
    
    noEventsOnLineupView = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
    noEventsOnLineupView.hidden = YES;
    [noEventsOnLineupView setBackgroundColor:[UIColor colorWithRed:0/255 green: 0/255 blue: 0/255 alpha: 1.0]];
    [noEventsOnLineupView setTextColor:[UIColor whiteColor]];
    [noEventsOnLineupView setTextAlignment:UITextAlignmentCenter];
    noEventsOnLineupView.text = @"No Events To Show";
    
    // Table header
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EventListHeader" owner:self options:nil];
    headerView = [nib objectAtIndex:0];
    headerView.hidden = YES;
    //headerView.backgroundColor = [UIColor clearColor];
    headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ios_app_header.png"]];
    menuController = [[PreferencesMenuViewController alloc] init];
    [menuController setDelegate:self];
    // Connect the button
    [headerView.preferencesButton addTarget:menuController action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];

    headerView.usernameOutlet.text = @"";
    
    NSArray* tabsNib = [[NSBundle mainBundle] loadNibNamed:@"BottomTabs" owner:self options:nil];
    tabBar = [tabsNib objectAtIndex:0];
    [tabBar setFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 60)];
    [tabBar setDelegate:self];
    [tabBar setSelectedItem:[[tabBar items] objectAtIndex:0]];
    tabBar.hidden = YES;
    
    [self.view addSubview:headerView];
    [self.view addSubview:menuTableView];
    [self.view addSubview:emptyTableView];
    [self.view addSubview:noEventsOnLineupView];
    [self.view addSubview:tabBar];
    
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    mapViewController = [[RadarMapViewController alloc] initWithCommonController:commonController: tonightlifeToken: imageCache];
    [mapViewController setHeaderViewAndTabs:headerView: self->tabBar];
    
    if (![[delegate facebook] isSessionValid]) {
        [self login];
    } else {
        [self apiFQLIMe];
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    NSLog(@"LOADED!");
    if (loggedIn) {
        // Reload common controller data since it may have changed, but only if we're logged in
        // otherwise, no point, and causes the emptyTableView to show up
        [commonController order];
        [self reloadMainTableView];
        // Get back headerView, because RadarMapView might have jacked it
        [self.view addSubview:headerView];
        [self.view addSubview:tabBar];
    }
    
}

- (void) forceReload {
    if (nil != lastUpdate && [lastUpdate secondsUntil:[[[TonightLifeTime alloc] initWithNsDate:[[NSDate alloc] init]] autorelease]] >= 2 * 60 * 60) {
        NSLog(@"Updating! %f", [lastUpdate secondsUntil:[[[TonightLifeTime alloc] initWithNsDate:[[NSDate alloc] init]] autorelease]]);
        self.menuTableView.hidden = YES;
        self.headerView.hidden = YES;
        tabBar.hidden = YES;
        backgroundImageView.hidden = NO;
        loadingSpinner.hidden = NO;
        [self loadEventsFromServer];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UITableViewDatasource and UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180.0;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"I think eventsList count is %d", [[commonController current] count]);
    return [[commonController current] count];
}

- (void)eventClicked:(UITapGestureRecognizer*)tapCallback {
    EventTableCell* cell = [tapCallback view]; // FIXME Could be a simple casting error
    Event* e = [cell event];
    [cell setSelected:YES animated:YES];
    //AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    //EventDetailsViewController* detailsViewController = [[EventDetailsViewController alloc] initEventDetailsView: e: imageCache: tonightlifeToken: commonController];
    NSLog(@"Index is %d", [commonController getEventIndex:e]);
    EventDetailsPageViewController* pageViewController = [[EventDetailsPageViewController alloc] initEventDetailsPageView: [commonController getEventIndex:e] :imageCache :tonightlifeToken :commonController];
    [self.navigationController pushViewController:pageViewController animated:YES];
    [pageViewController release];
    NSLog(@"%@", [e name]);
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    EventTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EventTableCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];

    }
    
    Event *e = [[commonController current] objectAtIndex:indexPath.row];
    [cell setEvent:e];
    [cell setTag:indexPath.row];
    [cell setSelected:NO animated:YES];
    
    [[cell activityIndicatorOutlet] startAnimating];
    
    [cell eventImageOutlet].hidden = YES;
    AsyncImageCallback* callback = [[AsyncImageCallback alloc] initWithImageView:[cell eventImageOutlet]];
    [callback setActivityIndicator:[cell activityIndicatorOutlet]];
    [imageCache setImage: e->image: callback];

    UITapGestureRecognizer* tapCallback = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(eventClicked:)];
    [cell addGestureRecognizer:tapCallback];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Nothing to do here for now, we use UITapGestureRecognizer above
}

- (void)storeAuthData:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

#pragma mark - FBSessionDelegate Methods
/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
    [self apiFQLIMe];
    
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"EXPIRATION DATE IS %@", [[delegate facebook] expirationDate]);
    [self storeAuthData:[[delegate facebook] accessToken] expiresAt:[[delegate facebook] expirationDate]];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended to %@", expiresAt);
    [self storeAuthData:accessToken expiresAt:expiresAt];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
}

/**
 * Called when the request logout has succeeded.
 */
- (void)fbDidLogout {
    // Remove saved authorization information if it exists and it is
    // ok to clear it (logout, session invalid, app unauthorized)
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults removeObjectForKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    [self showLoggedOut];
}

/**
 * Called when the session has expired.
 */
- (void)fbSessionInvalidated {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Auth Exception"
                              message:@"Your session has expired."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil,
                              nil];
    [alertView show];
    [alertView release];
    [self fbDidLogout];
}

#pragma mark - FBRequestDelegate Methods
/**
 * Called when the Facebook API request has returned a response. This callback
 * gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */
- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"received response");
}

/**
 * Called when a request returns and its response has been parsed into
 * an object. The resulting object may be a dictionary, an array, a string,
 * or a number, depending on the format of the API response. If you need access
 * to the raw response, use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([result isKindOfClass:[NSArray class]]) {
        result = [result objectAtIndex:0];
    }
    // This callback can be a result of getting the user's basic
    // information or getting the user's permissions.
    if ([result objectForKey:@"name"]) {
        // If basic information callback, set the UI objects to
        // display this.
        headerView.usernameOutlet.text = [NSString stringWithFormat:@"%@ %@.", [result objectForKey:@"first_name"], [[result objectForKey:@"last_name"] substringToIndex:1]];
        
        [self apiGraphUserPermissions];
        
        // Send off Tabbie Login req
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* fbToken = [defaults objectForKey:@"FBAccessTokenKey"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"Dispatching tabbie login %@", fbToken);
            // Send Tabbie login request - synchronous within separate thread
            NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://tonight-life.com/mobile/auth.json"]];
            NSString* params = [NSString stringWithFormat:@"fb_token=%@", fbToken];
            [req setHTTPMethod:@"POST"];
            [req setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
            NSURLResponse* response = nil;
            NSError* error;
            NSData* data = [NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error];
            
            NSDictionary* ret = [NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions
                                                       error:&error];
            
            NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"Data is %@", str);
            NSLog(@"Ret size is %d", [ret count]);
            
            
            tonightlifeToken = [ret objectForKey:@"token"];
            NSLog(@"Tonightlife Token=%@", tonightlifeToken);
            [defaults setObject:tonightlifeToken forKey:@"TonightlifeToken"];
            
            // Now that we have token, load events
            [self loadEventsFromServer];
        });
    } else {
        // Processing permissions information
        HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
}

- (void) loadEventsFromServer {
    NSString* eventUrl = [NSString stringWithFormat:@"http://tonight-life.com/mobile/all.json?auth_token=%@", tonightlifeToken];
    NSError* error;
    NSData* eventData = [NSData dataWithContentsOfURL:
                         [NSURL URLWithString: eventUrl]];
    
    NSArray* eventList = [NSJSONSerialization JSONObjectWithData:eventData
                                                         options:kNilOptions
                                                           error:&error];
    NSUInteger len = [eventList count];
    
    NSArray* radarEvents = [[eventList objectAtIndex:len - 1] objectForKey:@"radar"];
    
    [commonController clearAll];
    for (NSUInteger i = 0; i < len - 1; ++i) {
        NSDictionary* event = [eventList objectAtIndex:i];
        
        // Very important to use stringWithFormat here, just using NSString* =
        // [event objectForKey] bugs out in the isEqualToString call because objective-C
        // is quirky
        NSString* radarCountStr = [NSString stringWithFormat:@"%@", [event objectForKey:@"user_count"]];
        NSUInteger radarCount = 0;
        if (![radarCountStr isEqualToString:@"null"]) {
            radarCount = [radarCountStr integerValue];
        }
        
        Event* e = [[Event alloc] initEvent :[event objectForKey:@"id"]
                                            :[event objectForKey:@"name"]
                                            :[event objectForKey:@"description"]
                                            :[event objectForKey:@"location"]
                                            :[event objectForKey:@"street_address"]
                                            :[NSURL URLWithString:[NSString stringWithFormat:@"http://tonight-life.com%@", [event objectForKey:@"image_url"]]]
                                            :[[event objectForKey:@"latitude"] doubleValue]
                                            :[[event objectForKey:@"longitude"] doubleValue]
                                            :radarCount
                                            :[[event objectForKey:@"featured"] boolValue]
                                            :[event objectForKey:@"start_time"]
                                            :[radarEvents containsObject:[event objectForKey:@"id"]]
                                            :[event objectForKey:@"rsvp"]
                                            :[event objectForKey:@"cover"]
                                            :[event objectForKey:@"audio"]];
        [commonController addEvent:e];
    }
    [commonController order];
    lastUpdate = [[TonightLifeTime alloc] initWithNsDate:[[NSDate alloc] init]];
    NSLog(@"last update set to %@", [lastUpdate makeYourTime]);
    
    //NSLog(@"Got my events! %@", eventList);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (NSUInteger i = 0; i < [[commonController eventsList] count]; ++i) {
            Event* e = [[commonController eventsList] objectAtIndex:i];
            [imageCache preload:e->image];
        }
        
        [self showLoggedIn];
        [self reloadMainTableView];
    });
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSLog(@"didSelectItem: %d", item.tag);
    switch (item.tag) {
        case 0:
            [self.navigationController popToRootViewControllerAnimated:NO];
            [commonController setCurrentToFeaturedList];
            [self reloadMainTableView];
            break;
            
        case 1:
            [self.navigationController popToRootViewControllerAnimated:NO];
            [commonController setCurrentToAllList];
            [self reloadMainTableView];
            break;
            
        case 2:
            [self.navigationController popToRootViewControllerAnimated:NO];
            [commonController setCurrentToRadarList];
            [self reloadMainTableView];
            break;
            
        case 3:
            [self.navigationController popToRootViewControllerAnimated:NO];
            [self.navigationController pushViewController:mapViewController animated:NO];
            break;
            
        default:
            break;
    }
}

-(void) reloadMainTableView {
    [menuTableView reloadData];
    [mapViewController loadAnnotations];
    if ([commonController current] == [commonController radarList] && [[commonController radarList] count] == 0) {
        noEventsOnLineupView.hidden = NO;
        emptyTableView.hidden = YES;
        menuTableView.hidden = YES;
    } else if ([[commonController current] count] == 0) {
        emptyTableView.hidden = NO;
        noEventsOnLineupView.hidden = YES;
        menuTableView.hidden = YES;
    } else {
        emptyTableView.hidden = YES;
        noEventsOnLineupView.hidden = YES;
        menuTableView.hidden = NO;
    }
    
}

@end
