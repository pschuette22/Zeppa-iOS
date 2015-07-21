//
//  ZPAZeppaEvent.h
//  Zeppa
//
//  Created by Dheeraj on 13/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAAppData.h"
#import "ZPAAuthenticatonHandler.h"

#import "GTLEventtagendpointEventTag.h"
#import "GTLEventtagfollowendpointEventTagFollow.h"
#import "GTLEventtagendpointCollectionResponseEventTag.h"
#import "GTLQueryEventtagendpoint.h"
#import "GTLServiceEventtagendpoint.h"

@interface ZPAZeppaEventTagSingleton : NSObject

@property (strong , readonly) GTLServiceEventtagendpoint * eventTagService;
@property (nonatomic, strong)NSMutableArray *abstactEventTagArray;
@property (nonatomic, strong) NSMutableArray * tagId;

+(ZPAZeppaEventTagSingleton *)sharedObject;
+(void)resetObject;
-(void)clear;

-(NSNumber *)getCurrentUserId;

-(void)addEventTagsFromArray:(NSArray *)array;

-(GTLEventtagendpointEventTag *)newTagInstance;

-(NSArray *)getMyTags;

-(NSArray *)getZeppaTagForUser:(long long)userId;

-(void)updateEventTagsForUserId:(long long)userId andZeppaEventTagsArray:(NSMutableArray *)eventTagsArray;

-(GTLEventtagendpointEventTag *)getZeppaTagWithId:(long long)tagId;

-(NSArray *)getTagsFromTagIdsArray:(NSArray *)ids;

-(void)removeZeppaEventTag:(GTLEventtagendpointEventTag *)tag;

-(void)removeZeppaEventTagsUsingUserId:(long long)userId;

-(void)deleteEventTagWithEventTagId:(long long)identifier;

-(void)notificationChange;

///*****************************************
#pragma mark - ZeppaEventTag Api
///*****************************************
-(void)executeEventTagListQueryWithCursor:(NSString *)cursorValue;
-(void)executeInsetEventTagWithEventTag:(GTLEventtagendpointEventTag *)eventTag WithCompletion:(getTagCompletionHandler)completion;
-(void)executeRemoveRequestWithIdentifier:(long long)identifier;
-(GTLServiceEventtagendpoint *)eventTagService;
@end
