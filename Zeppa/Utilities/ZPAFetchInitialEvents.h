//
//  ZPAFetchInitialEvents.h
//  Zeppa
//
//  Created by Dheeraj on 17/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAUserInfoBaseClass.h"

#import "GTLZeppaeventendpointZeppaEvent.h"
#import "GTLZeppaeventendpointCollectionResponseZeppaEvent.h"
#import "GTLQueryZeppaeventendpoint.h"
#import "GTLServiceZeppaeventendpoint.h"

#import "GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship.h"
#import "GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship.h"
#import "GTLQueryZeppaeventtouserrelationshipendpoint.h"
#import "GTLServiceZeppaeventtouserrelationshipendpoint.h"

typedef void(^getZeppaEventOject)(GTLZeppaeventendpointZeppaEvent * zeppaEvent);

@interface ZPAFetchInitialEvents : ZPAUserInfoBaseClass


@property (readonly) GTLServiceZeppaeventendpoint *zeppaEventService;
@property (readonly) GTLServiceZeppaeventtouserrelationshipendpoint *zeppaEventToUserRelationshipService;

@property BOOL isNewUser;

-(void)executeZeppaApi;
@end
