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

#import "GTLZeppaclientapiZeppaUser.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLZeppaclientapiKey.h"
#import "GTLZeppaclientapiZeppaUserToUserRelationship.h"

#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"


@protocol loginErrorDelegate <NSObject>

-(void)showLoginError;

@end

@interface ZPAZeppaUserSingleton : NSObject


@property (strong,readonly) GTLServiceZeppaclientapi *zeppaUserService;

@property (nonatomic, strong) NSMutableArray *heldUserMediators;

///Create ZPAUserEndpoint  Completion Block
typedef void(^ZPAUserEndpointServiceCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);

///Initialization Methods
+(ZPAZeppaUserSingleton *)sharedObject;
+(void)resetObject;

-(void)clear;
-(NSArray *)getZeppaMinglerUsers;
-(void)addDefaultZeppaUserMediatorWithUserInfo:(GTLZeppaclientapiZeppaUserInfo *)userInfo andRelationShip:(GTLZeppaclientapiZeppaUserToUserRelationship *)relationShip;
-(void)removeHeldMediatorById:(long long)userId;
-(id)getZPAUserMediatorById:(long long)userId;
-(ZPAMyZeppaUser*) setMyZeppaUser:(ZPAMyZeppaUser*)zeppaUser;
-(ZPAMyZeppaUser*) getMyZeppaUser;
- (NSNumber*) getMyZeppaUserIdentifier;

-(NSArray *)getPossibleFriendInfoMediators;
-(NSArray *)getPendingFriendRequests;
-(NSArray *)getMinglersFrom:(NSArray *)userIdArray;

///*******************************
#pragma mark - ZeppaApi Methods
///*******************************
-(GTLServiceTicket *)getZeppaUserWithUserId:(long long)zeppaUserId andCompletionHandler:(ZPAUserEndpointServiceCompletionBlock)completion;
-(GTLServiceTicket *)getCurrentZeppaUserWithCompletionHandler:(ZPAUserEndpointServiceCompletionBlock)completion;

-(GTLServiceTicket *) updateUserLocation: (CLLocation *)location withCompletion:(ZPAUserEndpointServiceCompletionBlock)completionBlock;

@end


