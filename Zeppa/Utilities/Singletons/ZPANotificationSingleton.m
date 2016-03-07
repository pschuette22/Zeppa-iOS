//
//  ZPANotification.m
//  Zeppa
//
//  Created by Dheeraj on 13/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPANotificationSingleton.h"
#import "ZPADefaultZeppaEventInfo.h"
#import "ZPADefaultZeppaUserInfo.h"
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
-(GTLServiceZeppaclientapi *) notificationService {
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    
    return service;
}

/**
 * Did receive notification from app engine backend
 * This method dispatches notification information appropriately
 *
 */
-(void)didReceiveZeppaNotification:(NSNumber *)notificationId
{
    // Fetch the current
    [self fetchNotificationById:notificationId];
}
                                                            
-(void)fetchNotificationById:(NSNumber *)notificationId
{

    // If logged in, fetch event
    GTLQueryZeppaclientapi *notificationQuery = [GTLQueryZeppaclientapi queryForGetZeppaNotificationWithIdentifier:notificationId.longLongValue idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];

    // Execute the retrieval query
    [[self notificationService] executeQuery:notificationQuery completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        // If there was an error, handle it
        if(error){
            
        } else if (object){
            GTLZeppaclientapiZeppaNotification *notification = object;
            [self addZeppaNotification:notification];
        }
        
    } ];
    
}


-(void)removeNotificationForEvent:(long long)eventId{

    NSMutableArray * arr = [NSMutableArray array];
    
    for (GTLZeppaclientapiZeppaNotification * notification in _notificationArray) {
        if (notification.eventId != nil && [notification.eventId longLongValue] == eventId) {
            [arr addObject:notification];
        }
    }
    [_notificationArray removeObjectsInArray:arr];
   
}

-(void)removeNotification:(long long)notificationId{
    
    GTLZeppaclientapiZeppaNotification * notification = nil;
    
    for (GTLZeppaclientapiZeppaNotification * n in _notificationArray) {
        if ([n.identifier longLongValue] == notificationId) {
            notification = n;
            break;
        }
    }
    if (notification != nil) {
        [_notificationArray removeObject:notification];
    }
}

-(BOOL)alreadyHoldingNotification:(GTLZeppaclientapiZeppaNotification *)notification{
    
    
    if (_notificationArray.count > 0) {
        for (GTLZeppaclientapiZeppaNotification *notifi in _notificationArray) {
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

// Get an application wide ordinal for the notification type
-(NSInteger)getNotificationTypeOrder:(NSString *)notificationType {
    
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

// Conveninence from prior implementation
-(NSString *)getNotificationTitle:(GTLZeppaclientapiZeppaNotification *)notification{
    
    return [self getNotificationTitleForKey:[notification type]];
}

// Return the title of a notification to be sent provided the notification type
-(NSString *) getNotificationTitleForKey:(NSString*) notificationType {
    NSString *notificationTitle ;
    
    switch ([self getNotificationTypeOrder:notificationType]) {
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
            notificationTitle = @"Event Canceled";
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


-(void)addZeppaNotification:(GTLZeppaclientapiZeppaNotification *)notification{
    
    if (![self alreadyHoldingNotification:notification]) {
        [_notificationArray addObject:notification];
        // Post a notification that a ZeppaNotification has been received
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZeppaNotification" object:notification];
    }
    
    
}

-(void)fetchInitialNotifications:(long long)userId{
    
//    ZPAFetchInitialNotifications * initialNotification = [[ZPAFetchInitialNotifications alloc]init];
//    
//    [initialNotification excuteZeppaApiWithUserId:userId andToken:nil];
}


-(void)executeRemoveNotification:(long long)notificationId{
    
//    ZPAFetchInitialNotifications * initialNotification = [[ZPAFetchInitialNotifications alloc]init];
//    
//    [initialNotification executeZeppaNotificationRemoveQuery:notificationId];

}

@end
