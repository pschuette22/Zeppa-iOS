//
//  ZPAMoreEventsQuery.m
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAMoreEventsQuery.h"

@implementation ZPAMoreEventsQuery {
    BOOL _isMoreEvents;
}

/**
 * determine if there are more events to be fetched for this filter
 *
 * returns YES if it is known that there are more events for this filter
 * returns nil or NO if error was thrown, query didn't finish, or there are no more events for this filter
 */
- (BOOL) getIsMoreEvents {
    return _isMoreEvents;
}

/**
 *
 *  Execute a query to fetch more events for a given cursor
 *  @param authToken    - token to verify user identity and authentication
 *  @param cursor       - cursor of last query
 *  @param completion   - block to call when task finishes
 *
 */
- (void) executeWithAuthToken:(NSString *)authToken withCursor:(NSString*) cursor completion:(OnEventQueryCompletion) completion {
    
    NSNumber *userId = [self currentUserId];
    if(!userId){
        // If we cannot get the current user id, don't bother
        return;
    }
    
   GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[self authToken]];
    
    query.filter = [NSString stringWithFormat:@"userId==%lld %% expires>%lld %@",userId.longLongValue,[ZPADateHelper currentTimeMillis],[ZPAStaticHelper locationSuffixOrNil]];
    query.cursor = cursor;
    query.ordering = @"expires asc"; // order by when the event ends, soonest to latest
    query.limit = [self getLimit];
    
    [[self service] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        // execute query and handle completion
        
        if(error) {
            // If there was an error, possibly try to recover in future
        } else {
            // Set indicator that there is more event to the negative of the add events method
            // Add events method returns YES if response indicates it is known no more events will be returned for this query
            _isMoreEvents = ![self addEventsForEventRelationshipResponse:response];
        }
        
        // If there is a completion handler, call it
        if(completion) {
            completion(ticket,response, error);
        }
        
    }];
    
    
}

@end
