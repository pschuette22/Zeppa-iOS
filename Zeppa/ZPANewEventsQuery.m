//
//  ZPANewEventsQuery.m
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPANewEventsQuery.h"

@implementation ZPANewEventsQuery {
    long long _minTimestamp;
}


- (void) executeWithAuthToken:(NSString *)authToken lastCallTimestamp:(long long) timestamp completion:(OnEventQueryCompletion) completion {
    [super executeWithAuthToken:authToken completion:completion];
    _minTimestamp = timestamp;
    
    NSNumber* userId = [self currentUserId];
    if(!userId){
        return;
    }
    // Build the filter string
    NSString *filter = [NSString stringWithFormat:@"userId == %lld && created > %lld && expires > %lld %@",userId.longLongValue,_minTimestamp,[ZPADateHelper currentTimeMillis],[ZPAStaticHelper locationSuffixOrNil]];
    NSString *cursor = nil;
    NSString *ordering = @"created desc"; // order by when this was created descending
    [self queryWithFilter:filter withCursor:cursor withOrdering:ordering];
}

/**
 * Execute a query that will handle the completion
 *  @param filter =
 */
- (void) queryWithFilter:(NSString*) filter withCursor: (NSString*)cursor withOrdering:(NSString*)ordering {
    
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForListZeppaEventToUserRelationshipWithIdToken:[self authToken]];
    
    // Assume that this method could only be called if the current user userId is defined
    query.filter = filter;
    
    query.cursor = cursor;
    query.limit = [self getLimit]; // grab 20 events at a time
    query.ordering = ordering; // No need for ordering for now
    
    // Execute the query with completion handler
    [[self service] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        if(error){
            [self onCompletion:ticket withResponse:nil withError:error];
        } else {
            BOOL isLastQuery = [self addEventsForEventRelationshipResponse:response];
            if(isLastQuery) {
                // was the last query, complete it
                [self onCompletion:ticket withResponse:response withError:error];
            } else {
                // If this wasn't the last page, keep querying until we get it
                [self queryWithFilter:filter withCursor:response.nextPageToken withOrdering:ordering];
            }
        }
    }];
}

@end
