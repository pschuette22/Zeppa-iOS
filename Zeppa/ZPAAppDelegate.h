//
//  ZPAAppDelegate.h
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZPALoginVC.h"
#import "ZPAFetchNotificationTask.h"

//@class GTLServiceTicket;
//typedef void(^ZPAUserEndpointServiceCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);


@interface ZPAAppDelegate : UIResponder <UIApplicationDelegate,ZPALoginVCDelegate,CLLocationManagerDelegate> // GGLInstanceIDDelegate


@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) id swapperClassRef;
@property (nonatomic, strong) NSString *registrationToken;
@property (nonatomic, strong) NSMutableArray *pendingNotifictions;

/*!
 * @description This method is called to indicate that user has Logout from the app.This will take the user out of the main interface to the Login screen. Also it will clear the cache.
 */
+(ZPAAppDelegate *)sharedObject;

-(void)userDidLogoutFromZeppa;
-(void)dispatchNotificationWithTitle: (NSString*) title withBody:(NSString*) body;
-(void)processRemoteNotification: (NSDictionary *) notification withHandler:(void (^)(UIBackgroundFetchResult))handler;



@end
