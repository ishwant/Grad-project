//
//  UAAppDelegate.m
//  Diabetik
//
//  Created by Nial Giacomelli on 05/12/2012.
//  Copyright (c) 2013-2014 Nial Giacomelli
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Dropbox/Dropbox.h>
#import <ShinobiCharts/ShinobiChart.h>
#import <UAAppReviewManager/UAAppReviewManager.h>
#import "GAI.h"
#import "SSKeychainQuery.h"
#import "ShareViewController.h"


#import "UAHelper.h"
#import "UAAppDelegate.h"
#import "UAJournalViewController.h"
#import "UASideMenuViewController.h"
#import "LoginController.h"
#import "SSKeychain.h"
#import "SSKeychainquery.h"


#import "UAReminderController.h"
#import "UALocationController.h"
#import "UAEventController.h"
#import "UASyncController.h"

@implementation UAAppDelegate

#pragma mark - Setup
+ (UAAppDelegate *)sharedAppDelegate
{
    return (UAAppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark - UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialise HockeyApp if we have applicable credentials
 /*   if(
       kHockeyAppBetaIdentifierKey && [kHockeyAppBetaIdentifierKey length] &&
       kHockeyAppLiveIdentifierKey && [kHockeyAppLiveIdentifierKey length]
       )
    {
#ifdef RELEASE_BUILD
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyAppLiveIdentifierKey];
#else
        NSLog(@"Running beta build");
        [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:kHockeyAppBetaIdentifierKey];
#endif
        [[BITHockeyManager sharedHockeyManager] startManager];
        //[[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    } */
    
    // Initialise the Google Analytics API
//TEST    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingID];
    
    // Initialise Appirater
    [UAAppReviewManager setAppID:@"634983291"];
    [UAAppReviewManager setDaysUntilPrompt:2];
    [UAAppReviewManager setUsesUntilPrompt:5];
    [UAAppReviewManager setSignificantEventsUntilPrompt:-1];
    [UAAppReviewManager setDaysBeforeReminding:3];
    [UAAppReviewManager setReviewMessage:NSLocalizedString(@"If you find Diabetik useful you can help support further development by leaving a review on the App Store. It'll only take a minute!", nil)];
  
    // Is this a first run experience?
    if(![[NSUserDefaults standardUserDefaults] boolForKey:kHasRunBeforeKey])
    {
        //delete keychain accounts
        SSKeychainQuery *query = [[SSKeychainQuery alloc] init];
        //2
        query.service = @"graduateProject";
        
        NSArray *accounts = [SSKeychain accountsForService:@"graduateProject"];
        NSLog(@"%lu",(unsigned long)accounts.count);
        for (int i = 0; i < accounts.count ; i++) {
         //   query.account = [accounts objectAtIndex:i];
            [SSKeychain deletePasswordForService:@"graduateProject" account:[accounts objectAtIndex:i][kSSKeychainAccountKey]];
          //  bool checkdelete = [query deleteItem:nil];
          //  NSLog(@"%@", checkdelete);
            NSLog(@"%@",[SSKeychain accountsForService:@"graduateProject"]);
        }
        
        //query.account = @"account2";
        //3
        
        
        // Dump any existing local notifications (handy when the application has been deleted and re-installed,
        // as iOS likes to keep local notifications around for 24 hours)
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasRunBeforeKey];
    }
    
    [self setupDefaultConfigurationValues];
    [self setupStyling];
    
    // Wake up singletons
    [UACoreDataController sharedInstance];
    [UAReminderController sharedInstance];
    [self setBackupController:[[UABackupController alloc] init]];
    
    // Setup our backup controller
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.tintColor = kDefaultTintColor;
    
    LoginController *loginController = [[LoginController alloc] init];
//    self.viewController = loginController;
    
    UAJournalViewController *journalViewController = [[UAJournalViewController alloc] init];
    UANavigationController *navigationController = [[UANavigationController alloc] initWithRootViewController:journalViewController];
    
    REFrostedViewController *viewController = [[REFrostedViewController alloc] initWithContentViewController:navigationController menuViewController:[[UASideMenuViewController alloc] init]];
    viewController.direction = REFrostedViewControllerDirectionLeft;
    viewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    viewController.liveBlur = NO;
    viewController.limitMenuViewSize = YES;
    viewController.blurSaturationDeltaFactor = 3.0f;
    viewController.blurRadius = 10.0f;
    viewController.limitMenuViewSize = YES;
    
    CGFloat menuWidth = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 340.0f : 280.0f;
    viewController.menuViewSize = CGSizeMake(menuWidth, self.window.frame.size.height);
    self.viewController = viewController;
    
    // Delay launch on non-essential classes
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf setupSFX];
            [strongSelf setupDropbox];
            
            // Call various singletons
            [UASyncController sharedInstance];
            [UALocationController sharedInstance];
        });
    });
 //   NSString *user = [keychain objectForKey:(id)kSecAttrAccount];
 //   NSLog(@"username: %@", user);
    
   // NSString *userAccounts = [SSKeychain accountsForService:@"graduateProject"];
 //   NSLog(@"userAccounts: %@", userAccounts);
    
    NSArray *userAccounts = [SSKeychain accountsForService:@"graduateProject"];
    NSString *userPwd;
  //  NSLog(@"%lu",(unsigned long)userAccounts.count);
     for (int i = 0; i < userAccounts.count ; i++) {
   //     NSLog(@"%@",[SSKeychain accountsForService:@"graduateProject"]);
     //   NSLog(@"username: %@", ([userAccounts objectAtIndex:i]));
     //   userPwd=[SSKeychain passwordForService:@"graduateProject" account:[userAccounts objectAtIndex:i]: [acct]];
         userPwd = [SSKeychain passwordForService:@"graduateProject" account:[userAccounts objectAtIndex:i ][kSSKeychainAccountKey]];
       //  userPwd=[SSKeychain passwordForService:@"graduateProject" account:@"u1"];
         NSLog(@"%@", userPwd);
    }

 //   TESTTableViewController *testtableviewcontroller = [[TESTTableViewController alloc] init];
    NSLog(@"password");
    NSLog(@"%@", userPwd);
    NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    if(userPwd==nil){
        NSLog(@"Login is the ROOT");
        [self.window setRootViewController:loginController];
    } else {
        NSLog(@"TabView is the ROOT");
        [self.window setRootViewController:self.viewController];

    }
    
    
