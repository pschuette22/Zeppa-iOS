//
//  ZPANotification.m
//  Zeppa
//
//  Created by Dheeraj on 13/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPANotificationSingleton.h"
#import "ZPAFetchInitialNotifications.h"
#import "ZPADefaulZeppatEventInfo.h"
#import "ZPADefaulZeppatUserInfo.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPAZeppaUserSingleton.h"

static ZPANotificationSingleton *notif = nil;
BOOL hasLoadedInitial;

@implementation ZPANotificationSingleton
+(ZPANotificationSingleton *)sharedObject{
    if (notif == nil) {
        notif = [[ZPANotificationSingleton alloc]init];
        notif.notificationArray = [[NSMutableArray alloc]init];
        hasLoadedInitial = false;
    }
    return notif;
}
+(void)resetObject{
    
    notif = nil;
}

// Auth object for executing authenticated queries
-(GTLServiceZeppaeventtouserrelationshipendpoint *) zeppaEventRelationshipService {
    static GTLServiceZeppaeventtouserrelationshipendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaeventtouserrelationshipendpoint alloc] init];
        service.retryEnabled = YES;
    }
    
    // Set Auth that is held in the delegate
    [service setAuthorizer: [ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}

/**
 * Did receive notification from app engine backend
 * This method dispatches notification information appropriately
 *
 */
-(void)didReceiveNotification:(NSNumber *)notificationId
{
    // Fetch the current
    [self fetchNotificationById:notificationId];
}
                                                            
-(void)fetchNotificationById:(NSNumber *)notificationId
{

    // If logged in, fetch event
    GTLQueryZeppanotificationendpoint *notificationQuery = [GTLQueryZeppanotificationendpoint queryForGetZeppaNotificationWithIdentifier:notificationId.longLongValue];

}


-(void)removeNotificationForEvent:(long long)eventId{

    NSMutableArray * arr = [NSMutableArray array];
    
    for (GTLZeppanotificationendpointZeppaNotification * notification in _notificationArray) {
        if (notification.eventId != nil && [notification.eventId longLongValue] == eventId) {
            [arr addObject:notification];
        }
    }
    [_notificationArray removeObjectsInArray:arr];
   
}

-(void)removeNotification:(long long)notificationId{
    
    GTLZeppanotificationendpointZeppaNotification * notification = nil;
    
    for (GTLZeppanotificationendpointZeppaNotification * n in _notificationArray) {
        if ([n.identifier longLongValue] == notificationId) {
            notification = n;
            break;
        }
    }
    if (notification != nil) {
        [_notificationArray removeObject:notification];
    }
}

-(BOOL)alreadyHoldingNotification:(GTLZeppanotificationendpointZeppaNotification *)notification{
    
    
    if (_notificationArray.count > 0) {
        for (GTLZeppanotificationendpointZeppaNotification *notifi in _notificationArray) {
            if ([notifi.identifier isEqualToNumber:notification.identifier]) {
                return true;
            }
        }
    }
    return false;

}


-(NSArray *)getNotification{
    
    return _notificationArray;
}

-(BOOL)hasLoadedInitial{
    return hasLoadedInitial;
}

-(void)onLoadedInitialNotification{
    
    hasLoadedInitial = true;
    
    //notifyObserver;
}

-(NSInteger)getNotificationTypeOrder:(GTLZeppanotificationendpointZeppaNotification *)notification{
    
    NSString *notificationType = notification.type;
    
    if ([notificationType isEqualToString:@"MINGLE_REQUEST"]) {
        return 0;
    }else if ([notificationType isEqualToString:@"MINGLE_ACCEPTED"]){
        return 1;
    }else if ([notificationType isEqualToString:@"EVENT_RECOMMENDATION"]){
        return 2;
    }else if ([notificationType isEqualToString:@"DIRECT_INVITE"]){
        return 3;
    }else if ([notificationType isEqualToString:@"COMMENT_ON_POST"]){
        return 4;
    }else if ([notificationType isEqualToString:@"EVENT_CANCELED"]){
        return 5;
    }else if ([notificationType isEqualToString:@"EVENT_UPDATED"]){
        return 6;
    }else if ([notificationType isEqualToString:@"USER_JOINED"]){
        return 7;
    }else if ([notificationType isEqualToString:@"USER_LEAVING"]){
        return 8;
    }else if ([notificationType isEqualToString:@"EVENT_REPOSTED"]){
        return 9;
    }else{
        return -1;
    }
    
}

-(NSString *)getNotificationTitle:(GTLZeppanotificationendpointZeppaNotification *)notification{
    
    NSString *notificationTitle ;
    
    switch ([self getNotificationTypeOrder:notification]) {
        case 0:
            notificationTitle = @"New Request To Mingle";
            break;
        case 1:
            notificationTitle = @"Now Mingling";
            break;
        case 2:
            notificationTitle = @"New Event Recommendation";
            break;
        case 3:
            notificationTitle = @"New Event Invitation";
            break;
        case 4:
            notificationTitle = @"Unread Comment";
            break;
        case 5:
            notificationTitle = @"Event Cancelation";
            break;
        case 6:
            notificationTitle = @"Event Updated";
            break;
        case 7:
            notificationTitle = @"New Event Attendee";
            break;
        case 8:
            notificationTitle = @"Attendee Left Event";
            break;
        case 9:
            notificationTitle = @"Event Reposted";
            break;
            
        default:
            break;
    }
    return notificationTitle;
}

-(NSString *)getNotificationMessage:(GTLZeppanotificationendpointZeppaNotification *)notification{
    
    NSString *notificationMessage;
    ZPADefaulZeppatEventInfo *eventMediator = [ZPADefaulZeppatEventInfo sharedObject] ;
    ZPADefaulZeppatUserInfo *userInfoMediator = [ZPADefaulZeppatUserInfo sharedObject];
    eventMediator.zeppaEvent = [[ZPAZeppaEventSingleton sharedObject]getEventById:[notification.eventId longLongValue]];
    userInfoMediator = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[notification.senderId longLongValue]];
    
    switch ([self getNotificationTypeOrder:notification]) {
        case 0:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ wants to mingle",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName ];
            break;
        case 1:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ accepted mingle request",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName];
            break;
        case 2:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ started %@",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName,eventMediator.zeppaEvent.event.title];
            break;
        case 3:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ invited you to %@",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName,eventMediator.zeppaEvent.event.title];
            break;
        case 4:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ commented on %@",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName,eventMediator.zeppaEvent.event.title];
            break;
        case 5:
            // TODO: figure out how to retrieve canceled event name and put into
            // notification body
            notificationMessage = [NSString stringWithFormat:@"%@ %@ canceled",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName];
            break;
        case 6:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ updated %@",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName,eventMediator.zeppaEvent.event.title];
            break;
        case 7:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ joined %@",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName,eventMediator.zeppaEvent.event.title];
            break;
        case 8:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ left %@",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName,eventMediator.zeppaEvent.event.title];
            break;
        case 9:
            notificationMessage = [NSString stringWithFormat:@"%@ %@ reposted %@",userInfoMediator.zeppaUserInfo.givenName,userInfoMediator.zeppaUserInfo.familyName,eventMediator.zeppaEvent.event.title];
            break;
            
        default:
            break;
    }
    return notificationMessage;
    
}

-(void)addZeppaNotification:(GTLZeppanotificationendpointZeppaNotification *)notification{
    
    if (![self alreadyHoldingNotification:notification]) {
        [_notificationArray addObject:notification];
    }
    
    
}

-(void)fetchInitialNotifications:(long long)userId{
    
    ZPAFetchInitialNotifications * initialNotification = [[ZPAFetchInitialNotifications alloc]init];
    
    [initialNotification excuteZeppaApiWithUserId:userId andToken:nil];
}


-(void)executeRemoveNotification:(long long)notificationId{
    
    ZPAFetchInitialNotifications * initialNotification = [[ZPAFetchInitialNotifications alloc]init];
    
    [initialNotification executeZeppaNotificationRemoveQuery:notificationId];

}
@end
