//
//  ZPAFetchInitialEvents.m
//  Zeppa
//
//  Created by Dheeraj on 17/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAFetchInitialEvents.h"
#import "ZPAMyZeppaEvent.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaulZeppatEventInfo.h"
#import "ZPAFetchInitialNotifications.h"
#import "ZPAZeppaEventTagSingleton.h"


@implementation ZPAFetchInitialEvents

-(void)executeZeppaApi{
    
    [self executeZeppaEventListQueryWithCursor:nil];
  
}
-(NSNumber *)getUserId{
 return  [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
    
}
-(void)executeZeppaEventListQueryWithCursor:(NSString *)cursorValue{
    
    __weak typeof(self) weakSelf = self;
    
    if (![self getUserId]) {
        _isNewUser = YES;
    }
    
    GTLQueryZeppaeventendpoint *eventQuery = [GTLQueryZeppaeventendpoint queryForListZeppaEvent];
    
    
    [eventQuery setFilter:[NSString stringWithFormat:@"hostId == %@ && end > %lld",                            [self getUserId],[ZPADateHelper currentTimeMillis]]];
    
    [eventQuery setCursor: cursorValue];
    [eventQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.zeppaEventService executeQuery:eventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaeventendpointCollectionResponseZeppaEvent *response, NSError *error) {
        //
        if(error){
            // error
           // [weakSelf fetchInitialNotification];
            
        } else if(response && response.items && response.items.count > 0){
            
            for (GTLZeppaeventendpointZeppaEvent *zeppaEvent in response.items) {
                
                ZPAMyZeppaEvent *myevent = [[ZPAMyZeppaEvent alloc]init];
                myevent.event = zeppaEvent;
                myevent.confictStatus = ConflictStatusAttending;
                myevent.isAgenda = YES;
                [[ZPAZeppaEventSingleton sharedObject] addZeppaEvents:myevent];
                
                [weakSelf executeZeppaEventRelationshipListQuerywithZeppaEvent:myevent];
                
            }
            // get cursor to query for next page
            NSString *nextCursor = response.nextPageToken;
            if (nextCursor) {
                [weakSelf executeZeppaEventListQueryWithCursor:nextCursor];
            }else{
                
                [weakSelf executeZeppaEventRelationshipListQueryForAttendingWithCursor:nil];
            }
        }else{
            
            [weakSelf executeZeppaEventRelationshipListQueryForAttendingWithCursor:nil];
        }
        
    }];
}
-(void)fetchZeppaEventWithIdentifier:(NSNumber *)identifier  withCompletion:(getZeppaEventOject)completion{
    
    GTLQueryZeppaeventendpoint *eventQuery = [GTLQueryZeppaeventendpoint queryForGetZeppaEventWithIdentifier:[identifier longLongValue]];
    
//    [eventQuery setFilter: [NSString stringWithFormat:@"hostId == %@",identifier]];
//    [eventQuery setCursor: nil];
//    
    [self.zeppaEventService executeQuery:eventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaeventendpointZeppaEvent  *response, NSError *error) {
        //
        if(error){
            // error
        } else if(response >0){
            GTLZeppaeventendpointZeppaEvent *event = response;
            completion(event);
        }
    }];
}


-(void)executeZeppaEventRelationshipListQueryForAttendingWithCursor:(NSString *)cursorValue{
    
    
    __weak typeof(self) weakSelf = self;
    GTLQueryZeppaeventtouserrelationshipendpoint *e2uRelationshipQuery = [GTLQueryZeppaeventtouserrelationshipendpoint queryForListZeppaEventToUserRelationship];
    
    [e2uRelationshipQuery setFilter:[NSString stringWithFormat:@"userId == %@ && isAttending == true && expires > %lld",[self getUserId],[ZPADateHelper currentTimeMillis]]];
    [e2uRelationshipQuery setCursor:cursorValue];
    
    [e2uRelationshipQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.zeppaEventToUserRelationshipService executeQuery: e2uRelationshipQuery completionHandler: ^(GTLServiceTicket *ticket,  GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        //
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            
            for (GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *eventToUserRelation in response.items) {
                
                [weakSelf fetchZeppaEventWithIdentifier:eventToUserRelation.eventId withCompletion:^(GTLZeppaeventendpointZeppaEvent *zeppaEvent) {
                    
                    if([[ZPAZeppaUserSingleton sharedObject] getZPAUserMediatorById:[zeppaEvent.hostId longLongValue]]){
                        
                        
                        [weakSelf fetchZeppaUserInfoWithParentIdentifier:eventToUserRelation.userId withCompletion:^(GTLZeppauserinfoendpointZeppaUserInfo *info) {
                            
                            [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:info andRelationShip:nil];
                        }];
                        
                    }
                    
                    ZPAMyZeppaEvent *myevent = [[ZPAMyZeppaEvent alloc]init];
                    myevent.event = zeppaEvent;
                    myevent.relationship = eventToUserRelation;
                    [myevent.relationships addObject:eventToUserRelation];
                    [[ZPAZeppaEventSingleton sharedObject] addZeppaEvents:myevent];
                    
                    [[ZPAZeppaEventSingleton sharedObject].relationships addObject:eventToUserRelation];
                    
                    
                }];
            }
            NSString *currentCursor = response.nextPageToken;
            if (currentCursor) {
                [weakSelf executeZeppaEventRelationshipListQueryForAttendingWithCursor:currentCursor];
            }else{
                [weakSelf executeZeppaEventRelationshipListQueryForWatchingAndAttendingWithCursor:nil];
            }
            
        } else {
            [weakSelf executeZeppaEventRelationshipListQueryForWatchingAndAttendingWithCursor:nil];
        }
        
    }];
    
}





