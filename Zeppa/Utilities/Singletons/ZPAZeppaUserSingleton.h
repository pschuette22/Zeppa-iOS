//
//  ZPAZeppaUserSingleton.h
//  Zeppa
//
//  Created by Dheeraj on 15/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAMyZeppaUser.h"
#import "ZPAAuthenticatonHandler.h"

#import "GTLZeppauserendpointZeppaUser.h"
#import "GTLZeppauserinfoendpointZeppaUserInfo.h"
#import "GTLZeppauserendpointKey.h"
#import "GTLZeppauserinfoendpointKey.h"
#import "GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.h"

#import "GTLServiceZeppauserendpoint.h"
#import "GTLQueryZeppauserendpoint.h"


@protocol loginErrorDelegate <NSObject>

-(void)showLoginError;

@end

@interface ZPAZeppaUserSingleton : NSObject


@property (strong,readonly) GTLServiceZeppauserendpoint *zeppaUserService;

@property (nonatomic, weak) GTMOAuth2Authentication *auth;
@property (nonatomic, strong) NSMutableArray *heldUserMediators;
@property (nonatomic, strong) ZPAMyZeppaUser *zeppaUser;
@property (nonatomic, strong) NSNumber *userId;

///Create ZPAUserEndpoint  Completion Block
typedef void(^ZPAUserEndpointServiceCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);

///Initialization Methods
+(ZPAZeppaUserSingleton *)sharedObject;
+(void)resetObject;

-(void)clear;
-(NSArray *)getZeppaMinglerUsers;
-(void)addDefaultZeppaUserMediatorWithUserInfo:(GTLZeppauserinfoendpointZeppaUserInfo *)userInfo andRelationShip:(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *)relationShip;
-(void)removeHeldMediatorById:(long long)userId;
-(id)getZPAUserMediatorById:(long long)userId;


-(NSArray *)getZeppaRecognizedEmails;
-(NSArray *)getZeppaRecognizedNumbers;

-(NSArray *)getPossibleFriendInfoMediators;
-(NSArray *)getPendingFriendRequests;
-(NSArray *)getMinglersFrom:(NSArray *)userIdArray;

///*******************************
#pragma mark - ZeppaApi Methods
///*******************************
-(GTLServiceTicket *)getZeppaUserWithUserId:(long long)zeppaUserId andCompletionHandler:(ZPAUserEndpointServiceCompletionBlock)completion;
-(GTLServiceTicket *)getCurrentZeppaUserWithCompletionHandler:(ZPAUserEndpointServiceCompletionBlock)completion;
  
@end


