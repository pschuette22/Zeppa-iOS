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

#import "GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.h"
#import "GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship.h"
#import "GTLServiceZeppausertouserrelationshipendpoint.h"
#import "GTLQueryZeppausertouserrelationshipendpoint.h"

@interface ZPAFetchInitialMinglers : ZPAUserInfoBaseClass
@property (strong,readonly)GTLServiceZeppausertouserrelationshipendpoint *zeppaUserRelationshipService;
@property (nonatomic, strong) ZPAFetchInitialEvents *fetchInitial;
-(void)executeZeppaApi;

@end
