//
//  ZPADefaulZeppatEventInfo.h
//  Zeppa
//
//  Created by Dheeraj on 22/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAEventInfoBase.h"
#import "ZPADefaultZeppaUserInfo.h"

#import "ZPAAuthenticatonHandler.h"

#import "GTLQueryZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaEventToUserRelationship.h"

@interface ZPADefaultZeppaEventInfo : ZPAEventInfoBase <ZPAEventInfoMethods>

@property (nonatomic, strong) ZPADefaultZeppaEventInfo *hostInfo;
@property (nonatomic, strong) ZPADefaultZeppaEventInfo *inviterUserInfo;

// This users relationship to the event
@property (nonatomic, strong) GTLZeppaclientapiZeppaEventToUserRelationship *relationship;

@property (nonatomic, strong) NSMutableArray *friendsAttending;

-(id) initWithZeppaEvent:(GTLZeppaclientapiZeppaEvent*) event withRelationship:(GTLZeppaclientapiZeppaEventToUserRelationship*) relationship;

-(void)onWatchButtonClicked;
-(void)onJoinButtonClicked;
- (BOOL) isMyEvent;

-(ZPADefaultZeppaUserInfo*) getHostInfo;


@end
