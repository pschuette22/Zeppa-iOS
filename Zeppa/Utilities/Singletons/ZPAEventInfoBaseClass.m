//
//  ZPAEventInfoBaseClass.m
//  Zeppa
//
//  Created by Dheeraj on 28/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAEventInfoBaseClass.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAZeppaEventSingleton.h"

@implementation ZPAEventInfoBaseClass

-(void)executeInsertZeppaEventWithAuth:(GTLZeppaclientapiZeppaEvent *)zeppaEvent withCompletion:(getZeppaEventInfoOject)completion{
    
    GTLQueryZeppaclientapi *insertZeppaEventTask = [GTLQueryZeppaclientapi queryForInsertZeppaEventWithObject:zeppaEvent idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaEventService executeQuery:insertZeppaEventTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEvent * event, NSError *error) {
        //
        
        if(error){
            // error
        } else if (event.identifier){
            completion(event);
            // success
        } else {
            // returned null
        }
        
    }];
    
}

-(void)removeZeppaEventWithIdentifier:(long long) identifier{
    GTLQueryZeppaclientapi *removeZeppaEvent = [GTLQueryZeppaclientapi queryForRemoveZeppaEventWithIdentifier:identifier idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    [self.zeppaEventService executeQuery:removeZeppaEvent completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        //
        if(error){
            [ZPAStaticHelper showAlertWithTitle:@"Error" andMessage:@"Error removing event"];
        } else {
            
            [[ZPAZeppaEventSingleton sharedObject]removeEventById:identifier];
        }
        
    }];
}
/*
 
 - (void) executeZeppaEventListQueryWithAuth: (GTMOAuth2Authentication * auth) {
 
 NSString *filter = <filter-string>;
 NSString  *cursor = <cursor-string>;
 NSString *ordering = <ordering-string>;
 NSNumber *limit = <limit-integer>;
 
 GTLQueryZeppaclientapi *eventQuery = [GTLQueryZeppaclientapi queryForListZeppaEvent];
 [eventQuery setFilter: filter];
 [eventQuery setCursor: cursor];
 [eventQuery setOrdering: ordering];
 [eventQuery setLimit:[limit integerValue]];
 
 [[self zeppaEventServiceWithAuth: auth] executeQuery:eventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEvent *response, NSError *error) {
 //
 if(error){
 // error
 } else if(response && response.items && response.items.count > 0){
 
 NSArray *items = response.items;
 int count = (int) items.count;
 
 // Manage returned items
 
 // get cursor to query for next page
 cursor = response.nextPageToken;
 
 } else {
 // no items returned
 }
 
 
 }];
 
 
 }
 
 */
-(void)fetchZeppaEventWithIdentifier:(long long)identifier withCompletion:(getZeppaEventInfoOject)completion{
    
    GTLQueryZeppaclientapi *zeppaEventQuery = [GTLQueryZeppaclientapi queryForGetZeppaEventWithIdentifier:identifier idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
        [self.zeppaEventService executeQuery:zeppaEventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEvent *event, NSError *error) {
        //
        if(error) {
            // error
        } else if (event.identifier){
            completion(event);
        } else {
            // returned null
        }
        
    }];
    
}

-(GTLServiceZeppaclientapi *)zeppaEventService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
}
@end
