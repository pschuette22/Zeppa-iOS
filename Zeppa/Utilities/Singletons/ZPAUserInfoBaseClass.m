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
-(void)setZepppUserToUserRelationship:(GTLZeppaclientapiZeppaUserToUserRelationship *)relation WithIdentifier:(long long)identifier{
    
    
    GTLQueryZeppaclientapi *userInfoQuery = [GTLQueryZeppaclientapi queryForGetZeppaUserInfoWithIdentifier:identifier idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaUserInfoService executeQuery:userInfoQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUserInfo *userInfo, NSError *error) {
        
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
    
    GTLQueryZeppaclientapi *userInfoQuery = [GTLQueryZeppaclientapi queryForGetZeppaUserInfoWithIdentifier:[identifier longLongValue] idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaUserInfoService executeQuery:userInfoQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUserInfo *userInfo, NSError *error) {
        
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
    
    GTLQueryZeppaclientapi *userInfoQuery = [GTLQueryZeppaclientapi queryForFetchZeppaUserInfoByParentIdWithRequestedParentId:[identifier longLongValue] idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaUserInfoService executeQuery:userInfoQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUserInfo *userInfo, NSError *error) {
        
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
    
    
    GTLQueryZeppaclientapi *listZeppaUserInfoTask = [GTLQueryZeppaclientapi queryForListZeppaUserInfoWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    [listZeppaUserInfoTask setFilter:filter];
    
    [[self zeppaUserInfoService] executeQuery:listZeppaUserInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaUserInfo *response, NSError *error) {
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0) {
            
            completion([NSArray arrayWithArray:response.items]);
        } else {
            // didnt return any items
        }
    }];
}

-(GTLServiceZeppaclientapi *)zeppaUserInfoService{
    
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}
@end
