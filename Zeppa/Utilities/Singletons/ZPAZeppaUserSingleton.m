//
//  ZPAZeppaUserSingleton.m
//  Zeppa
//
//  Created by Dheeraj on 15/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaulZeppatUserInfo.h"



static ZPAZeppaUserSingleton *zeppaUserSingleton = nil;

@implementation ZPAZeppaUserSingleton

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

-(NSNumber *)userId{
    static  NSNumber *userIdentifier;
    if (userIdentifier == nil) {
        userIdentifier = [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
    }
    return userIdentifier;
    
}
-(NSNumber *)getUserId{
    
    return [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
}
-(NSArray *)getZeppaMinglerUsers{
    
    NSMutableArray *friendList = [NSMutableArray array];
    
    for (ZPADefaulZeppatUserInfo *userInfo in _heldUserMediators) {
        
        if (userInfo.isMingling) {
            
            [friendList addObject:userInfo];
            
        }
        
    }
    [ZPAStaticHelper sortArrayAlphabatically:friendList withKey:@"zeppaUserInfo.givenName"];
    //Collections.sort(friendList, Utils.USER_COMPARATOR);
    return friendList;
    
}

-(NSArray *)getZeppaRecognizedEmails{
    
    NSMutableArray *emailList = [NSMutableArray array];
    
    for (ZPADefaulZeppatUserInfo *userInfo in _heldUserMediators) {
        
        if (userInfo.zeppaUserInfo.googleAccountEmail.length>0) {
            [emailList addObject:userInfo.zeppaUserInfo.googleAccountEmail];
        }
    }
    return emailList;
    
}

-(NSArray *)getZeppaRecognizedNumbers{
    
    NSMutableArray *numberList = [NSMutableArray array];
    
    for (ZPADefaulZeppatUserInfo *userInfo in _heldUserMediators) {
        
        if (userInfo.zeppaUserInfo.primaryUnformattedNumber.length>0) {
            [numberList addObject:userInfo.zeppaUserInfo.primaryUnformattedNumber];
        }
    }
    return numberList;
}


-(NSArray *)getPossibleFriendInfoMediators{
    
    NSMutableArray *friendsList = [NSMutableArray array];
    for (ZPADefaulZeppatUserInfo *user in _heldUserMediators) {
        
        if (![user isMingling] && (![user requestPending] || ([user requestPending] && [user didSendRequest]))) {
            
            [friendsList addObject:user];
            
            
        }
    }
    
    [ZPAStaticHelper sortArrayAlphabatically:friendsList withKey:@"zeppaUserInfo.givenName"];
    // Collections.sort(potentialConnectionList, Utils.USER_COMPARATOR);
    return friendsList;
}
-(NSArray *)getPendingFriendRequests{
    
    
    NSMutableArray *friendsList = [NSMutableArray array];
    for (ZPADefaulZeppatUserInfo *user in _heldUserMediators) {
        
        if ([user requestPending] && ![user didSendRequest]) {
            
            [friendsList addObject:user];
            
        }
    }
    [ZPAStaticHelper sortArrayAlphabatically:friendsList withKey:@"zeppaUserInfo.givenName"];
    
    // Collections.sort(potentialConnectionList, Utils.USER_COMPARATOR);
    return friendsList;
    
}

-(void)addDefaultZeppaUserMediatorWithUserInfo:(GTLZeppauserinfoendpointZeppaUserInfo *)userInfo andRelationShip:(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *)relation{
    
    NSLog(@"Relationship id:%@",relation.identifier);
    NSLog(@"UserId  id:%@",userInfo.key.parent.identifier);
    id mingler = [self getZPAUserMediatorById:[userInfo.key.parent.identifier longLongValue]];
   
    if (mingler &&  [mingler isMemberOfClass:[ZPADefaulZeppatUserInfo class]]) {
        ZPADefaulZeppatUserInfo *defaultZeppaUserInfo = (ZPADefaulZeppatUserInfo *)mingler;
        defaultZeppaUserInfo.relationship = relation;
        return;
    }
    if (!mingler) {
        
        ZPADefaulZeppatUserInfo *defaultUserInfo = [[ZPADefaulZeppatUserInfo alloc]init];
        defaultUserInfo.zeppaUserInfo = userInfo;
        defaultUserInfo.relationship = relation;
        [_heldUserMediators addObject:defaultUserInfo];
    }
}
-(void)removeHeldMediatorById:(long long)userId{
    
    ZPADefaulZeppatUserInfo *removeUser = nil;
    if(!_heldUserMediators && _heldUserMediators.count>0){
        return;
    }else{
        
        for (ZPADefaulZeppatUserInfo *defaultZeppaUser in _heldUserMediators) {
            
            if ([defaultZeppaUser.zeppaUserInfo.key.identifier longLongValue] == userId) {
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
    
    for (ZPADefaulZeppatUserInfo *userInfo in _heldUserMediators) {
        if ([userInfo.userId longLongValue] == userId) {
            
            ///it return ZPADefaulZeppatUserInfo object.
            return userInfo;
        }
    }
    return nil;
}


-(NSArray *)getMinglersFrom:(NSArray *)userIdArray{
    NSMutableArray * user = [NSMutableArray array];
    
    for (int i= 0 ; i<userIdArray.count; i++) {
        ZPADefaulZeppatUserInfo * userInfo = [self getZPAUserMediatorById:[[userIdArray objectAtIndex:i] longLongValue]];
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
    
   __weak typeof(self)  weakSelf = self;
    GTLQueryZeppauserendpoint *query = [GTLQueryZeppauserendpoint queryForGetZeppaUserWithUserId:zeppaUserId];
    
    GTLServiceTicket *ticket =[self.zeppaUserService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserendpointZeppaUser *zeppaUser, NSError *error) {
        
        if (!error && zeppaUser){
            if (completion != NULL) {
                
                GTLZeppauserendpointZeppaUser *response = zeppaUser;
                GTLZeppauserendpointZeppaUserInfo *responseInfo= [zeppaUser userInfo];
                
                ZPAMyZeppaUser *user = [[ZPAMyZeppaUser alloc]init];
                user.endPointUser = response;
                user.endPointUser.userInfo = responseInfo;
                weakSelf.zeppaUser = user;
                completion(ticket, user, error);
            }
        }if (error) {
            completion(ticket, nil, error);
        }
    }];
    return ticket;
    
}


-(GTLServiceTicket *)getCurrentZeppaUserWithCompletionHandler:(ZPAUserEndpointServiceCompletionBlock)completion
{
   __weak typeof(self)  weakSelf = self;
    GTLQueryZeppauserendpoint *query = [GTLQueryZeppauserendpoint queryForFetchCurrentZeppaUser];
    
    GTLServiceTicket *ticket =[self.zeppaUserService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLZeppauserendpointZeppaUser *zeppaUser, NSError *error) {
        
        if (!error && zeppaUser){
            if (completion != NULL) {
                
                GTLZeppauserendpointZeppaUser *response = zeppaUser;
                GTLZeppauserendpointZeppaUserInfo *responseInfo= [zeppaUser userInfo];
                
                ZPAMyZeppaUser *user = [[ZPAMyZeppaUser alloc]init];
                user.endPointUser = response;
                user.endPointUser.userInfo = responseInfo;
                weakSelf.zeppaUser = user;
                completion(ticket, user, error);
            }
        }else if(error) {
           // [_delegate showLoginError];
            completion(ticket, nil, error);
        }
    }];
    return ticket;
    
}
-(GTLServiceZeppauserendpoint *)zeppaUserService
{
    ///Create ZeppaUserEndPoint Service
    static GTLServiceZeppauserendpoint *zeppaUserService = nil;
    if (!zeppaUserService) {
        self.auth = [ZPAAuthenticatonHandler sharedAuth].auth;
        zeppaUserService = [[GTLServiceZeppauserendpoint alloc]init];
        zeppaUserService.retryEnabled = YES;
    }
    [zeppaUserService setAuthorizer:self.auth];
    self.auth.authorizationTokenKey = @"id_token";
    return zeppaUserService;
}



@end
