//
//  ZPAUserInfoBaseClass.h
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTLZeppauserinfoendpointCollectionResponseZeppaUserInfo.h"
#import "GTLZeppauserinfoendpointZeppaUserInfo.h"
#import "GTLQueryZeppauserinfoendpoint.h"
#import "GTLServiceZeppauserinfoendpoint.h"
#import "GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.h"

typedef void(^getZeppaUserInfoOject)(GTLZeppauserinfoendpointZeppaUserInfo * info);
typedef void(^getZeppaUserInfoOjectArray)(NSArray * info);



@interface ZPAUserInfoBaseClass : NSObject
@property (readonly) GTLServiceZeppauserinfoendpoint *zeppaUserInfoService;

-(void)fetchZeppaUserInfoWithParentIdentifier:(NSNumber *)identifier withCompletion:(getZeppaUserInfoOject)completion;

-(void)fetchZeppaUserInfoWithIdentifier:(NSNumber *)identifier  withCompletion:(getZeppaUserInfoOject)completion;

-(void)executeZeppaUserInfoListQueryWithAuthWithFilter:(NSString *)filter withCompletion:(getZeppaUserInfoOjectArray)completion;

-(void)setZepppUserToUserRelationship:(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *)relation WithIdentifier:(long long)identifier;
@end
