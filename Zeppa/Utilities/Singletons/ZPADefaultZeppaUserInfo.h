//
//  ZPDefaulZeppatUserInfo.h
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAUserInfoBase.h"

#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLZeppaclientapiZeppaUserToUserRelationship.h"

@interface ZPADefaultZeppaUserInfo : ZPAUserInfoBase

@property (nonatomic, strong) GTLZeppaclientapiZeppaUserToUserRelationship *relationship;
@property (nonatomic, strong) NSMutableArray *mututalFriendIds;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSNumber *userId;

-(id) initWithUserInfo:(GTLZeppaclientapiZeppaUserInfo *)userInfo withRelationship: (GTLZeppaclientapiZeppaUserToUserRelationship*) relationship;

-(void)setUserRelationship:(GTLZeppaclientapiZeppaUserToUserRelationship *)relationship;
-(GTLZeppaclientapiZeppaUserToUserRelationship*) getRelationship;

// TODO: add update methods

-(BOOL) isPendingRequest;
-(BOOL) didSendRequest;
-(BOOL) isFriend;

@end
