//
//  ZPADefaultZeppaEventTagInfo.m
//  Zeppa
//
//  Created by Dheeraj on 28/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADefaultZeppaEventTagInfo.h"


@implementation ZPADefaultZeppaEventTagInfo

-(BOOL)isFollowing{
    
   
    return (_eventTagFollow !=nil);
}



- (void) insertZeppaTagFollow:(GTLZeppaclientapiEventTagFollow *)tagFollow{
    
    
    GTLZeppaclientapiEventTagFollow *follow = [[GTLZeppaclientapiEventTagFollow alloc] init];
    
    [follow setTagId:tagFollow.tagId];
    [follow setTagOwnerId:tagFollow.tagOwnerId];
    [follow setFollowerId:tagFollow.followerId];
    
    GTLQueryZeppaclientapi *insertFollowTask = [GTLQueryZeppaclientapi queryForInsertEventTagFollowWithObject:follow idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.evetTagFollowService executeQuery:insertFollowTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiEventTagFollow *response, NSError *error) {
        //
        
        if(error){
            // Handle Error
        } else if (response.identifier) {
          //  _eventTagFollow = response;
            // successful operation
        } else {
            // returned null object
        }
        
    }];
    
}

-(void)removeZeppaTagFollow:(GTLZeppaclientapiEventTagFollow *)tagFollow{
    // Wut iz dis?
    
}

-(GTLServiceZeppaclientapi *)evetTagFollowService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}

@end
