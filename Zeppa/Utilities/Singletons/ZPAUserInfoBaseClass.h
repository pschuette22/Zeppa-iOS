//
//  ZPAUserInfoBaseClass.h
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTLZeppaclientapiCollectionResponseZeppaUserInfo.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaUserToUserRelationship.h"

typedef void(^getZeppaUserInfoOject)(GTLZeppaclientapiZeppaUserInfo * info);
typedef void(^getZeppaUserInfoOjectArray)(NSArray * info);



@interface ZPAUserInfoBaseClass : NSObject
@property (readonly) GTLServiceZeppaclientapi *zeppaUserInfoService;

-(void)fetchZeppaUserInfoWithParentIdentifier:(NSNumber *)identifier withCompletion:(getZeppaUserInfoOject)completion;

-(void)fetchZeppaUserInfoWithIdentifier:(NSNumber *)identifier  withCompletion:(getZeppaUserInfoOject)completion;

-(void)executeZeppaUserInfoListQueryWithAuthWithFilter:(NSString *)filter withCompletion:(getZeppaUserInfoOjectArray)completion;

-(void)setZeppaUserToUserRelationship:(GTLZeppaclientapiZeppaUserToUserRelationship *)relation WithIdentifier:(long long)identifier;
@end
