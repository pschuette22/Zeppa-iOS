//
//  ZPAAppDelegate.h
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPALoginVC.h"
#import "GTMOAuth2Authentication.h"
//#import <GoogleOpenSource/GTMOAuth2Authentication.h>

//@class GTLServiceTicket;
//typedef void(^ZPAUserEndpointServiceCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);


@interface ZPAAppDelegate : UIResponder <UIApplicationDelegate,ZPALoginVCDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic ,strong) id swapperClassRef;
@property (strong, nonatomic) NSString *currentDeviceToken;


/*!
 * @description This method is called to indicate that user has Logout from the app.This will take the user out of the main interface to the Login screen. Also it will clear the cache.
 */
+(ZPAAppDelegate *)sharedObject;

-(void)userDidLogoutFromZeppa;

//+(GTLServiceTicket *)executeZeppaUserEndpointQueryWithCompletionBlock:(ZPAUserEndpointServiceCompletionBlock)completion;


@end
