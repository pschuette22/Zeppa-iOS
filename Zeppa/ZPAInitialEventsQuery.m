//
//  ZPAInitialEventsQuery.m
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAInitialEventsQuery.h"

@implementation ZPAInitialEventsQuery {
    NSString *_queryCursor;
    long long _timestamp;
    BOOL _isLastQuery;
}

- (NSString*) getQueryCursor {
    return _queryCursor;
}

- (long long) getTimestamp {
    return _timestamp;
}

- (BOOL) getIsLastQuery {
    return _isLastQuery;
}

// Execute the task. This tasks starts a sequence of tasks
-(void) executeWithAuthToken:(NSString *)authToken completion:(OnEventQueryCompletion) completion {
    [super executeWithAuthToken:authToken completion:completion];
    
    // Start the first task
    [self fetchHostedEventsWithCursor:nil];
}

// Fetch hosted events with a given cursor
- (void) fetchHostedEventsWithCursor:(NSString*)cursor {
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForListZeppaEventWithIdToken:[self authToken]];
    // Get the current user's userid
    NSNumber* userId = [self currentUserId];
    if(!userId){
        return;
    }
    
    query.filter = [NSString stringWithFormat:@"hostId == %lld && expires > %lld",userId.longLongValue, [ZPADateHelper currentTimeMillis]];
    
    query.cursor = cursor;
    query.limit = [self getLimit]; // grab 20 events at a time
     // query.ordering = @"expires asc"; // No need for ordering for now
    
    // Execute the query with completion handler
    [[self service] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEvent *response, NSError *error) {
        if(error){
           // Error was thrown
            [self onCompletion:ticket withResponse:nil withError:error];
        } else {
            BOOL isLastQuery = [self addEventsForEventResponse:response];
            if(isLastQuery) {
                // is the last query, other methods should be invoked
                [self fetchJoinedEventsWithCursor:nil];
            } else {
                [self fetchHostedEventsWithCursor:response.nextPageToken];
            }
        }
    }];
    
}

// Fetch Joined Events
- (void) fetchJoinedEventsWithCursor:(NSString*)cursor {
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[self authToken]];
    
    NSNumber* userId = [self currentUserId];
    if(!userId){
        return;
    }
    // Assume that this method could only be called if the current user userId is defined
    query.filter = [NSString stringWithFormat:@"userId == %lld && expires > %lld && isAttending == 'true'",userId.longLongValue,[ZPADateHelper currentTimeMillis]];
    
    query.cursor = cursor;
    query.limit = [self getLimit]; // grab 20 events at a time
    // query.ordering = @"expires asc"; // No need for ordering for now
    
    // Execute the query with completion handler
    [[self service] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        if(error){
            [self onCompletion:ticket withResponse:nil withError:error];
        } else {
            BOOL isLastQuery = [self addEventsForEventRelationshipResponse:response];
            if(isLastQuery) {
                [self fetchWatchedEventsWithCursor:nil];
            } else {
                [self fetchJoinedEventsWithCursor:response.nextPageToken];
            }
        }
    }];
}

// Fetch Watching Events (that were not joined to avoid doubles)
- (void) fetchWatchedEventsWithCursor:(NSString*)cursor {
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[self authToken]];
    NSNumber* userId = [self currentUserId];
    if(!userId){
        return;
    }
    // Assume that this method could only be called if the current user userId is defined
    query.filter = [NSString stringWithFormat:@"userId == %lld && expires > %lld && isAttending == 'false' && isWatching == 'true'",userId.longLongValue,[ZPADateHelper currentTimeMillis]];
    
    query.cursor = cursor;
    query.limit = [self getLimit]; // grab 20 events at a time
    // query.ordering = @"expires asc"; // No need for ordering for now
    
    // Execute the query with completion handler
    [[self service] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        if(error){
            [self onCompletion:ticket withResponse:nil withError:error];
        } else {
            BOOL isLastQuery = [self addEventsForEventRelationshipResponse:response];
            if(isLastQuery) {
                [self fetchOtherEventsWithCursor:nil];
            } else {
                [self fetchWatchedEventsWithCursor:response.nextPageToken];
            }
        }
    }];
    
}

// Fetch up to 20 events that the user has not interacted with yet
- (void) fetchOtherEventsWithCursor:(NSString*)cursor {
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[self authToken]];
    NSNumber* userId = [self currentUserId];
    if(!userId){
        return;
    }
    // Assume that this method could only be called if the current user userId is defined
    _timestamp = [ZPADateHelper currentTimeMillis];
    query.filter = [NSString stringWithFormat:@"userId == %lld && expires > %lld && isAttending == 'false' && isWatching == 'false' %@",userId.longLongValue,_timestamp, [ZPAStaticHelper locationSuffixOrNil]];
    
    query.cursor = cursor;
    query.limit = [self getLimit]; // grab 20 events at a time
    // query.ordering = @"expires asc"; // No need for ordering for now
    
    // Execute the query with completion handler
    [[self service] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        if(error){
            [self onCompletion:ticket withResponse:nil withError:error];
        } else {
            _isLastQuery = [self addEventsForEventRelationshipResponse:response];
            _queryCursor = response.nextPageToken;
            [self onCompletion:ticket withResponse:response withError:error];
        }
    }];
    
}


@end
