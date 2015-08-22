//
//  ZPAAppDelegate.m
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAAppDelegate.h"
#import <Google/SignIn.h>
#import "ZPASplitVC.h"
#import "ZPADeviceInfo.h"
#import "ZPANotificationSingleton.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPAUserDefault.h"
#import "ZPANotificationDelegate.h"

@interface ZPAAppDelegate ()

//@property(nonatomic, strong) void (^registrationHandler)
//    (NSString *registrationToken, NSError *error);
//@property(nonatomic, assign) BOOL connectedToGCM;
//@property(nonatomic, strong) NSString* registrationToken;

@end


@implementation ZPAAppDelegate {
    
}

+(ZPAAppDelegate *)sharedObject{
    
    return (ZPAAppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    
    
    // Override point for customization after application launch.
    id rootVC = self.window.rootViewController;
    if ([rootVC isKindOfClass:[ZPALoginVC class]]) {
        [(ZPALoginVC *)rootVC setDelegate:self];
    }
    

    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:10.0f/255.0 green:210.0f/255.0 blue:255.0f/255.0 alpha:1.0]];
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UISwitch appearance]setOnTintColor:[UIColor colorWithRed:10.0f/255.0 green:210.0f/255.0 blue:255.0f/255.0 alpha:1.0]];
    
    
    // Register for user notifications in iOS 8 or later
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)]){
        
        // Register for local notifications
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    // TODO: implement local notification registration if old devices are not receiving them
    
    
    // Register for remote notifications
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        // iOS 8 or later
        // [END_EXCLUDE]
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        // iOS 7.1 or earlier
        UIRemoteNotificationType allNotificationTypes =
        (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge);
        [application registerForRemoteNotificationTypes:allNotificationTypes];
    }
    
    

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// [START ack_message_reception]
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Notification received - no handler: %@", userInfo);
    
    // Notication was consumed here
    if ([[ZPANotificationDelegate sharedObject] doNotificationPreprocessing:userInfo]){
        NSLog(@"Did dispatch ");
    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler {
    
    NSLog(@"Notification received - with handler: %@", userInfo);
    [[ZPANotificationDelegate sharedObject] doNotificationPreprocessing:userInfo];
    
    
    if(handler != NULL)
        handler(UIBackgroundFetchResultNewData);
    
}

- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // TODO: handle additional stuff when a local notification is received
    if(notif){
        
    }
}



//****************************************************
#pragma mark - Private Methods
//****************************************************

/*!
 * @description This will check if there is any other task left to do before showing Main Interface to user
 * @return  YES if main interface can be shown otherwise it returns NO.
 */

-(BOOL)shouldProceedToMainInterface
{
    return YES;
}

//****************************************************
#pragma mark - Public Interface
//****************************************************

-(void)userDidLogoutFromZeppa
{
    ///Clear stored cache from the app for the current user
    ///1) Delete object for key kZeppaLoggedInUserGooglePlusIdKey
    ///2) Remove access token and refresh token file
    
///Note: Do not delete saved ZPAUser object saved with GooglePlus Id key in order to fetch this object in case of re login attempt.
    
    ///Show Login Screen
    ZPALoginVC *loginVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ZPALoginVC"];
    loginVC.delegate = self;
    self.window.rootViewController = loginVC;
}

/*
+(GTLServiceTicket *)executeZeppaUserEndpointQueryWithCompletionBlock:(ZPAUserEndpointServiceCompletionBlock)completion
{
    ///Addded by Milan to test Google App Engine End Point
    ///Create ZeppaUserEndPoint Service
        static GTLServiceZeppauserendpoint *zeppaUserService = nil;
        if (!zeppaUserService) {
            zeppaUserService = [[GTLServiceZeppauserendpoint alloc]init];
            zeppaUserService.retryEnabled = YES;
 //           [zeppaUserService setAuthorizer:(id<GTMFetcherAuthorizationProtocol>)[GPPSignIn sharedInstance].authentication];
        }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *googleProfileID = [defaults objectForKey:kZeppaLoggedInUserGooglePlusIdKey];
    
        ///Create a query object
//        GTLQueryZeppauserendpoint *zeppaUserQuery = [GTLQueryZeppauserendpoint queryForFetchMatchingUserWithProfileId:googleProfileID];
    GTLQueryZeppauserendpoint *zeppaUserQuery = [GTLQueryZeppauserendpoint queryForListZeppaUser];
  
        GTLServiceTicket *ticket = [zeppaUserService executeQuery:zeppaUserQuery completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            if (!error) {
                GTLZeppauserendpointZeppaUser *zeppaUser = object;
                NSLog(@"%@",zeppaUser);
            }
            else{
    
                NSLog(@"Error in GTLQueryZeppauserendpoint %@",error.localizedDescription);
                
            }
            
        }];
    
    return ticket;
    
}
*/

//****************************************************
#pragma mark - ZPALoginVCDelegate Methods
//****************************************************

-(void)zpaLoginVC:(ZPALoginVC *)loginVC didLogInWithUser:(ZPAMyZeppaUser *)user
{
    ///Store the logged in user object in singleton
    [ZPAAppData sharedAppData].loggedInUser = user;
    
        ///Show Main Interface
    ZPASplitVC *splitVC = [self.window.rootViewController.storyboard instantiateViewControllerWithIdentifier:@"ZPASplitVC"];
    self.window.rootViewController = splitVC;

}

/*
 * Callback when app successfully registers for push notifications
 * Taken from: https://developers.google.com/cloud-messaging/ios/client
 */
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    self.registrationToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", self.registrationToken);
    
    [[ZPADeviceInfo sharedObject] setDoUpdateToken:YES];
    // if there is current device, update the device in the backend
    if([ZPADeviceInfo sharedObject].currentDevice){
        [[[ZPADeviceInfo sharedObject] currentDevice] setRegistrationId:_registrationToken];
        [[ZPADeviceInfo sharedObject] updateDeviceInfoWithObject:[[ZPADeviceInfo sharedObject] currentDevice]];
    } else if([ZPAZeppaUserSingleton sharedObject].zeppaUser) {
        [[ZPADeviceInfo sharedObject] setLoginDeviceForUser:[ZPAZeppaUserSingleton sharedObject].zeppaUser];
    }
    


    

}

/*!
 * Display an alert from Zeppa
 */
-(void) showAlertFromZeppa: (NSString*) title withMessage:(NSString*) message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}





@end
