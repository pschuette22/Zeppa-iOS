//
//  ZPAZeppaEventSingleton.h
//  Zeppa
//
//  Created by Dheeraj on 21/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAMyZeppaEvent.h"

#import "GTLZeppaclientapiZeppaEvent.h"

@interface ZPAZeppaEventSingleton : NSObject

@property (nonatomic, strong)NSMutableArray *zeppaEvents;
@property (nonatomic, strong)NSMutableArray *relationships;

+(ZPAZeppaEventSingleton *)sharedObject;
+(void)resetObject;
-(void)clear;

-(void)clearOldEvents;

-(void)addZeppaEvents:(ZPAMyZeppaEvent *)event;

-(BOOL)removeMediator:(ZPAMyZeppaEvent *)event;

-(void)removeMediatorsForUser:(long long)userId;

-(void)removeEventById:(long long)eventId;

-(BOOL)relationshipAlreadyHeld:(GTLZeppaclientapiZeppaEventToUserRelationship *)relation;
-(ZPAMyZeppaEvent *)getEventById:(long long)eventId;

-(NSArray *)getEventMediatorsForFriend:(long long)userId;

-(NSArray *)getHostedEventMediators;

-(NSArray *)getInterestingEventMediators;


-(ZPAMyZeppaEvent *)getMatchingEventMediator:(GTLZeppaclientapiZeppaEvent *)event;

-(void)setConflictIndicator:(UIImageView *)imageView withZeppaEvent:(ZPAMyZeppaEvent *)zeppaEvent;

-(NSArray *)getAttendingUserIds:(ZPAMyZeppaEvent *)zeppaEvent;

-(void)notificationChangeForEvents;

@end
