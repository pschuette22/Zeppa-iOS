//
//  ZPAMyZeppaEvent.h
//  Zeppa
//
//  Created by Dheeraj on 21/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLZeppaclientapiKey.h"
#import "GTLZeppaclientapiZeppaEventToUserRelationship.h"

@interface ZPAMyZeppaEvent : NSObject

@property (nonatomic, strong) GTLZeppaclientapiZeppaEvent *event;
@property (nonatomic, strong) GTLZeppaclientapiZeppaEventToUserRelationship *relationship;
@property (nonatomic, strong)NSString* confictStatus;
@property (nonatomic, strong)NSMutableArray *relationships;
@property (nonatomic, strong)NSMutableArray *comments;
@property (nonatomic, strong)NSArray *getTagIds;

@property (nonatomic, readonly)BOOL isOldEvent;
@property (nonatomic, readonly)BOOL isPrivateEvent;
@property (nonatomic, readonly)BOOL isGuestsMayInvite;
@property (nonatomic, assign)BOOL isAgenda;

-(BOOL)doesMatchEventId:(long long)eventId;
-(BOOL)hostIdDoesMatch:(long long)hostId;
-(NSArray *)getAttendingUserIds;
@end
