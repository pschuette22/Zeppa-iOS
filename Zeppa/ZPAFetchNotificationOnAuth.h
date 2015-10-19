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


@interface ZPAFetchNotificationOnAuth: ZPAUserInfoBaseClass

// Authed service objects
@property (nonatomic, strong)GTLServiceZeppaclientapi * zeppaNotificationService;
@property (nonatomic,strong)GTLServiceZeppaclientapi * zeppaEventRelationshipService;


// Notification information
@property (nonatomic, strong)NSNumber *notificationId;
@property (nonatomic, retain)GTLZeppaclientapiZeppaNotification *notification;
//// Sender info

@property (nonatomic, retain) ZPAMyZeppaEvent *eventInfo;
@property (nonatomic, retain) ZPADefaulZeppatUserInfo *senderInfo;

typedef void(^FetchSenderInfoCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);
@property (nonatomic, copy) FetchSenderInfoCompletionBlock fetchSenderInfoCompletionBlock;


// initialize the fetch task with notification ID embedded
-(id) initWithNotificationId: (NSNumber*) notificationId;

// Start the process of fetching information and showing notification
-(void)execute;

// Make sure all information has been fetched before dispatching
-(void)doNotificationPreprocessing;

// Handles displaying information, assuming is has been fetched by the system
-(void)dispatchNotification;




@end