//Original    [self.window setRootViewController:self.viewController];
    [self.window makeKeyAndVisible];
    
    
    // Let UAAppReviewManager know our application has launched
    [UAAppReviewManager showPromptIfNecessary];
    
    return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    [[UACoreDataController sharedInstance] saveContext];
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationResumed" object:nil];
    
    // Let UAAppReviewManager know our application has entered the foreground
    [UAAppReviewManager showPromptIfNecessary];
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Delete any expired date-based notifications
    [[UAReminderController sharedInstance] deleteExpiredReminders];
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(NSString *)source annotation:(id)annotation
{
    // Is this Dropbox?
    if([source isEqualToString:@"com.getdropbox.Dropbox"])
    {
        DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
        if (account)
        {
            DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
            [DBFilesystem setSharedFilesystem:filesystem];
            
            // Post a notification so that we can determine when linking occurs
            [[NSNotificationCenter defaultCenter] postNotificationName:kDropboxLinkNotification object:account];
        }
        
        return YES;
    }
    
    return NO;
}

#pragma mark - Logic
- (void)setupDropbox
{
    // Ditch out if we haven't been provided credentials
    if(!kDropboxAppKey || !kDropboxSecret || ![kDropboxAppKey length] || ![kDropboxSecret length]) return;
    
    DBAccountManager *accountMgr = [[DBAccountManager alloc] initWithAppKey:kDropboxAppKey secret:kDropboxSecret];
    [DBAccountManager setSharedManager:accountMgr];
    DBAccount *account = accountMgr.linkedAccount;
    
    if (account)
    {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
}
- (void)setupSFX
{
    [[VKRSAppSoundPlayer sharedInstance] addSoundWithFilename:@"tap" andExtension:@"caf"];
    [[VKRSAppSoundPlayer sharedInstance] addSoundWithFilename:@"pop-view" andExtension:@"caf"];
    [[VKRSAppSoundPlayer sharedInstance] addSoundWithFilename:@"tap-significant" andExtension:@"caf"];
    [[VKRSAppSoundPlayer sharedInstance] addSoundWithFilename:@"success" andExtension:@"caf"];
    [[VKRSAppSoundPlayer sharedInstance] setSoundsEnabled:[[NSUserDefaults standardUserDefaults] boolForKey:kUseSoundsKey]];
}
- (void)setupDefaultConfigurationValues
{
    // Try to determine the users blood sugar unit based on their locale
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              kBGTrackingUnitKey: [NSNumber numberWithInt:([countryCode isEqualToString:@"US"]) ? BGTrackingUnitMG : BGTrackingUnitMMO],
                                                              kMinHealthyBGKey: @4,
                                                              kMaxHealthyBGKey: @7,
                                                              
                                                              kUseSmartInputKey: @YES,
                                                              kUseSoundsKey: @YES,
                                                              kShowInlineImages: @YES,
                                                              kFilterSearchResultsKey: @YES,
                                                              
                                                              kAutomaticBackupFrequencyKey: @(BackupOnceADay),
                                                              }];
    
    
}
- (void)setupStyling
{
    NSDictionary *attributes = nil;
    
    UIColor *defaultBarTintColor = kDefaultBarTintColor;
    [[UINavigationBar appearance] setBarTintColor:defaultBarTintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.0f green:192.0f/255.0f blue:180.0f/255.0f alpha:1.0f]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UAFont standardDemiBoldFontWithSize:17.0f]}];
    
    // UISwitch
    [[UISwitch appearance] setOnTintColor:[UIColor colorWithRed:22.0f/255.0f green:211.0f/255.0f blue:160.0f/255.0f alpha:1.0f]];
    
    // UISegmentedControl
    attributes = @{
                   NSFontAttributeName: [UAFont standardDemiBoldFontWithSize:13.0f],
                   NSForegroundColorAttributeName: [UIColor colorWithRed:22.0f/255.0f green:211.0f/255.0f blue:160.0f/255.0f alpha:1.0f]
                   };
    [[UISegmentedControl appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:22.0f/255.0f green:211.0f/255.0f blue:160.0f/255.0f alpha:1.0f]];
    
    // Charts
    [ShinobiCharts setTheme:[SChartiOS7Theme new]];
}

#pragma mark - Location services
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[UAReminderController sharedInstance] didReceiveLocalNotification:notification];
}

@end
