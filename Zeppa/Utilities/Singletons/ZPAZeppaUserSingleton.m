//
//  ZPAZeppaUserSingleton.m
//  Zeppa
//
//  Created by Dheeraj on 15/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaultZeppaUserInfo.h"


static ZPAZeppaUserSingleton *zeppaUserSingleton = nil;

@implementation ZPAZeppaUserSingleton {
    ZPAMyZeppaUser *_zeppaUser;
}

+(ZPAZeppaUserSingleton *)sharedObject{
    if (zeppaUserSingleton == nil) {
        zeppaUserSingleton = [[ZPAZeppaUserSingleton alloc]init];
        zeppaUserSingleton.heldUserMediators = [NSMutableArray array];
    }
    return zeppaUserSingleton;
}
+(void)resetObject{
    
  zeppaUserSingleton = nil;
    
}

-(void)clear{
    _heldUserMediators = nil;
}


-(NSArray *)getZeppaMinglerUsers{
    
    NSMutableArray *friendList = [NSMutableArray array];
    
    for (ZPADefaultZeppaUserInfo *userInfo in _heldUserMediators) {
        
        if (userInfo.isFriend) {
            
            [friendList addObject:userInfo];
            
        }
        
    }
    [ZPAStaticHelper sortArrayAlphabatically:friendList withKey:@"zeppaUserInfo.givenName"];
    //Collections.sort(friendList, Utils.USER_COMPARATOR);
    return friendList;
    
}





-(NSArray *)getPossibleFriendInfoMediators{
    
    NSMutableArray *friendsList = [NSMutableArray array];
    for (ZPADefaultZeppaUserInfo *user in _heldUserMediators) {
        
        if (![user isFriend] && (![user isPendingRequest] || ([user isPendingRequest] && [user didSendRequest]))) {
            
            [friendsList addObject:user];
            
        }
    }
    
    [ZPAStaticHelper sortArrayAlphabatically:friendsList withKey:@"zeppaUserInfo.givenName"];
    // Collections.sort(potentialConnectionList, Utils.USER_COMPARATOR);
    return friendsList;
}
-(NSArray *)getPendingFriendRequests{
    
    
    NSMutableArray *friendsList = [NSMutableArray array];
    for (ZPADefaultZeppaUserInfo *user in _heldUserMediators) {
        
        if ([user isPendingRequest] && ![user didSendRequest]) {
            
            [friendsList addObject:user];
            
        }
    }
    [ZPAStaticHelper sortArrayAlphabatically:friendsList withKey:@"zeppaUserInfo.givenName"];
    
    // Collections.sort(potentialConnectionList, Utils.USER_COMPARATOR);
    return friendsList;
    
}

-(GTLServiceTicket *) updateUserLocation: (CLLocation *)location withCompletion:(ZPAUserEndpointServiceCompletionBlock)completion {
    
    if(_zeppaUser==nil){
        return nil;
    }
    
    // Peep this real quick
    _zeppaUser.endPointUser.latitude = [NSDecimalNumber numberWithDouble:location.coordinate.latitude];
    _zeppaUser.endPointUser.longitude = [NSDecimalNumber numberWithDouble:location.coordinate.longitude];
    
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForUpdateZeppaUserWithObject:_zeppaUser.endPointUser idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    GTLServiceTicket *ticket =[[self zeppaUserService] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUser *zeppaUser, NSError *error) {
        
        if (zeppaUser && zeppaUser.key){
            
                GTLZeppaclientapiZeppaUser *response = zeppaUser;
                GTLZeppaclientapiZeppaUserInfo *responseInfo= [zeppaUser userInfo];

                _zeppaUser.endPointUser = response;
                _zeppaUser.endPointUser.userInfo = responseInfo;
            
                completion(ticket, _zeppaUser, error);
        }
        
        // If there is a defined completion block, call it
        if(completion) {
            completion(ticket, nil, error);
        }
    }];
    return ticket;
    
}

