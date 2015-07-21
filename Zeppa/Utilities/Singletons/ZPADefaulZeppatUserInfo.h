//
//  ZPDefaulZeppatUserInfo.h
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAMyZeppaUser.h"

#import "GTLZeppauserinfoendpointZeppaUserInfo.h"
#import "GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.h"

@interface ZPADefaulZeppatUserInfo : NSObject
@property (nonatomic, strong) ZPAMyZeppaUser *user;
@property (nonatomic, strong) GTLZeppauserinfoendpointZeppaUserInfo *zeppaUserInfo;
@property (nonatomic, strong) GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *relationShip;
@property (nonatomic, strong) NSMutableArray *minglersIds;
@property (readonly, getter=isMingling)BOOL mingling;
@property (readonly, assign)BOOL requestPending;
@property (readonly, assign)BOOL didSendRequest;

@property (nonatomic, readonly)NSNumber *userId;

+(ZPADefaulZeppatUserInfo *)sharedObject;
+(void)resetObject;

-(BOOL)requestPending;

-(void)setUserRelationship:(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *)relationship;
@end
