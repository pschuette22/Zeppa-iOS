//
//  ZPAFetchNotificationOnAuth.m
//  Zeppa
//
//  Created by Peter Schuette on 8/8/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAFetchNotificationOnAuth.h"
#import "ZPAFetchUserInfoTask.h"
#import "ZPAFetchEventInfoTask.h"
#import "ZPANotificationDelegate.h"

@implementation ZPAFetchNotificationOnAuth

// Service for making authenticated notification calls
-(GTLServiceZeppanotificationendpoint *) zeppaNotificationService {
    static GTLServiceZeppanotificationendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppanotificationendpoint alloc] init];
        service.retryEnabled = YES;
    }
    
    // Set Auth that is held in the delegate
    [service setAuthorizer: [ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}

// Service for making authenticated event relationship calls
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

-(id) initWithNotificationId: (NSNumber*) notificationId
{
    self = [super init];
    
    if(self){
        self.notificationId = notificationId;
    }
    
    return self;
}


// Fetch notification and everything involved with it
-(void) execute
{
    __weak typeof(self)  weakSelf = self;
    
    NSLog(@"Executing Fetch Notification Task");
    // Fetch all the data and display
    GTLQueryZeppanotificationendpoint *fetchNotificationTask = [GTLQueryZeppanotificationendpoint queryForGetZeppaNotificationWithIdentifier:_notificationId.longLongValue];
    
    [self.zeppaNotificationService executeQuery:fetchNotificationTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppanotificationendpointZeppaNotification *notification, NSError *error) {
        NSLog(@"Notification Fetch Task Completed");
        if(error){
            NSLog(@"ERROR: %@",error);
            [[ZPANotificationDelegate sharedObject] didFinishTaskWithSuccess:NO];
        } else if(notification.identifier){
            weakSelf.notification = notification;
            
            NSNumber *recipientId = notification.recipientId;
            NSNumber *currentUserId = [ZPAUserDefault getValueFromUserDefaultUsingKey:kCurrentZeppaUserId];
            
            // Dispatch notificaiton if it should be consumed by client
            if(recipientId.longLongValue == currentUserId.longLongValue) {
                
                weakSelf.senderInfo = [[ZPAZeppaUserSingleton sharedObject] getZPAUserMediatorById:notification.senderId.longLongValue];
                
                if(notification.eventId.longLongValue > 0 && ![self.notification.type isEqualToString:@"EVENT_CANCELED"]){
                    weakSelf.eventInfo = [[ZPAZeppaEventSingleton sharedObject] getEventById:notification.eventId.longLongValue];
                }
                
                [self doNotificationPreprocessing];
            } else {
                NSLog(@"received notification in error");
                // TODO: log error and update backend if needed
                [[ZPANotificationDelegate sharedObject] didFinishTaskWithSuccess:NO];
            }
        } else {
            NSLog(@"Nil object returned");
            [[ZPANotificationDelegate sharedObject] didFinishTaskWithSuccess:NO];

        }
    }];
}

/**
 * This method makes sure all approriate entities have been fetched
 * it may be called multiple times and will only dispatch notification when all data is held
 */
-(void)doNotificationPreprocessing
{
    NSLog(@"Doing Notification Preprocessing");
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;

    
    NSNumber* senderId = [self notification].senderId;
    // Retrieve sender info from the user info singleton
    
    // Sender info is not there, try to retrieve it
    if(!self.senderInfo){
        __weak typeof(self)  weakSelf = self;
        ZPAFetchUserInfoTask* task = [[ZPAFetchUserInfoTask alloc] initWithCurrentUserId:[self notification].recipientId withOtherUserId:senderId];
            
        [task executeWithCompletionBlock:^(GTLServiceTicket *ticket, GTLZeppauserinfoendpointZeppaUserInfo *userInfo, NSError *error) {
            NSLog(@"Sender Info Fetch Task Completed");

            if(error){
                NSLog(@"Error fetching sender (notification will not be retrieved): %@", error);
                [[ZPANotificationDelegate sharedObject] didFinishTaskWithSuccess:NO];
            } else if(userInfo.identifier) {
                NSLog(@"Sender info retrieved, doing preprocessing");
                // Set the objects SenderUserInfoMediator to
                [self setSenderInfo:[[ZPAZeppaUserSingleton sharedObject] getZPAUserMediatorById:senderId.longLongValue]];
                
                [self doNotificationPreprocessing];
            } else {
                NSLog(@"Nil object returned. Will not dispatch notification");
                [[ZPANotificationDelegate sharedObject] didFinishTaskWithSuccess:NO];

            }
        }];
        return;
    }
    
    NSLog(@"Has Sender Info");
    
    
    // If there is an event
    if(self.notification.eventId.longLongValue > 0 && !self.eventInfo && ![self.notification.type isEqualToString:@"EVENT_CANCELED"]){
        NSLog(@"Fetching Event");

        // If not currently holding the eventInfo, fetch it
//            __weak typeof(self) weakSelf = self;
            ZPAFetchEventInfoTask *task = [[ZPAFetchEventInfoTask alloc] initWithEventId:[self notification].eventId andUserId:senderId];
            
            [task executeWithCompletionBlock:^(GTLServiceTicket *ticket, ZPAMyZeppaEvent *event, NSError *error) {
                NSLog(@"Event Info Fetch Task Completed");

                if(error){
                    NSLog(@"Notification did not successfully retrieve event, will not display info");
                    [[ZPANotificationDelegate sharedObject] didFinishTaskWithSuccess:NO];
                } else if (event.event.identifier){
                    
                    [self setEventInfo:event];
                    [self doNotificationPreprocessing];
                    
                } else {

                    [[ZPANotificationDelegate sharedObject] didFinishTaskWithSuccess:NO];
                }
            }];
        return;
    }
    
    NSLog(@"Has Event Info if needed");
    
    [self dispatchNotification];
    
    // TODO: fire observers to update app appropriately
    
}

/**
 * This method handles notifying the user of the new notification/change in local data
 */
-(void) dispatchNotification
{
 
    NSLog(@"Dispatching Notification");

    // Add notification to the singleton if it is successfully dispatched
    [[ZPANotificationSingleton sharedObject] addZeppaNotification:self.notification];
    
//    if([ZPAUserDefault doSendNotificationForType:self.notification.type]){
    
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        if(localNotif){
         
            // Set the fire date to right now
            localNotif.fireDate = [[NSDate alloc] init];
            
            localNotif.alertTitle = [[ZPANotificationSingleton sharedObject] getNotificationTitle:self.notification];
            localNotif.alertBody = [[ZPANotificationSingleton sharedObject] getNotificationMessage:self.notification];
            
            // If application is not active, add action to open app
            if([[UIApplication sharedApplication] applicationState] !=UIApplicationStateActive){
                localNotif.alertAction = NSLocalizedString(@"View", nil);
            }
            
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            
            localNotif.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
            
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
        
//    }
    // Everything was fetched with success, application should display this info
    [[ZPANotificationDelegate sharedObject] didFinishTaskWithSuccess:YES];
    
}


@end