-(void)addDefaultZeppaUserMediatorWithUserInfo:(GTLZeppaclientapiZeppaUserInfo *)userInfo andRelationShip:(GTLZeppaclientapiZeppaUserToUserRelationship *)relation{
    
    NSLog(@"Relationship id:%@",relation.identifier);
    NSLog(@"UserId  id:%@",userInfo.key.parent.identifier);
    id mingler = [self getZPAUserMediatorById:[userInfo.key.parent.identifier longLongValue]];
   
    if (mingler &&  [mingler isMemberOfClass:[ZPADefaultZeppaUserInfo class]]) {
        ZPADefaultZeppaUserInfo *defaultZeppaUserInfo = (ZPADefaultZeppaUserInfo *)mingler;
        defaultZeppaUserInfo.relationship = relation;
        return;
    }
    if (!mingler) {
        
        ZPADefaultZeppaUserInfo *defaultUserInfo = [[ZPADefaultZeppaUserInfo alloc]init];
        defaultUserInfo.userInfo = userInfo;
        defaultUserInfo.relationship = relation;
        [_heldUserMediators addObject:defaultUserInfo];
    }
}
-(void)removeHeldMediatorById:(long long)userId{
    
    ZPADefaultZeppaUserInfo *removeUser = nil;
    if(!_heldUserMediators && _heldUserMediators.count>0){
        return;
    }else{
        
        for (ZPADefaultZeppaUserInfo *defaultZeppaUser in _heldUserMediators) {
            
            if ([defaultZeppaUser.userId longLongValue] == userId) {
                removeUser = defaultZeppaUser;
                break;
            }
        }
        if (removeUser) {
            
            [_heldUserMediators removeObject:removeUser];
        }
        
    }
    
}
-(id)getZPAUserMediatorById:(long long)userId{
    
    if ([_zeppaUser.endPointUser.identifier longLongValue] == userId ) {
        
        ///it return ZPAUser object.
            return _zeppaUser;
    }
    
    for (ZPADefaultZeppaUserInfo *userInfo in _heldUserMediators) {
        if ([userInfo.userId longLongValue] == userId) {
            
            ///it return ZPADefaultZeppaUserInfo object.
            return userInfo;
        }
    }
    return nil;
}

-(ZPAMyZeppaUser*) setMyZeppaUser:(ZPAMyZeppaUser*)zeppaUser {
    if(zeppaUser){
        _zeppaUser = zeppaUser;
    }
    
    return zeppaUser;
}


// Get the singletons held Zeppa User. may be nil
-(ZPAMyZeppaUser*) getMyZeppaUser {
    return _zeppaUser;
}

- (NSNumber*) getMyZeppaUserIdentifier {
    if(!_zeppaUser){
        return [NSNumber numberWithLong:-1];
    }
    return _zeppaUser.endPointUser.identifier;
}

-(NSArray *)getMinglersFrom:(NSArray *)userIdArray{
    NSMutableArray * user = [NSMutableArray array];
    
    for (int i= 0 ; i<userIdArray.count; i++) {
        ZPADefaultZeppaUserInfo * userInfo = [self getZPAUserMediatorById:[[userIdArray objectAtIndex:i] longLongValue]];
        if (userInfo) {
             [user addObject:userInfo];
        }
       
    }
    
    return user;
}


///*******************************
#pragma mark - ZeppaApi Methods
///*******************************
-(GTLServiceTicket *)getZeppaUserWithUserId:(long long)zeppaUserId andCompletionHandler:(ZPAUserEndpointServiceCompletionBlock)completion
{
    NSLog(@"Method not implemented!!! Fetch current user");
    return nil;
//   __weak typeof(self)  weakSelf = self;
//    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForGetZeppaUserWithUserId:zeppaUserId idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
//    
//    GTLServiceTicket *ticket =[self.zeppaUserService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUser *zeppaUser, NSError *error) {
//        
//        if (!error && zeppaUser){
//            if (completion != NULL) {
//                
//                GTLZeppaclientapiZeppaUser *response = zeppaUser;
//                GTLZeppaclientapiZeppaUserInfo *responseInfo= [zeppaUser userInfo];
//                
//                ZPAMyZeppaUser *user = [[ZPAMyZeppaUser alloc]init];
//                user.endPointUser = response;
//                user.endPointUser.userInfo = responseInfo;
//                weakSelf.zeppaUser = user;
//                completion(ticket, user, error);
//            }
//        }if (error) {
//            completion(ticket, nil, error);
//        }
//    }];
//    return ticket;
    
}


-(GTLServiceTicket *)getCurrentZeppaUserWithCompletionHandler:(ZPAUserEndpointServiceCompletionBlock)completion
{
    
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForFetchCurrentZeppaUserWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    // Peep this real quick
    
    GTLServiceTicket *ticket =[[self zeppaUserService] executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUser *zeppaUser, NSError *error) {
        
        if (zeppaUser && zeppaUser.key){
            if (completion != NULL) {
                
                GTLZeppaclientapiZeppaUser *response = zeppaUser;
                GTLZeppaclientapiZeppaUserInfo *responseInfo= [zeppaUser userInfo];
                
                ZPAMyZeppaUser *user = [[ZPAMyZeppaUser alloc]init];
                user.endPointUser = response;
                user.endPointUser.userInfo = responseInfo;
                _zeppaUser = user;
                completion(ticket, user, error);
            } else {
                // Error
            }
        } else {
            completion(ticket, nil, error);
        }
    }];
    return ticket;
    
}
-(GTLServiceZeppaclientapi *)zeppaUserService
{
    ///Create ZeppaUserEndPoint Service
    static GTLServiceZeppaclientapi *zeppaUserService = nil;
    if (!zeppaUserService) {
        
        zeppaUserService = [[GTLServiceZeppaclientapi alloc]init];
        zeppaUserService.retryEnabled = YES;
        
    }
 
    return zeppaUserService;
}



@end
