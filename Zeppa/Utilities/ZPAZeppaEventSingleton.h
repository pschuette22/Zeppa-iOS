//
//  ZPAZeppaEventSingleton.h
//  Zeppa
//
//  Created by Dheeraj on 21/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAEventInfoBase.h"
#import "ZPAInitialEventsQuery.h"
#import "ZPANewEventsQuery.h"
#import "ZPAMoreEventsQuery.h"

#import "GTLZeppaclientapiZeppaEvent.h"

@interface ZPAZeppaEventSingleton : NSObject

@property (nonatomic, strong)NSMutableArray<ZPAEventInfoBase *> *zeppaEvents;

typedef void (^OnEventQueryCompletion)(GTLServiceTicket*,GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship*,NSError*);

+(ZPAZeppaEventSingleton *)sharedObject;
+(void)resetObject;
-(void)clear;

-(void)clearOldEvents;

-(void)addZeppaEvent:(ZPAEventInfoBase *)event;

-(BOOL)removeMediator:(ZPAEventInfoBase *)event;

-(void)removeMediatorsForUser:(long long)userId;

-(void)removeEventById:(long long)eventId;

-(BOOL) fetchInitialEvents:(OnEventQueryCompletion) completion;

-(BOOL) fetchNewEvents:(OnEventQueryCompletion) completion;

-(BOOL) fetchMoreEvents:(OnEventQueryCompletion) completion;

-(ZPAEventInfoBase *)getEventById:(long long)eventId;

-(NSArray *)getEventMediatorsForFriend:(long long)userId;

-(NSArray *)getHostedEventMediators;

-(NSArray *)getInterestingEventMediators;

-(void)notificationChangeForEvents;

@end
