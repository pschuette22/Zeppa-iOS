//
//  ZPAFetchInitialNotifications.m
//  Zeppa
//
//  Created by Dheeraj on 17/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAFetchInitialNotifications.h"

#import "ZPAZeppaUserSingleton.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPANotificationSingleton.h"

@implementation ZPAFetchInitialNotifications{
    long long _userId;
    
}

-(void)excuteZeppaApiWithUserId:(long long)userId andToken:(NSString *)token{
    
    _userId = userId;
   
    [self executeZeppaNotificationListQueryWithUserIdandCursorValue:nil];
    
}

-(void)executeZeppaNotificationListQueryWithUserIdandCursorValue:(NSString * )cursorValue{

    
    __weak typeof(self) weakSelf = self;
    
    NSString * filterString= [NSString stringWithFormat:@"recipientId == %lld && expires > %lld",_userId,[ZPADateHelper currentTimeMillis]];
    

    GTLQueryZeppanotificationendpoint *notificationQuery = [GTLQueryZeppanotificationendpoint queryForListZeppaNotification];
    [notificationQuery setFilter:filterString];
    [notificationQuery setCursor:cursorValue];
   // [notificationQuery setOrdering:ordering];
    //[notificationQuery setLimit:[limit integerValue]];
    
    [self.zeppaNotificationService executeQuery:notificationQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppanotificationendpointCollectionResponseZeppaNotification *response, NSError *error) {
        //
        
        if(error){
           // [resultView setText:error.description];
        } else if(response && response.items && response.items.count > 0){
                
            
                for (GTLZeppanotificationendpointZeppaNotification * zeppaNotification in response.items) {
                 
                    if ([[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[zeppaNotification.senderId longLongValue]]== nil) {
                        
                        [weakSelf fetchZeppaUserInfoWithParentIdentifier:zeppaNotification.senderId withCompletion:^(GTLZeppauserinfoendpointZeppaUserInfo *info) {
                            
                            
                            [[ZPAZeppaUserSingleton sharedObject]addDefaultZeppaUserMediatorWithUserInfo:info andRelationShip:nil];
                            
                        }];
                        
                    }
                    if (zeppaNotification.eventId != nil &&  [[ZPAZeppaEventSingleton sharedObject]getEventById:[zeppaNotification.eventId longLongValue]] == nil) {
                        
                        ZPAMyZeppaEvent * zeppaEvent = [[ZPAMyZeppaEvent alloc]init];
                        
                        zeppaEvent = [[ZPAZeppaEventSingleton sharedObject]getEventById:[zeppaNotification.eventId longLongValue]];
                        
                        [weakSelf executeZeppaEventToUserRelationShipList:zeppaEvent];
                        
                    }
                    
                    if ([[ZPAZeppaEventSingleton sharedObject]getEventById:[zeppaNotification.eventId longLongValue]] != nil) {
                        
                        [[ZPANotificationSingleton sharedObject]addZeppaNotification:zeppaNotification];
                    }
                    
                    
                    
                    
                }
                
                NSString *nextCursor = response.nextPageToken;
                if (nextCursor) {
                    [weakSelf executeZeppaNotificationListQueryWithUserIdandCursorValue:nextCursor];
                }
            
            // Unnecessary infinite loop
//                else{
//                    [weakSelf executeZeppaNotificationListQueryWithUserIdandCursorValue:nil];
//                }
            
            
                
            }
        else {
               // [resultView setText:@"No ZeppaNotification objects returned"];
                NSLog(@"No ZeppaNotification objects returned");
//                [weakSelf executeZeppaNotificationListQueryWithUserIdandCursorValue:nil];
            }
     
    }];
    
    
}

-(void)executeZeppaEventToUserRelationShipList:(ZPAMyZeppaEvent *)zeppaEvent{
    
    GTLQueryZeppaeventtouserrelationshipendpoint *e2uRelationshipQuery = [GTLQueryZeppaeventtouserrelationshipendpoint queryForListZeppaEventToUserRelationship];
    
    NSString * filter = [NSString stringWithFormat:@"eventId == %@ && userId == %lld",zeppaEvent.event.identifier ,_userId ];
    
    [e2uRelationshipQuery setFilter:filter];
//    [e2uRelationshipQuery setCursor:cursor];
//    [e2uRelationshipQuery setOrdering:ordering];
//    [e2uRelationshipQuery setLimit:[limit integerValue]];
    
    [self.zeppaEventToUserRelationship executeQuery: e2uRelationshipQuery completionHandler: ^(GTLServiceTicket *ticket,  GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        //
        
        if(error){
            //[resultView setText:error.description];
        } else {
            
            if(response == nil || response.items == nil || response.items.count !=1){
                return ;
            }
            
            zeppaEvent.event = [response.items firstObject];
            
            [[ZPAZeppaEventSingleton sharedObject]addZeppaEvents:zeppaEvent];
        }
        
//            if(response && response.items && response.items.count > 0){
//                
//                
//                NSArray *items = response.items;
//                int count = (int) items.count;
//                
//                NSMutableString *result = [[NSMutableString alloc] init];
//                [result appendString:@"ZeppaEventToUserRelationshipCollectionResponse: {\n"];
//                
//                
//                for(int i = 0; i < count; i++){
//                    
//                    GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *relationship = [items objectAtIndex: i];
//                    
//                    
//                
//              //  [resultView setText:result];
//               // [cursorField setText:response.nextPageToken];
//                
//                
//            } else {
////                [resultView setText:@"No ZeppaEventToUserRelationships returned"];
//            }
//            
//        }
        
    }];
    

    
    
    
}

-(void)executeZeppaNotificationRemoveQuery:(long long)notificationId{
    
    GTLQueryZeppanotificationendpoint * removeQuery = [GTLQueryZeppanotificationendpoint queryForRemoveZeppaNotificationWithIdentifier:notificationId];
    
    [self.zeppaNotificationService executeQuery:removeQuery completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (!error) {
            NSLog(@"notification removed successfully");
            
            [[ZPANotificationSingleton sharedObject]removeNotification:notificationId];

        }
        
    } ];
}


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




    

@end
