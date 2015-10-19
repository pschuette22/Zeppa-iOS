//
//  ZPAFetchInitialNotifications.h
//  Zeppa
//
//  Created by Dheeraj on 17/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAAuthenticatonHandler.h"
#import "ZPAUserInfoBaseClass.h"

#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLZeppaclientapiCollectionResponseZeppaNotification.h"
#import "GTLZeppaclientapiZeppaNotification.h"
#import "GTLZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship.h"

@interface ZPAFetchInitialNotifications : ZPAUserInfoBaseClass


@property (nonatomic, strong)GTLServiceZeppaclientapi * zeppaNotificationService;

@property (nonatomic,strong)GTLServiceZeppaclientapi * zeppaEventToUserRelationship;

-(void)excuteZeppaApiWithUserId:(long long)userId andToken:(NSString *)token;
-(void)executeZeppaNotificationRemoveQuery:(long long)notificationId;

@end
