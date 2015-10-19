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
    
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForFetchZeppaUserInfoByParentIdWithRequestedParentId:self.otherUserId.longLongValue idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    GTLServiceTicket *ticket = [self.zeppaClientApiService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUserInfo *userInfo, NSError *error) {
        
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
        
            GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForListZeppaUserToUserRelationshipWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
        
            [query setFilter: [NSString stringWithFormat:@"(creatorId == %lld || creatorId == %lld) && (subjectId == %lld || subjectId == %lld)",_currentUserId.longLongValue, _otherUserId.longLongValue, _currentUserId.longLongValue, _otherUserId.longLongValue]];
            [query setLimit:1]; // should only be one user to user relationship
        
            GTLServiceTicket *ticket = [self.zeppaClientApiService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaUserToUserRelationship* response, NSError *error) {
        
                if(error){
                    weakSelf.completionBlock(ticket, nil, error);
                } else {
                    // There was no error. since there can be a nil relationship, added the mediator
                    
                    GTLZeppaclientapiZeppaUserToUserRelationship *relationship = nil;
                    
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
-(GTLServiceZeppaclientapi *)zeppaClientApiService
{
    ///Create ZeppaUserEndPoint Service
    static GTLServiceZeppaclientapi *userInfoService = nil;
    if (!userInfoService) {
        userInfoService = [[GTLServiceZeppaclientapi alloc]init];
        userInfoService.retryEnabled = YES;
    }
    return userInfoService;
}



@end
