//
//  ZPADefaulZeppatEventInfo.m
//  Zeppa
//
//  Created by Dheeraj on 22/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADefaultZeppaEventInfo.h"
#import "ZPAZeppaEventSingleton.h"



@implementation ZPADefaultZeppaEventInfo {
    BOOL _isFeedEvent;
}
-(id) initWithZeppaEvent:(GTLZeppaclientapiZeppaEvent*) event withRelationship:(GTLZeppaclientapiZeppaEventToUserRelationship*) relationship {
    if(self = [super initWithZeppaEvent:event]) {
        self.relationship =  relationship;
        self.friendsAttending = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL) isFeedEvent {
    return _isFeedEvent;
}
- (BOOL) isInterestingEvent {
    return [self isFeedEvent] && ([self isAttending] || [self isWatching]);
}

- (BOOL) isAttending {
    return [_relationship.isAttending boolValue];
}

- (BOOL) isWatching {
    return [_relationship.isWatching boolValue];
}

- (BOOL) isMyEvent {
    return NO;
}

-(ZPAUserInfoBase*) getHostInfo {
    return self.hostInfo;
}


-(void)onWatchButtonClicked {
    
    // TODO: copy the relationship, update the values and try to update it
//    _relationship = relationship;
    
    if ([self isWatching]) {
        [_relationship setIsWatching:[NSNumber numberWithInt:false]];
    }else{
        [_relationship setIsWatching:[NSNumber numberWithInt:true]];
    }
    
    
    [self updateEventRelationshipWithRelationship:_relationship];

}


-(void)onJoinButtonClicked {
    
//    _relationship = relationship;
    
    if ([self isAttending]) {
        
        [_relationship setIsAttending:false];
        [_relationship setIsWatching:false];
    }else{
        
        [_relationship setIsAttending:[NSNumber numberWithInt:true]];
        [_relationship setIsWatching:[NSNumber numberWithInt:true]];
        
        [self updateEventRelationshipWithRelationship:_relationship];
        
    }
}


/**
 *  Update the event relationship. If success, relationship is updated
 *
 */
-(void) updateEventRelationshipWithRelationship:( GTLZeppaclientapiZeppaEventToUserRelationship *)relationship {
    
    GTLQueryZeppaclientapi *updateEventRelationshipTask = [GTLQueryZeppaclientapi queryForUpdateZeppaEventToUserRelationshipWithObject:relationship idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.service executeQuery:updateEventRelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEventToUserRelationship *response, NSError *error) {
        //
        if(error){
            // error
            // Handle an error in
        } else if (response.identifier) {
            self.relationship = response;
        }
    }];
}


-(GTLServiceZeppaclientapi *)service{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}


@end
