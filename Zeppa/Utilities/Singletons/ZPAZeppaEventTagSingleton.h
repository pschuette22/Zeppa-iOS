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

#import "GTLZeppaclientapiEventTag.h"
#import "GTLZeppaclientapiEventTagFollow.h"
#import "GTLZeppaclientapiCollectionResponseEventTag.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"

@interface ZPAZeppaEventTagSingleton : NSObject

@property (strong , readonly) GTLServiceZeppaclientapi * eventTagService;
@property (nonatomic, strong)NSMutableArray *abstactEventTagArray;
@property (nonatomic, strong) NSMutableArray * tagId;


+(ZPAZeppaEventTagSingleton *)sharedObject;
+(void)resetObject;
-(void)clear;

-(NSNumber *)getCurrentUserId;

-(void)addMyEventTagsFromArray:(NSArray *)array;

-(GTLZeppaclientapiEventTag *)newTagInstance;

-(NSArray *)getMyTags;

-(NSArray *)getZeppaTagForUser:(long long)userId;

-(void)updateEventTagsForUserId:(long long)userId andZeppaEventTagsArray:(NSMutableArray *)eventTagsArray;

-(GTLZeppaclientapiEventTag *)getZeppaTagWithId:(long long)tagId;

-(NSArray *)getTagsFromTagIdsArray:(NSArray *)ids;



-(void)removeZeppaEventTag:(GTLZeppaclientapiEventTag *)tag;

-(void)removeZeppaEventTagsUsingUserId:(long long)userId;

-(void)deleteEventTagWithEventTagId:(long long)identifier;

-(void)notificationChange;

///*****************************************
#pragma mark - ZeppaEventTag Api
///*****************************************
-(void)executeEventTagListQueryWithCursor:(NSString *)cursorValue;
-(void)executeInsetEventTagWithEventTag:(GTLZeppaclientapiEventTag *)eventTag WithCompletion:(getTagCompletionHandler)completion;
-(void)executeRemoveRequestWithIdentifier:(long long)identifier;
-(GTLServiceZeppaclientapi *)eventTagService;
@end