-(void)executeZeppaEventRelationshipListQuerywithZeppaEvent:(ZPAMyZeppaEvent *)zeppaEvent{
    
    
    __weak typeof(self) weakSelf = self;
    GTLQueryZeppaeventtouserrelationshipendpoint *e2uRelationshipQuery = [GTLQueryZeppaeventtouserrelationshipendpoint queryForListZeppaEventToUserRelationship];
    
    [e2uRelationshipQuery setFilter:[NSString stringWithFormat:@"eventId == %@",zeppaEvent.event.identifier]];
    //[e2uRelationshipQuery setCursor:cursorValue];
    
    [e2uRelationshipQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.zeppaEventToUserRelationshipService executeQuery: e2uRelationshipQuery completionHandler: ^(GTLServiceTicket *ticket,  GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        //
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
          
            
            for (GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *eventToUserRelation in response.items) {
                
                    zeppaEvent.relationship = eventToUserRelation;
                   // [zeppaEvent.relationships addObject:eventToUserRelation];
                
                
                    
                    [[ZPAZeppaEventSingleton sharedObject].relationships addObject:eventToUserRelation];
                  
                
                
                }
            
            
        } else {
          //  [weakSelf executeZeppaEventRelationshipListQueryForWatchingAndAttendingWithCursor:nil];
        }
        
    }];
    
}
-(void)executeZeppaEventRelationshipListQueryForWatchingAndAttendingWithCursor:(NSString *)cursorValue{
    
    
    __weak typeof(self) weakSelf = self;
    GTLQueryZeppaeventtouserrelationshipendpoint *e2uRelationshipQuery = [GTLQueryZeppaeventtouserrelationshipendpoint queryForListZeppaEventToUserRelationship];
    
    [e2uRelationshipQuery setFilter:[NSString stringWithFormat:@"userId == %@ && isWatching == false && isAttending == false && expires > %lld",[self getUserId],[ZPADateHelper currentTimeMillis]]];
    [e2uRelationshipQuery setCursor:cursorValue];
    [e2uRelationshipQuery setOrdering:@"expires asc"];
    
    [e2uRelationshipQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.zeppaEventToUserRelationshipService executeQuery: e2uRelationshipQuery completionHandler: ^(GTLServiceTicket *ticket,  GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        //
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
//            for (GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *eventToUserRelation in response.items) {
            
            for (int i=0; i<response.items.count; i++) {
                GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *eventToUserRelation = (GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *)[response.items objectAtIndex:i];
          
            
                if (![[ZPAZeppaEventSingleton sharedObject] relationshipAlreadyHeld:eventToUserRelation]) {
                    
                    [weakSelf fetchZeppaEventWithIdentifier:eventToUserRelation.eventId withCompletion:^(GTLZeppaeventendpointZeppaEvent *zeppaEvent) {
                        
                        if([[ZPAZeppaUserSingleton sharedObject] getZPAUserMediatorById:[zeppaEvent.hostId longLongValue]]){
                            
                            
                            [weakSelf fetchZeppaUserInfoWithParentIdentifier:eventToUserRelation.userId withCompletion:^(GTLZeppauserinfoendpointZeppaUserInfo *info) {
                                
                                [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:info andRelationShip:nil];
                            }];
                            
                        }
                        
                        ZPAMyZeppaEvent *myevent = [[ZPAMyZeppaEvent alloc]init];
                        myevent.event = zeppaEvent;
                        myevent.relationship = eventToUserRelation;
                        [myevent.relationships addObject:eventToUserRelation];
                        [[ZPAZeppaEventSingleton sharedObject] addZeppaEvents:myevent];
                        [[ZPAZeppaEventSingleton sharedObject].relationships addObject:eventToUserRelation];
                         
                        
                    }];
                }
            }
            
            NSString *currentCursor = response.nextPageToken;
            if (currentCursor) {
                [weakSelf executeZeppaEventRelationshipListQueryForWatchingAndAttendingWithCursor:currentCursor];
            }else{
                [weakSelf fetchInitialNotification];
            }
            
        } else {
            
            [weakSelf fetchInitialNotification];
        }
        
    }];
    
}

-(GTLServiceZeppaeventtouserrelationshipendpoint *)zeppaEventToUserRelationshipService{
    
    static GTLServiceZeppaeventtouserrelationshipendpoint *service = nil;
    if(!service){
        service = [[GTLServiceZeppaeventtouserrelationshipendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
    
}
-(GTLServiceZeppaeventendpoint *)zeppaEventService{
    
    static GTLServiceZeppaeventendpoint *service = nil;
    if(!service){
        service = [[GTLServiceZeppaeventendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer: [ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}

///*******************************************************
#pragma  mark - InitialNotification Class Initializaiton
///*******************************************************
-(void)fetchInitialNotification{
    
    [[ZPAZeppaEventSingleton sharedObject] notificationChangeForEvents];
    
    ZPAFetchInitialNotifications *fetchInitial =  [[ZPAFetchInitialNotifications alloc]init];
   // [fetchInitial excuteZeppaApi];
    
    [fetchInitial excuteZeppaApiWithUserId:[[self getUserId] longLongValue] andToken:nil];
    
}
@end
