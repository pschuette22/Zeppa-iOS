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

-(void)executeInsertZeppaEventWithAuth:(GTLZeppaeventendpointZeppaEvent *)zeppaEvent withCompletion:(getZeppaEventInfoOject)completion{
    
    GTLQueryZeppaeventendpoint *insertZeppaEventTask = [GTLQueryZeppaeventendpoint queryForInsertZeppaEventWithObject:zeppaEvent];
    
    [self.zeppaEventService executeQuery:insertZeppaEventTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaeventendpointZeppaEvent * event, NSError *error) {
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
    GTLQueryZeppaeventendpoint *removeZeppaEvent = [GTLQueryZeppaeventendpoint queryForRemoveZeppaEventWithIdentifier:identifier];
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
 
 GTLQueryZeppaeventendpoint *eventQuery = [GTLQueryZeppaeventendpoint queryForListZeppaEvent];
 [eventQuery setFilter: filter];
 [eventQuery setCursor: cursor];
 [eventQuery setOrdering: ordering];
 [eventQuery setLimit:[limit integerValue]];
 
 [[self zeppaEventServiceWithAuth: auth] executeQuery:eventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaeventendpointCollectionResponseZeppaEvent *response, NSError *error) {
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
    
    GTLQueryZeppaeventendpoint *zeppaEventQuery = [GTLQueryZeppaeventendpoint queryForGetZeppaEventWithIdentifier:identifier];
    
        [self.zeppaEventService executeQuery:zeppaEventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaeventendpointZeppaEvent *event, NSError *error) {
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

-(GTLServiceZeppaeventendpoint *)zeppaEventService{
    
    static GTLServiceZeppaeventendpoint *service = nil;
    if(!service){
        service = [[GTLServiceZeppaeventendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer: [ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}
@end
