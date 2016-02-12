//
//  ZPAFetchInitialEvents.h
//  Zeppa
//
//  Created by Dheeraj on 17/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAUserInfoBaseClass.h"

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLZeppaclientapiCollectionResponseZeppaEvent.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"

#import "GTLZeppaclientapiZeppaEventToUserRelationship.h"
#import "GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"

typedef void(^getZeppaEventOject)(GTLZeppaclientapiZeppaEvent * zeppaEvent);

@interface ZPAFetchInitialEvents : ZPAUserInfoBaseClass


@property (readonly) GTLServiceZeppaclientapi *zeppaEventService;
@property (readonly) GTLServiceZeppaclientapi *zeppaEventToUserRelationshipService;

@property BOOL isNewUser;

-(void)executeZeppaApi;
@end
