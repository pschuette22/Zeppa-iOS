//
//  ZPANotificationDelegate.m
//  Zeppa
//
//  Created by Peter Schuette on 8/11/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import "ZPANotificationDelegate.h"

// This follows a singleton pattern
static ZPANotificationDelegate *notificationDelegate = nil;

@implementation ZPANotificationDelegate

// Return the shared notification object instance and initialize objects if necessary
+(ZPANotificationDelegate*) sharedObject{
    
    if(notificationDelegate == nil){
        notificationDelegate = [[ZPANotificationDelegate alloc] init];
        notificationDelegate.pendingNotifications  = [[NSMutableArray alloc] init];
        notificationDelegate.runningTasks = 0;
        notificationDelegate.successCount = 0;
        notificationDelegate.failCount = 0;
    }
    
    return notificationDelegate;
}

-(BOOL)doNotificationPreprocessing:(NSDictionary*)info withCompletionHandler: (void (^)(UIBackgroundFetchResult))handler
{
    // Set the completion handler for this delegate
    [self setCompletionHandler:handler];
    
    // Start processing the notification
    return [self doNotificationPreprocessing:info];
}
/**
 * Preproccess notification info and handle appropriately
 */
-(BOOL)doNotificationPreprocessing:(NSDictionary*)notification
{
 
    NSNumber *currentUserId = [ZPAUserDefault getValueFromUserDefaultUsingKey:kCurrentZeppaUserId];
    NSString* purpose = [notification valueForKey:@"purpose"];
    
    // Notification received has purpose and there is a logged in user
    if(purpose && currentUserId){
        
        // Allocate the Number Formatter
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        
        if ([purpose isEqualToString:@"zeppaNotification"]){
            NSLog(@"Packet received for notification");
            
            // Make sure notification has not expired
            NSString *expireString = [notification valueForKey:@"expires"];
            
            NSNumber *expiresNumber = [f numberFromString:expireString];
            
            if(expiresNumber.longLongValue > [ZPADateHelper currentTimeMillis]){
                NSString *notificationIdString = [notification valueForKey:@"notificationId"];
                
                // Dispatch notification received
                
                NSNumber* notificationId = [f numberFromString:notificationIdString];
                NSLog(@"Do Fetch notification for id: %@", notificationId);
                
                // Determine if auth is valid
                
                ZPAFetchNotificationOnAuth *fetchTask = [[ZPAFetchNotificationOnAuth alloc] initWithNotificationId:notificationId];
                
//                if([ZPAAuthenticatonHandler isAuthValid:[ZPAAuthenticatonHandler sharedAuth].auth]){
//                    // auth is Valid so fetch notification info
//                    self.runningTasks+=1;
//                    [fetchTask execute];
//                } else {
//                    
//                    [self.pendingNotifications addObject:fetchTask];
//                    [[ZPAAuthenticatonHandler sharedAuth] signInWithGooglePlus];
//                }
                //if not create handler for when it is
                
                //if so, fetch notification and objects
                
                
            } else if ([purpose isEqualToString:@"userRelationshipDeleted"]) {
                NSLog(@"Packet received because relationship deleted");
                
                
                // Make sure intended recipient is user
                NSString *recipientIdString = [notification valueForKey:@"recipientId"];
                NSNumber *recipientId = [f numberFromString:recipientIdString];
                
                // Intended recipient is the current user
                if([currentUserId isEqualToNumber:recipientId]){
                    
                    NSString *senderIdString = [notification valueForKey:@"senderId"];
                    NSNumber *senderId = [f numberFromString:senderIdString];
                    [[ZPAZeppaUserSingleton sharedObject] removeHeldMediatorById:senderId.longLongValue];
                }
                
                
            } else if ([purpose isEqualToString:@"eventDeleted"]){
                
                // Event was deleted in backend, make sure it does not exist here
                NSLog(@"Packet received because event deleted");
                
                // Extract the eventId and format
                NSString *eventIdString = [notification valueForKey:@"eventId"];
                NSNumber *eventId = [f numberFromString:eventIdString];
                
                // Call to remove event by the Id
                [[ZPAZeppaEventSingleton sharedObject] removeEventById:eventId.longLongValue];
                
            }
            
            
        }
        
        // Return yes because notification had purpose and was consumed
        return YES;
    }

    // Notification was not consumed, should be handled elsewhere?
    return NO;
}

/**
 * Iterate through list of pending notifications and dispatch them appropriately
 * This is called when application is authenticated
 */
-(void)dispatchPendingNotifications
{
    NSLog(@"Dispatching Pending Notifications");

    if(self.pendingNotifications.count > 0){
        
        // Iterate through list of notifications that should be dispatched
        for(ZPAFetchNotificationOnAuth *fetchTask in self.pendingNotifications){
            self.runningTasks+=1;
            [fetchTask execute];
        }
        
        // Clear notifications. For now, even if they are not successfully dispatched
        [self.pendingNotifications removeAllObjects];
    } else {
        if(self.completionHandler != NULL) {
            self.completionHandler(UIBackgroundFetchResultNoData);
        }
    }
}

-(void)didFinishTaskWithSuccess:(BOOL)success
{
    NSLog(@"Fetch Task Finished with Success: %d", success);

    if(success){
        self.successCount+=1;
    } else {
        self.failCount+=1;
    }
    self.runningTasks-=1;
    
    // If there are not more running tasks, notify client that it is all done
    if(self.runningTasks <= 0){
        [self didFinishAllTasks];
    }
    
}

-(void) didFinishAllTasks
{
    NSLog(@"Finished All Tasks");
    if (self.completionHandler != NULL){
        if(self.successCount > 0){
            self.completionHandler(UIBackgroundFetchResultNewData);
        } else {
            self.completionHandler(UIBackgroundFetchResultNoData);
        }
    }
}



@end
