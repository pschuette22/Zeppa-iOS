//
//  ZPAFetchInitialMinglers.h
//  Zeppa
//
//  Created by Dheeraj on 17/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAUserInfoBaseClass.h"
#import "ZPAFetchInitialEvents.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAZeppaUserSingleton.h"

#import "GTLZeppaclientapiZeppaUserToUserRelationship.h"
#import "GTLZeppaclientapiCollectionResponseZeppaUserToUserRelationship.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"

@interface ZPAFetchInitialMinglers : ZPAUserInfoBaseClass
@property (strong,readonly)GTLServiceZeppaclientapi *zeppaUserRelationshipService;
@property (nonatomic, strong) ZPAFetchInitialEvents *fetchInitial;
-(void)executeZeppaApi;

@end
