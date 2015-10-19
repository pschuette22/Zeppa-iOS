//
//  ZPAFetchEventInfoTask.m
//  Zeppa
//
//  Created by Peter Schuette on 8/10/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import "ZPAFetchEventInfoTask.h"

@implementation ZPAFetchEventInfoTask


-(id) initWithEventId:(NSNumber *) eventId andUserId:(NSNumber *) userId
{
    self = [super self];
    self.eventId = eventId;
    self.userId = userId;
    return self;
}

-(void) executeWithCompletionBlock: (FetchZeppaEventCompletionBlock) completionBlock{
    [self setCompletionBlock:completionBlock];
    
    // Execute Fetch Event Operation
    [self fetchEvent];
}

-(GTLServiceTicket *) fetchEvent
{
    
    NSLog(@"Executing Fetch Event Task");
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForGetZeppaEventWithIdentifier: self.eventId.longLongValue idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    GTLServiceTicket *ticket = [self.eventService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEvent *event, NSError *error) {
        
        if(error){
            NSLog(@"Error fetching event: %@", error);
            self.completionBlock(ticket,nil,error);
        } else if (event.identifier) {
            NSLog(@"Did Fetch Event");
            [self setZeppaEvent:event];
            [self fetchEventRelationship];
        } else {
            NSLog(@"Nil object returned");
            self.completionBlock(ticket,nil,error);
        }
       
    }];
    
    
    return ticket;
}

/*
 * Fetch a relationship relative to this event. Calls the task object's completion handler
 */
-(GTLServiceTicket *) fetchEventRelationship
{
    
    NSLog(@"Executing Fetch Event Relationship Task");
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    NSString *filter = [NSString stringWithFormat:@"userId == %lld && eventId == %lld",[[[ZPAAppData sharedAppData] loggedInUser] endPointUser].identifier.longLongValue,self.eventId.longLongValue];
    NSLog(@"%@",filter);
    [query setFilter:filter];
    
    GTLServiceTicket *ticket = [self.relationshipService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        if(error){
            NSLog(@"Error Fetching Event Relationship");
            self.completionBlock(ticket,nil,error);
        } else if(response && response.items && response.items.count > 0){
            // Valid response returned. Event has a relationship
            GTLZeppaclientapiZeppaEventToUserRelationship * relationship = [response.items objectAtIndex:0];
            
            // Generate Event Holder Model
            ZPAMyZeppaEvent *event = [[ZPAMyZeppaEvent alloc] init];
            [event setEvent:self.zeppaEvent];
            [event setRelationship:relationship];
            [[ZPAZeppaEventSingleton sharedObject] addZeppaEvents:event];
            
            self.completionBlock(ticket, event, error);
                
        } else {
            self.completionBlock(ticket,nil,error);
        }
        
    }];
    
    return ticket;
}



-(GTLServiceZeppaclientapi *) eventService
{
    static GTLServiceZeppaclientapi *eventService = nil;
    if(!eventService){
        eventService = [[GTLServiceZeppaclientapi alloc] init];
        eventService.retryEnabled = YES;
    }
    return eventService;
}

-(GTLServiceZeppaclientapi *) relationshipService
{
    static GTLServiceZeppaclientapi *relationshipService = nil;
    
    if(!relationshipService){
        relationshipService = [[GTLServiceZeppaclientapi alloc] init];
        relationshipService.retryEnabled = YES;
    }
    
    return relationshipService;
}

@end
