//
//  ZPAAuthenticatonHandler.h
//  Zeppa
//
//  Created by Milan Agarwal on 06/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Google/SignIn.h>
#import "ZPANotificationDelegate.h"
#import "GTMOAuth2ViewControllerTouch.h"

@class GTLCalendarEvent;

@protocol loginWithGoogleSdkDelegate <NSObject>

@required
-(void)loginWithGoogleAuthSuccessfully:(BOOL)condition;

@end


@interface ZPAAuthenticatonHandler : NSObject<GIDSignInDelegate>



//@property (nonatomic , weak) id<loginWithGoogleSdkDelegate>delegate;

@property (nonatomic, strong, readonly) GTMOAuth2Authentication *auth;
//@property (nonatomic, strong, readonly) NSObject *auth;

//@property GPPSignIn *googleSignIn;

+(instancetype)sharedAuth;

//+(BOOL)isAuthValid:(GTMOAuth2Authentication *)auth;
-(void)signInWithGoogleSilently:(BOOL) silently;
-(void)logout;
-(void)getEventsForTheGivenCalendar;
-(void)getEventsForCurrentDay:(NSString * )calendarId;
-(void)getEventsForTheGivenCalendarWithCalendarId:(NSString *)calendarId;
-(NSString*)loggedInUserEmail;


@end
