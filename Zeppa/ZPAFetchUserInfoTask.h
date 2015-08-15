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

#import "GTLZeppauserendpointZeppaUser.h"
#import "GTLZeppauserinfoendpointZeppaUserInfo.h"
#import "GTLZeppauserendpointKey.h"
#import "GTLZeppauserinfoendpointKey.h"
#import "GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.h"

#import "GTLServiceZeppauserinfoendpoint.h"
#import "GTLQueryZeppauserinfoendpoint.h"
#import "GTLServiceZeppausertouserrelationshipendpoint.h"
#import "GTLZeppausertouserrelationshipendpoint.h"

#import "ZPAZeppaUserSingleton.h"


@interface ZPAFetchUserInfoTask : NSObject


@property (strong,readonly) GTLServiceZeppauserinfoendpoint *userInfoService;
@property (strong,readonly) GTLServiceZeppausertouserrelationshipendpoint *userRelationshipService;
@property (nonatomic, weak) GTMOAuth2Authentication *auth;


@property (nonatomic, strong) NSNumber* currentUserId;
@property (nonatomic, strong) NSNumber* otherUserId;

@property (nonatomic, retain) GTLZeppauserinfoendpointZeppaUserInfo *zeppaUserInfo;
@property (nonatomic, retain) GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *userRelationship;


typedef void (^FetchUserInfoCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);


// When object is retrieved, call this block method
@property (nonatomic, copy) FetchUserInfoCompletionBlock completionBlock;

// Public constructor
-(id) initWithCurrentUserId: (NSNumber *) currentUserId withOtherUserId: (NSNumber *) otherUserId;

// Method call to initiate fetch task
-(void) executeWithCompletionBlock:(FetchUserInfoCompletionBlock) completionBlock;


@end
