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

#import "RootViewController.h"
#import "HackbookAppDelegate.h"
#import "FBConnect.h"
#import "APICallsViewController.h"

@implementation RootViewController

@synthesize permissions;
@synthesize backgroundImageView;
@synthesize menuTableView;
@synthesize mainMenuItems;
@synthesize headerView;
//@synthesize nameLabel;
@synthesize tabs;
@synthesize imageCache;

- (void)dealloc {
    [permissions release];
    [backgroundImageView release];
    [menuTableView release];
    [mainMenuItems release];
    [headerView release];
    //[nameLabel release];
    [tabs release];
    [imageCache release];
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
    
    //[self apiFQLIMe];
}

/**
 * Show the logged in menu
 */

- (void)showLoggedOut {
    
    self.menuTableView.hidden = YES;
    self.backgroundImageView.hidden = NO;
    
    // Clear personal info
    headerView.usernameOutlet.text = @"";
}

/**
 * Show the authorization dialog.
 */
- (void)login {
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
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
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen
                                                  mainScreen].applicationFrame];
    [view setBackgroundColor:[UIColor whiteColor]];
    self.view = view;
    [view release];
    
    imageCache = [[NSMutableDictionary alloc] initWithCapacity:25];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    // Initialize permissions
    permissions = [[NSArray alloc] initWithObjects:@"offline_access", nil];
    
    // Main menu items
    mainMenuItems = [[NSMutableArray alloc] initWithCapacity:1];
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray *apiInfo = [[delegate apiData] apiConfigData];
    for (NSUInteger i=0; i < [apiInfo count]; i++) {
        [mainMenuItems addObject:[[apiInfo objectAtIndex:i] objectForKey:@"title"]];
    }
    
    // Set up the view programmatically
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"Hackbook for iOS";
    
    self.navigationItem.backBarButtonItem =
    [[[UIBarButtonItem alloc] initWithTitle:@"Back"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil] autorelease];
    
    // Background Image
    backgroundImageView = [[UIImageView alloc]
                           initWithFrame:CGRectMake(0,0,
                                                    self.view.bounds.size.width,
                                                    self.view.bounds.size.height)];
    [backgroundImageView setImage:[UIImage imageNamed:@"Default.png"]];
    [self.view addSubview:backgroundImageView];
    
    // Main Menu Table
    menuTableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                 style:UITableViewStylePlain];
    [menuTableView setBackgroundColor:[UIColor whiteColor]];
    menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    menuTableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    menuTableView.dataSource = self;
    menuTableView.delegate = self;
    menuTableView.hidden = YES;
    //[self.view addSubview:menuTableView];
    
    // Table header
    NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EventListHeader" owner:self options:nil];
    headerView = [nib objectAtIndex:0];

    headerView.usernameOutlet.text = @"";
    menuTableView.tableHeaderView = headerView;
    
    [self.view addSubview:menuTableView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (![[delegate facebook] isSessionValid]) {
        [self login];
    } else {
        [self apiFQLIMe];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - UITableViewDatasource and UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120.0;
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"I think eventsList count is %d", [eventsList count]);
    return eventsList.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    EventTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray* nib = [[NSBundle mainBundle] loadNibNamed:@"EventCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        UIView *background = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)] autorelease];
        background.backgroundColor = [UIColor colorWithRed:35.0/255 green: 35.0/255 blue: 35.0/255 alpha: 1.0];
        cell.backgroundView = background;

    }
    
    //create the button
    Event *e = [eventsList objectAtIndex:indexPath.row];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage* image = [imageCache objectForKey:[e->image absoluteString]];
        if (nil == image) {
            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:e->image]];
            [imageCache setObject:image forKey:[e->image absoluteString]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 85)];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.image = image;
            [cell.imageWrapper addSubview:imgView];
        });
    });

    cell.eventName.text = [NSString stringWithFormat:@"%@", e->name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    [self storeAuthData:[[delegate facebook] accessToken] expiresAt:[[delegate facebook] expirationDate]];
}

-(void)fbDidExtendToken:(NSString *)accessToken expiresAt:(NSDate *)expiresAt {
    NSLog(@"token extended");
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
        NSLog(@"My facebook info is %@", result);
        /*nameLabel.text = [NSString stringWithFormat:@"%@ %@.", [result objectForKey:@"first_name"], [[result objectForKey:@"last_name"] substringToIndex:1]];*/
        headerView.usernameOutlet.text = [NSString stringWithFormat:@"%@ %@.", [result objectForKey:@"first_name"], [[result objectForKey:@"last_name"] substringToIndex:1]];
        
        [self apiGraphUserPermissions];
        
        // Send off Tabbie Login req
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString* fbToken = [defaults objectForKey:@"FBAccessTokenKey"];
        eventsList = [[NSMutableArray alloc] initWithCapacity:25];
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
            
            NSString* tonightlifeToken = [ret objectForKey:@"token"];
            NSLog(@"Tonightlife Token=%@", tonightlifeToken);
            [defaults setObject:tonightlifeToken forKey:@"TonightlifeToken"];
            
            // Now that we have token, load events
            NSString* eventUrl = [NSString stringWithFormat:@"http://tonight-life.com/mobile/all.json?auth_token=%@", tonightlifeToken];
            NSData* eventData = [NSData dataWithContentsOfURL:
                            [NSURL URLWithString: eventUrl]];
            
            NSArray* eventList = [NSJSONSerialization JSONObjectWithData:eventData
                                                                options:kNilOptions
                                                                  error:&error];
            NSUInteger len = [eventList count];
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
                
                NSLog(@"Image url is %@", [event objectForKey:@"image_url"]);

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
                                                    : NO];
                
                NSLog(@"Image url2 is %@", [e->image absoluteString]);
                NSLog(@"Event name is %@", [e name]);
                [eventsList addObject:e];
                NSLog(@"Number of events is %d", eventsList.count);
           }
            
            //NSLog(@"Got my events! %@", eventList);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showLoggedIn];
                [self.menuTableView reloadData];
            });
        });
    } else {
        // Processing permissions information
        HackbookAppDelegate *delegate = (HackbookAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setUserPermissions:[[result objectForKey:@"data"] objectAtIndex:0]];
    }
}

/**
 * Called when an error prevents the Facebook API request from completing
 * successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"Err message: %@", [[error userInfo] objectForKey:@"error_msg"]);
    NSLog(@"Err code: %d", [error code]);
}

@end
