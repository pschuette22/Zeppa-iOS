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
    
    
    if (![self getUserId]) {
        _isNewUser = YES;
    }
    
    GTLQueryZeppaclientapi *eventQuery = [GTLQueryZeppaclientapi queryForListZeppaEventWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    
    [eventQuery setFilter:[NSString stringWithFormat:@"hostId == %@ && end > %lld",[self getUserId],[ZPADateHelper currentTimeMillis]]];
    
    [eventQuery setCursor: cursorValue];
    [eventQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.zeppaEventService executeQuery:eventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEvent *response, NSError *error) {
        //
        if(error){
            // error
           // [weakSelf fetchInitialNotification];
            
        } else if(response && response.items && response.items.count > 0){
            
            for (GTLZeppaclientapiZeppaEvent *zeppaEvent in response.items) {
                
                ZPAMyZeppaEvent *myevent = [[ZPAMyZeppaEvent alloc]init];
                myevent.event = zeppaEvent;
                myevent.confictStatus = ConflictStatusAttending;
                myevent.isAgenda = YES;
                [[ZPAZeppaEventSingleton sharedObject] addZeppaEvents:myevent];
                
                [self executeZeppaEventRelationshipListQuerywithZeppaEvent:myevent];
                
            }
            // get cursor to query for next page
            NSString *nextCursor = response.nextPageToken;
            if (response.items.count >= 25 && nextCursor) {
                [self executeZeppaEventListQueryWithCursor:nextCursor];
            }else{
                
                [self executeZeppaEventRelationshipListQueryForAttendingWithCursor:nil];
            }
        }else{
            
            [self executeZeppaEventRelationshipListQueryForAttendingWithCursor:nil];
        }
        
    }];
}
-(void)fetchZeppaEventWithIdentifier:(NSNumber *)identifier  withCompletion:(getZeppaEventOject)completion{
    
    GTLQueryZeppaclientapi *eventQuery = [GTLQueryZeppaclientapi queryForGetZeppaEventWithIdentifier:[identifier longLongValue] idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
//    [eventQuery setFilter: [NSString stringWithFormat:@"hostId == %@",identifier]];
//    [eventQuery setCursor: nil];
//    
    [self.zeppaEventService executeQuery:eventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEvent  *response, NSError *error) {
        //
        if(error){
            // error
        } else if(response >0){
            GTLZeppaclientapiZeppaEvent *event = response;
            completion(event);
        }
    }];
}


-(void)executeZeppaEventRelationshipListQueryForAttendingWithCursor:(NSString *)cursorValue{
    
    
    GTLQueryZeppaclientapi *e2uRelationshipQuery = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [e2uRelationshipQuery setFilter:[NSString stringWithFormat:@"userId == %@ && isAttending == true && expires > %lld",[self getUserId],[ZPADateHelper currentTimeMillis]]];
    [e2uRelationshipQuery setCursor:cursorValue];
    
    [e2uRelationshipQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.zeppaEventToUserRelationshipService executeQuery: e2uRelationshipQuery completionHandler: ^(GTLServiceTicket *ticket,  GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        //
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            
            for (GTLZeppaclientapiZeppaEventToUserRelationship *eventToUserRelation in response.items) {
                
                [self fetchZeppaEventWithIdentifier:eventToUserRelation.eventId withCompletion:^(GTLZeppaclientapiZeppaEvent *zeppaEvent) {
                    
                    if([[ZPAZeppaUserSingleton sharedObject] getZPAUserMediatorById:[zeppaEvent.hostId longLongValue]]){
                        
                        
                        [self fetchZeppaUserInfoWithParentIdentifier:eventToUserRelation.userId withCompletion:^(GTLZeppaclientapiZeppaUserInfo *info) {
                            
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
            if (response.items.count >= 25 && currentCursor) {
                [self executeZeppaEventRelationshipListQueryForAttendingWithCursor:currentCursor];
            }else{
                [self executeZeppaEventRelationshipListQueryForWatchingAndAttendingWithCursor:nil];
            }
            
        } else {
            [self executeZeppaEventRelationshipListQueryForWatchingAndAttendingWithCursor:nil];
        }
        
    }];
    
}





-(void)executeZeppaEventRelationshipListQuerywithZeppaEvent:(ZPAMyZeppaEvent *)zeppaEvent{
    
    
    GTLQueryZeppaclientapi *e2uRelationshipQuery = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [e2uRelationshipQuery setFilter:[NSString stringWithFormat:@"eventId == %@",zeppaEvent.event.identifier]];
    //[e2uRelationshipQuery setCursor:cursorValue];
    
    [e2uRelationshipQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.zeppaEventToUserRelationshipService executeQuery: e2uRelationshipQuery completionHandler: ^(GTLServiceTicket *ticket,  GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        //
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
          
            
            for (GTLZeppaclientapiZeppaEventToUserRelationship *eventToUserRelation in response.items) {
                
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
    
    
    GTLQueryZeppaclientapi *e2uRelationshipQuery = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [e2uRelationshipQuery setFilter:[NSString stringWithFormat:@"userId == %@ && isWatching == false && isAttending == false && expires > %lld",[self getUserId],[ZPADateHelper currentTimeMillis]]];
    [e2uRelationshipQuery setCursor:cursorValue];
    [e2uRelationshipQuery setOrdering:@"expires asc"];
    
    [e2uRelationshipQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.zeppaEventToUserRelationshipService executeQuery: e2uRelationshipQuery completionHandler: ^(GTLServiceTicket *ticket,  GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        //
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
//            for (GTLZeppaclientapiZeppaEventToUserRelationship *eventToUserRelation in response.items) {
            
            for (int i=0; i<response.items.count; i++) {
                GTLZeppaclientapiZeppaEventToUserRelationship *eventToUserRelation = (GTLZeppaclientapiZeppaEventToUserRelationship *)[response.items objectAtIndex:i];
          
            
                if (![[ZPAZeppaEventSingleton sharedObject] relationshipAlreadyHeld:eventToUserRelation]) {
                    
                    [self fetchZeppaEventWithIdentifier:eventToUserRelation.eventId withCompletion:^(GTLZeppaclientapiZeppaEvent *zeppaEvent) {
                        
                        if([[ZPAZeppaUserSingleton sharedObject] getZPAUserMediatorById:[zeppaEvent.hostId longLongValue]]){
                            
                            
                            [self fetchZeppaUserInfoWithParentIdentifier:eventToUserRelation.userId withCompletion:^(GTLZeppaclientapiZeppaUserInfo *info) {
                                
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
            if (response.items.count >= 25 && currentCursor) {
                [self executeZeppaEventRelationshipListQueryForWatchingAndAttendingWithCursor:currentCursor];
            }else{
                [self fetchInitialNotification];
            }
            
        } else {
            
            [self fetchInitialNotification];
        }
        
    }];
    
}

-(GTLServiceZeppaclientapi *)zeppaEventToUserRelationshipService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}
-(GTLServiceZeppaclientapi *)zeppaEventService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
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
