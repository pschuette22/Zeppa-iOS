//
//  ZPAUserInfoBaseClass.m
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAUserInfoBaseClass.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAZeppaUserSingleton.h"

@implementation ZPAUserInfoBaseClass
-(id)init{
    
    self = [super init];
    if(self){
        
        
    }
    return self;
}
-(void)setZepppUserToUserRelationship:(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *)relation WithIdentifier:(long long)identifier{
    
    
    GTLQueryZeppauserinfoendpoint *userInfoQuery = [GTLQueryZeppauserinfoendpoint queryForGetZeppaUserInfoWithIdentifier:identifier];
    
    [self.zeppaUserInfoService executeQuery:userInfoQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserinfoendpointZeppaUserInfo *userInfo, NSError *error) {
        
        if(error) {
            // error
            
        } else if (userInfo.identifier){
            
            [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:userInfo andRelationShip:relation];
            
        } else {
            // nil object returned
        }
    }];
    
    
    
    
}
-(void)fetchZeppaUserInfoWithIdentifier:(NSNumber *)identifier  withCompletion:(getZeppaUserInfoOject)completion {
    
    GTLQueryZeppauserinfoendpoint *userInfoQuery = [GTLQueryZeppauserinfoendpoint queryForGetZeppaUserInfoWithIdentifier:[identifier longLongValue]];
    
    [self.zeppaUserInfoService executeQuery:userInfoQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserinfoendpointZeppaUserInfo *userInfo, NSError *error) {
        
        if(error) {
            // error
        
        } else if (userInfo.identifier){
            completion(userInfo);
        } else {
            // nil object returned
        }
    }];
    
}

-(void)fetchZeppaUserInfoWithParentIdentifier:(NSNumber *)identifier withCompletion:(getZeppaUserInfoOject)completion {
    
    GTLQueryZeppauserinfoendpoint *userInfoQuery = [GTLQueryZeppauserinfoendpoint queryForFetchZeppaUserInfoByParentIdWithRequestedParentId:[identifier longLongValue]];
    
    [self.zeppaUserInfoService executeQuery:userInfoQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserinfoendpointZeppaUserInfo *userInfo, NSError *error) {
        
        if(error) {
            // error
        } else if (userInfo.identifier){
            completion(userInfo);
            // success
        } else {
            // nil object returned
        }
    }];
}
-(void)executeZeppaUserInfoListQueryWithAuthWithFilter:(NSString *)filter withCompletion:(getZeppaUserInfoOjectArray)completion{
    
    
    GTLQueryZeppauserinfoendpoint *listZeppaUserInfoTask = [GTLQueryZeppauserinfoendpoint queryForListZeppaUserInfo];
    [listZeppaUserInfoTask setFilter:filter];
    
    [[self zeppaUserInfoService] executeQuery:listZeppaUserInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserinfoendpointCollectionResponseZeppaUserInfo *response, NSError *error) {
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0) {
            
            completion([NSArray arrayWithArray:response.items]);
        } else {
            // didnt return any items
        }
    }];
}

-(GTLServiceZeppauserinfoendpoint *)zeppaUserInfoService{
    
    static GTLServiceZeppauserinfoendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppauserinfoendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
    
}
@end
