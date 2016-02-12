//
//  ZPAFetchNotificationOnAuth.m
//  Zeppa
//
//  Created by Peter Schuette on 8/8/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAFetchNotificationTask.h"
#import "ZPAFetchUserInfoTask.h"
#import "ZPAFetchEventInfoTask.h"

@implementation ZPAFetchNotificationTask

// Service for making authenticated notification calls
-(GTLServiceZeppaclientapi *) service {
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    
    return service;
}

/**
 * Initialize the task
 */
-(id) initWithNotificationId: (NSNumber*) notificationId withCompletionHandler: (void (^)(UIBackgroundFetchResult))handler
{
    self = [super init];
    
    if(self){
        self.notificationId = notificationId;
        self.completionHandler = handler;
    }
    
    return self;
}


// Fetch notification and everything involved with it
-(void) execute
{
    __weak typeof(self)  weakSelf = self;
    
    NSLog(@"Executing Fetch Notification Task");
    // Fetch all the data and display
    GTLQueryZeppaclientapi *fetchNotificationTask = [GTLQueryZeppaclientapi queryForGetZeppaNotificationWithIdentifier:_notificationId.longLongValue idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.service executeQuery:fetchNotificationTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaNotification *notification, NSError *error) {
        NSLog(@"Notification Fetch Task Completed");
        if(error){
            NSLog(@"ERROR: %@",error);
            // TODO: handle error and attempt to retry if there is a reason to
            [weakSelf onTaskCompletedWithError:error];
        } else if(notification.identifier){
            weakSelf.notification = notification;
            
            NSNumber *recipientId = notification.recipientId;
            NSNumber *currentUserId = [ZPAUserDefault getValueFromUserDefaultUsingKey:kCurrentZeppaUserId];
            
            // Dispatch notificaiton if it should be consumed by client
            if(recipientId.longLongValue == currentUserId.longLongValue) {
                
                
                // If the sender is missing, start a task to fetch them
                weakSelf.senderInfo = [[ZPAZeppaUserSingleton sharedObject] getZPAUserMediatorById: notification.senderId.longLongValue];
                if(!weakSelf.senderInfo){
                    // Start a task to fetch the other user
                    ZPAFetchUserInfoTask* fetchUserInfoTask = [[ZPAFetchUserInfoTask alloc] initWithCurrentUserId:notification.recipientId withOtherUserId:notification.senderId];
                    [fetchUserInfoTask executeWithCompletionBlock:^(GTLServiceTicket *ticket, id object, NSError *error) {
                        if (object){
                            weakSelf.senderInfo = object;
                        } else if (!error){
                            // Couldn't find the sender. Do not send the notification
                            weakSelf.notification = nil;
                        }
                        [weakSelf onTaskCompletedWithError:error];
                        
                    }];
                }
                
                // If there is an event attached to this object and it is not held, start a task to fetch it
                if(notification.eventId.longLongValue > 0){
                    weakSelf.eventInfo = [[ZPAZeppaEventSingleton sharedObject] getEventById:notification.eventId.longLongValue];
                    if([self.notification.type isEqualToString:@"EVENT_CANCELED"]){
                        // This event was canceled, remove it
                        [[ZPAZeppaEventSingleton sharedObject] removeEventById:notification.eventId.longLongValue];
                        [weakSelf onTaskCompletedWithError:nil];
                    } else if(!weakSelf.eventInfo){
                        // If this notification is regarding a live event and it doesn't exist in local data, retrieve it
                        ZPAFetchEventInfoTask *fetchEventTask = [[ZPAFetchEventInfoTask alloc] initWithEventId:notification.eventId andUserId:notification.recipientId];
                        [fetchEventTask executeWithCompletionBlock:^(GTLServiceTicket *ticket, id object, NSError *error) {
                            if (object){
                                weakSelf.eventInfo = object;
                            } else if (!error){
                                // Couldn't find the event, do not dispatch the notification
                                // Event may have been removed before notification was received
                                weakSelf.eventInfo = nil;
                            }
                            [weakSelf onTaskCompletedWithError:error];

                         }];
                        
                        
                    }
                }
                // Send it through because necessary objects may have been in the app already
                [weakSelf onTaskCompletedWithError:nil];
            } else {
                NSLog(@"received notification in error");
                // TODO: log error and update backend if needed
                // Device likely has two users logged into it erroniously
                // This is a very unlikely scenario
                self.notification = nil;
                [self onTaskCompletedWithError:nil];
            }
        } else {
            NSLog(@"Nil object returned");
            // TODO: ?
            [self onTaskCompletedWithError:nil];
        }
        
    }];
}


// Called when the fetch task has retrieved all entities
-(void)onTaskCompletedWithError: (NSError*) error {
    
    if(error){
        if (self.completionHandler){
            self.completionHandler(UIBackgroundFetchResultFailed);
        }
    } else if (self.notification) {
        
        // Notification was received, if all needed data is held, dispatch the notification
        if(self.senderInfo && (self.notification.eventId.longLongValue<0 || self.eventInfo || [self.notification.type isEqualToString:@"EVENT_CANCELED"])){
            [[ZPANotificationSingleton sharedObject] addZeppaNotification:self.notification];
            if (self.completionHandler){
                self.completionHandler(UIBackgroundFetchResultNewData);
            }
        }
        
    } else {
        if (self.completionHandler){
            self.completionHandler(UIBackgroundFetchResultNoData);
        }
    }
    
}


@end