//
//  ZPAFetchUserInfoTask.m
//  Zeppa
//
//  Created by Peter Schuette on 8/10/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import "ZPAFetchUserInfoTask.h"

@implementation ZPAFetchUserInfoTask


// Initialize the fetch task with the calling user id and the other user's id
-(id) initWithCurrentUserId: (NSNumber *) currentUserId withOtherUserId: (NSNumber *) otherUserId {
    
    // Call super method
    self = [super init];
    
    // Set the appropriate values
    self.currentUserId = currentUserId;
    self.otherUserId = otherUserId;
    
    // return instance of object
    return self;
}

/*
 * Execute the task with a defined completion block
 */
-(void) executeWithCompletionBlock:(FetchUserInfoCompletionBlock)completionBlock
{
    // Set the completion block
    [self setCompletionBlock:completionBlock];
    
    [self fetchDefaultZeppaUserInfo];
    
}


/*
 * Based on the given params, try to fetch the given Zeppa User Info
 * If fetch is successful, fetch the current user's relationship to other user
 */
-(GTLServiceTicket *) fetchDefaultZeppaUserInfo
{
    __weak typeof(self)  weakSelf = self;
    
    GTLQueryZeppauserinfoendpoint *query = [GTLQueryZeppauserinfoendpoint queryForFetchZeppaUserInfoByParentIdWithRequestedParentId:self.otherUserId.longLongValue];
    
    GTLServiceTicket *ticket = [self.userInfoService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserinfoendpointZeppaUserInfo *userInfo, NSError *error) {
        
        if (error || !userInfo){
            weakSelf.completionBlock(ticket, nil, error);
        } else if (userInfo.identifier) {
            
            // Set the user info
            [weakSelf setZeppaUserInfo:userInfo];
            
            // try to fetch relationship to this object
            [weakSelf fetchUserRelationship];
            
        } else {
            // nil object returned. perhaps user object was deleted and notification hadnt been cleaned up yet
        }
        
    }];
    
    
    return ticket;
}


/*
 * Fetch relationship to user info object with otherUserInfoId as Identifier
 */
- (GTLServiceTicket *) fetchUserRelationship
{
    // only execute query if userinfo is held
    if(_zeppaUserInfo){
        __weak typeof(self) weakSelf = self;
        
            GTLQueryZeppausertouserrelationshipendpoint *query = [GTLQueryZeppausertouserrelationshipendpoint queryForListZeppaUserToUserRelationship];
        
            [query setFilter: [NSString stringWithFormat:@"(creatorId == %lld || creatorId == %lld) && (subjectId == %lld || subjectId == %lld)",_currentUserId.longLongValue, _otherUserId.longLongValue, _currentUserId.longLongValue, _otherUserId.longLongValue]];
            [query setLimit:1]; // should only be one user to user relationship
        
            GTLServiceTicket *ticket = [self.zeppaUserRelationshipService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship* response, NSError *error) {
        
                if(error){
                    weakSelf.completionBlock(ticket, nil, error);
                } else {
                    // There was no error. since there can be a nil relationship, added the mediator
                    
                    GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *relationship = nil;
                    
                    if(response && response.items && response.items.count > 0){
                        relationship = [response.items objectAtIndex:0];
                    }
                    
                    [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:weakSelf.zeppaUserInfo andRelationShip:relationship];
                    
                    // Dispatch completion block
                    weakSelf.completionBlock(ticket, weakSelf.zeppaUserInfo, error);
                    
                }
                
            }];
        
        return ticket;
    }
    return nil;
}

/*
 * Retrieve a service object for making authenticated queries for userInfoObjects
 */
-(GTLServiceZeppauserinfoendpoint *)userInfoService
{
    ///Create ZeppaUserEndPoint Service
    static GTLServiceZeppauserinfoendpoint *userInfoService = nil;
    if (!userInfoService) {
        self.auth = [ZPAAuthenticatonHandler sharedAuth].auth;
        userInfoService = [[GTLServiceZeppauserinfoendpoint alloc]init];
        userInfoService.retryEnabled = YES;
    }
    [userInfoService setAuthorizer:self.auth];
    self.auth.authorizationTokenKey = @"id_token";
    return userInfoService;
}

-(GTLServiceZeppausertouserrelationshipendpoint *) zeppaUserRelationshipService
{
    // Create endpoint service for the ZeppaUserToUserRelationship object
    static GTLServiceZeppausertouserrelationshipendpoint *zeppaUserRelationshipService = nil;
    if(!zeppaUserRelationshipService){
        self.auth = [ZPAAuthenticatonHandler sharedAuth].auth;
        zeppaUserRelationshipService = [[GTLServiceZeppausertouserrelationshipendpoint alloc] init];
        zeppaUserRelationshipService.retryEnabled = YES;
    }
    [zeppaUserRelationshipService setAuthorizer:self.auth];
    self.auth.authorizationTokenKey = @"id_token";
    return zeppaUserRelationshipService;
}


@end
