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

#import "GTLServiceZeppanotificationendpoint.h"
#import "GTLQueryZeppanotificationendpoint.h"
#import "GTLZeppanotificationendpointCollectionResponseZeppaNotification.h"
#import "GTLZeppanotificationendpointZeppaNotification.h"
#import "GTLZeppanotificationendpoint.h"
#import "GTLZeppauserinfoendpointZeppaUserInfo.h"

#import "GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship.h"
#import "GTLServiceZeppaeventtouserrelationshipendpoint.h"
#import "GTLZeppaeventtouserrelationshipendpoint.h"
#import "GTLQueryZeppaeventtouserrelationshipendpoint.h"

@interface ZPAFetchInitialNotifications : ZPAUserInfoBaseClass


@property (nonatomic, strong)GTLServiceZeppanotificationendpoint * zeppaNotificationService;

@property (nonatomic,strong)GTLServiceZeppaeventtouserrelationshipendpoint * zeppaEventToUserRelationship;

-(void)excuteZeppaApiWithUserId:(long long)userId andToken:(NSString *)token;
-(void)executeZeppaNotificationRemoveQuery:(long long)notificationId;

@end
