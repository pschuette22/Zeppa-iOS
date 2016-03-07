//
//  ZPABaseEventsQuery.m
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPABaseEventsQuery.h"
#import "ZPAMyZeppaEvent.h"
#import "ZPADefaultZeppaEventInfo.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPAZeppaEventSingleton.h"
#import "GTLZeppaclientapi.h"


@implementation ZPABaseEventsQuery {
    NSString *_authToken;
    OnEventQueryCompletion _onEventQueryCompletion;
    GTLServiceTicket *_ticket;
    GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *_response;
    NSError *_error;
}

- (void) executeWithAuthToken:(NSString *)authToken completion:(OnEventQueryCompletion) completion {
    // This should be overridden by child tasks
    _authToken = authToken;
    _onEventQueryCompletion = completion;
}

// Here so child processes may access the service object
-(GTLServiceZeppaclientapi*) service {
    static GTLServiceZeppaclientapi *service;
    
    if(service==nil){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    
    return service;
}

// The auth token for making authenticated calls to backend
- (NSString*) authToken {
    return _authToken;
}

// The limit to the number of items to return in a query
- (NSInteger) getLimit {
    return 20;
}

-(NSNumber *) currentUserId {
    NSNumber* userId = [[ZPAZeppaUserSingleton sharedObject] getMyZeppaUserIdentifier];
    if(!userId){
        // The user id is not set, complete quickly
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey: NSLocalizedString(@"Operation did not execute.", nil),
                                   NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Logged in ZeppaUser is not set.", nil),
                                   NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Are you sure you're logged in?", nil)
                                   };
        // Local error indicating the user is not authorized to make this call
        NSError *error = [[NSError alloc] initWithDomain:@"com.zeppamobile.zeppaios" code:401 userInfo:userInfo];
        [self onCompletion:nil withResponse:nil withError: error];
        return nil;
    }
    return userId;
}

/**
 * Add all items in an event list query to the ZPAZeppaEventSingleton
 * 
 * returns YES if this query will return no new events (if provided a )
 */
- (BOOL) addEventsForEventResponse: (GTLZeppaclientapiCollectionResponseZeppaEvent *)response {
    if(response && response.items && response.items.count>0){
        // If there are any items in the response, add them to the singleton
        // Iterate through the response object and add to the singleton
        for(GTLZeppaclientapiZeppaEvent *item  in response.items){
            // Initialize the wrapper and cooresponding values
            ZPAMyZeppaEvent *event = [[ZPAMyZeppaEvent alloc] initWithZeppaEvent:item];
            [[ZPAZeppaEventSingleton sharedObject] addZeppaEvent:event];
            
        }
        
        if(response.items.count < [self getLimit] || response.nextPageToken==nil){
            // The number of items returned did not match the query limit, there are no more events that
            // will be returned by this query
            // OR
            // the next page token (cursor) is nil indicating the last page has of items was
            return YES;
        } else {
            // This query has a cursor and will return more items
            return NO;
        }
    }
    // If nil response, assume this query will not
    return YES;
}
/**
 
 * Add all items in an event relationship list query to the ZPAZeppaEventSingleton
 *
 * returns YES if this query will return no new events (if provided a )
 */
- (BOOL) addEventsForEventRelationshipResponse: (GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *)response {
    if(response && response.items && response.items.count>0){
        // If there are any items in the response, add them to the singleton
        // Iterate through the response object and add to the singleton
        
        for(GTLZeppaclientapiZeppaEventToUserRelationship *relationship  in response.items){
            // Initialize the wrapper and cooresponding values
            ZPADefaultZeppaEventInfo *event = [[ZPADefaultZeppaEventInfo alloc] initWithZeppaEvent:relationship.event withRelationship:relationship];
            [[ZPAZeppaEventSingleton sharedObject] addZeppaEvent:event];
        }
        // Check to see if this response indicates it is last query
        if(response.items.count < [self getLimit] || response.nextPageToken==nil){
            // The number of items returned did not match the query limit, there are no more events that
            // will be returned by this query
            // OR
            // the next page token (cursor) is nil indicating the last page has of items was
            return YES;
        } else {
            // This query has a cursor and will return more items
            return NO;
        }
    }
    // If nil response, assume this query will not
    return YES;
}

/**
 * When the Event Query Completes
 *
 *  @param ticket   - query ticket
 *  @param response - response from the last query, nil if there was an error
 *  @param error    - error the query threw, nil if executed smoothly
 */
- (void) onCompletion:(GTLServiceTicket*)ticket withResponse: (GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *) response withError: (NSError*) error {
    _ticket = ticket;
    _response = response;
    _error = error;
    // First, verify there is a completion to call
    if(_onEventQueryCompletion) {
        _onEventQueryCompletion(_ticket,_response,_error);
    }
}

@end
