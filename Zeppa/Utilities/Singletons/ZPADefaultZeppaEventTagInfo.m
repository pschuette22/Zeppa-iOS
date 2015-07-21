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



- (void) insertZeppaTagFollow:(GTLEventtagfollowendpointEventTagFollow *)tagFollow{
    
    
    GTLEventtagfollowendpointEventTagFollow *follow = [[GTLEventtagfollowendpointEventTagFollow alloc] init];
    
    [follow setTagId:tagFollow.tagId];
    [follow setTagOwnerId:tagFollow.tagOwnerId];
    [follow setFollowerId:tagFollow.followerId];
    
    GTLQueryEventtagfollowendpoint *insertFollowTask = [GTLQueryEventtagfollowendpoint queryForInsertEventTagFollowWithObject:follow];
    
    [self.evetTagFollowService executeQuery:insertFollowTask completionHandler:^(GTLServiceTicket *ticket, GTLEventtagfollowendpointEventTagFollow *response, NSError *error) {
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

-(void)removeZeppaTagFollow:(GTLEventtagfollowendpointEventTagFollow *)tagFollow{
    
    
}
-(GTLServiceEventtagfollowendpoint *)evetTagFollowService{
    
    static GTLServiceEventtagfollowendpoint *service = nil;
    if(!service){
        service = [[GTLServiceEventtagfollowendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
    
}

@end
