//
//  ZPADefaulZeppatEventInfo.m
//  Zeppa
//
//  Created by Dheeraj on 22/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADefaulZeppatEventInfo.h"
#import "ZPAZeppaEventSingleton.h"


static ZPADefaulZeppatEventInfo *defaultEventInfo = nil;

@implementation ZPADefaulZeppatEventInfo

+(ZPADefaulZeppatEventInfo *)sharedObject{
    
    if (defaultEventInfo == nil) {
        defaultEventInfo = [[ZPADefaulZeppatEventInfo alloc]init];
      
    }
    return defaultEventInfo;
}


-(BOOL)isAgendaEvent{
    return ([self isWatching ] || [self isAttending]);
}

-(BOOL)isWatching{
    
    if(_relationship == nil){
        return NO;
    }
    return [_relationship.isWatching boolValue];
}

-(BOOL)isAttending{
    
    if (_relationship == nil) {
        return NO;
    }
    return [_relationship.isAttending boolValue];
    
}
-(BOOL)relationshipDoesMatch:(GTLZeppaclientapiZeppaEventToUserRelationship*)relationShip{
    
    return ([relationShip.identifier longLongValue] == [_relationship.identifier longLongValue]);
}



-(void)onWatchButtonClicked:(GTLZeppaclientapiZeppaEventToUserRelationship *)relationship{
    
    _relationship = relationship;
    
    if ([self isWatching]) {

        [_relationship setIsWatching:false];
        
    }else{
        
        
        [_relationship setIsWatching:[NSNumber numberWithInt:true]];

    }
    
    
    [self updateEventRelationshipWithRelationship:_relationship];
    
    

}

-(void)onTextButtonClicked:(UIButton *)textButton{
    
}

-(void)onJoinButtonClicked:(GTLZeppaclientapiZeppaEventToUserRelationship *)relationship{
    
    _relationship = relationship;
    
    if ([self isAttending]) {
        
        [_relationship setIsAttending:false];
        [_relationship setIsWatching:false];
    }else{
        
        [_relationship setIsAttending:[NSNumber numberWithInt:true]];
        [_relationship setIsWatching:[NSNumber numberWithInt:true]];
        
        [self updateEventRelationshipWithRelationship:_relationship];
        
    }
}



-(void) updateEventRelationshipWithRelationship:( GTLZeppaclientapiZeppaEventToUserRelationship *)relationship {
    
    
    GTLZeppaclientapiZeppaEventToUserRelationship *eventRelationship = [[GTLZeppaclientapiZeppaEventToUserRelationship alloc] init];
    
    
        eventRelationship = relationship;
//    // If user is being invited that already has a relationship to the event
//    [eventRelationship setInvitedByUserId:<current-zeppauser-identifier>];
//    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
//    
//    // If the user is watching/upwatching or attending/leaving the event
//    [eventRelationship setIsAttending:[NSNumber numberWithInt:1]]; // 1 for true, 0 for false
//    [eventRelationship setIsWatching:[NSNumber numberWithInt:1]]; // 1 for true, 0 for false;
    
    GTLQueryZeppaclientapi *updateEventRelationshipTask = [GTLQueryZeppaclientapi queryForUpdateZeppaEventToUserRelationshipWithObject:eventRelationship idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaEventToUserRelationshipService executeQuery:updateEventRelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEventToUserRelationship *response, NSError *error) {
        //
        if(error){
            // error
        } else if (response.identifier) {
            // success
            
        } else {
            // returned null object
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


@end
