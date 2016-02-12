//
//  ZPAFetchNotificationOnAuth.h
//  Zeppa
//
//  Created by Peter Schuette on 8/8/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import "ZPAUserInfoBaseClass.h"
#import "ZPAAuthenticatonHandler.h"

#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLZeppaclientapiCollectionResponseZeppaNotification.h"
#import "GTLZeppaclientapiZeppaNotification.h"
#import "GTLZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship.h"

#import "ZPAZeppaEventSingleton.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPANotificationSingleton.h"

#import "ZPADefaulZeppatUserInfo.h"
#import "ZPAEventInfoBaseClass.h"
#import "ZPAUserDefault.h"
#import "ZPAConstants.h"


@interface ZPAFetchNotificationTask: ZPAUserInfoBaseClass

// Authed service objects
@property (nonatomic, strong)GTLServiceZeppaclientapi * service;

// Notification information / related objects
@property (nonatomic, strong) NSNumber *notificationId;
@property (nonatomic, retain) GTLZeppaclientapiZeppaNotification *notification;
@property (nonatomic, retain) ZPAMyZeppaEvent *eventInfo;
@property (nonatomic, retain) ZPADefaulZeppatUserInfo *senderInfo;

typedef void(^FetchSenderInfoCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);
@property (nonatomic, copy) FetchSenderInfoCompletionBlock fetchSenderInfoCompletionBlock;

// Task completion handler
@property (nonatomic, copy) void (^completionHandler)(UIBackgroundFetchResult);


// initialize the fetch task with notification ID embedded
-(id) initWithNotificationId: (NSNumber*) notificationId withCompletionHandler: (void (^)(UIBackgroundFetchResult))handler;

// Start the process of fetching information and showing notification
-(void)execute;

// When the task has successfully completed
-(void)onTaskCompletedWithError: (NSError*) error;

@end