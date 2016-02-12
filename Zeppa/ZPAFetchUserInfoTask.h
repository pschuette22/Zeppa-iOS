//
//  ZPAFetchUserInfoTask.h
//  Zeppa
//
//  Created by Peter Schuette on 8/10/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
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
#import "GTLZeppaclientapi.h"

#import "ZPAZeppaUserSingleton.h"


@interface ZPAFetchUserInfoTask : NSObject


@property (strong,readonly) GTLServiceZeppaclientapi *zeppaClientApiService;


@property (nonatomic, strong) NSNumber* currentUserId;
@property (nonatomic, strong) NSNumber* otherUserId;

@property (nonatomic, retain) GTLZeppaclientapiZeppaUserInfo *zeppaUserInfo;
@property (nonatomic, retain) GTLZeppaclientapiZeppaUserToUserRelationship *userRelationship;


typedef void (^FetchUserInfoCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);


// When object is retrieved, call this block method
@property (nonatomic, copy) FetchUserInfoCompletionBlock completionBlock;

// Public constructor
-(id) initWithCurrentUserId: (NSNumber *) currentUserId withOtherUserId: (NSNumber *) otherUserId;

// Method call to initiate fetch task
-(void) executeWithCompletionBlock:(FetchUserInfoCompletionBlock) completionBlock;


@end
