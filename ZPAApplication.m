//
//  ZPAApplication.m
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAApplication.h"
#import "ZPAMyZeppaUser.h"
#import "ZPADeviceInfo.h"
#import "ZPAUserDefault.h"

#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLZeppaclientapiZeppaUser.h"
#import "GTLCalendarCalendarListEntry.h"


@implementation ZPAApplication{
    
    ZPAMyZeppaUser *loggedInUser;
    ZPADeviceInfo *device;
}

+(ZPAApplication *)sharedObject{
    
    static ZPAApplication *app;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        app = [[ZPAApplication alloc] init];
    });
    return app;
}
-(void)initizationsWithCurrentUser:(ZPAMyZeppaUser *)currentUser{
    
    loggedInUser = currentUser;
    ///Update or Insert Device of current user
//    [[ZPADeviceInfo sharedObject] setLoginDeviceForUser:loggedInUser];
    
    ///// Set User Default
    [self setLoggedInUserIdInUserDefault];
    [self setLoggedInAccountEmailInUserDefault];
    
    //Get all mingle for this user
    [self fetchInitialMinglers];
    
    // Load this users event tags
    [self fetchMyEventTags];
    
    ///Set the default settings
    [self setDefaultValueOnSettingScreenIfNeeded];
    
    //Get all Events for this user
    [self fetchInitialEvents];
    
}

-(ZPAMyZeppaUser*) getCurrentUser {
    return loggedInUser;
}


-(void)setLoggedInUserIdInUserDefault{
    
    [ZPAUserDefault storedObject:[NSString stringWithFormat:@"%@",loggedInUser.endPointUser.identifier] withKey:kCurrentZeppaUserId];
    
}
-(void)setLoggedInAccountEmailInUserDefault{
    
    [ZPAUserDefault storedObject:loggedInUser.endPointUser.authEmail withKey:kCurrentZeppaUserEmail];
}
-(void)fetchInitialMinglers{

   
}
-(void)fetchMyEventTags{

    
    
}
-(void)fetchInitialEvents{

    
}

-(void)setDefaultValueOnSettingScreenIfNeeded{
    
    
    if(![ZPAUserDefault isValueExistsForKey:kZeppaSettingNotificationKey]){
        
        // Notifications defaults
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingNotificationKey];
        
        // Ring/Vibrate defaults
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingVibrateKey];
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingRingKey];
        
        // Individual notification type push defaults
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingMingleKey];
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingStartedMingleKey];
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingEventRecommendationsKey];
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingEventInvitesKey];
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingCommentsKey];
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingEventCanceledKey];
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingPeopleJoinKey];
        [ZPAUserDefault storedObject:[NSNumber numberWithBool:YES] withKey:kZeppaSettingPeopleLeaveKey];

    }
}
@end
