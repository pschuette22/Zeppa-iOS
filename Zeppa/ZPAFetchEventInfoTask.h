//
//  ZPAFetchEventInfoTask.h
//  Zeppa
//
//  Created by Peter Schuette on 8/10/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAAuthenticatonHandler.h"
#import "GTLZeppaeventendpointZeppaEvent.h"
#import "GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship.h"
#import "GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship.h"

#import "GTLServiceZeppaeventendpoint.h"
#import "GTLQueryZeppaeventendpoint.h"
#import "GTLServiceZeppaeventtouserrelationshipendpoint.h"
#import "GTLQueryZeppaeventtouserrelationshipendpoint.h"

#import "ZPAZeppaEventSingleton.h"

@interface ZPAFetchEventInfoTask : NSObject

@property (strong, readonly) GTLServiceZeppaeventendpoint *eventService;
@property (strong, readonly) GTLServiceZeppaeventtouserrelationshipendpoint *relationshipService;
@property (nonatomic, weak) GTMOAuth2Authentication *auth;

@property (nonatomic, strong) NSNumber* eventId;
@property (nonatomic, strong) NSNumber* userId;

@property (nonatomic, retain) GTLZeppaeventendpointZeppaEvent *zeppaEvent;
@property (nonatomic, retain) GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *relationship;

typedef void (^FetchZeppaEventCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);

@property (nonatomic, copy) FetchZeppaEventCompletionBlock completionBlock;

-(id) initWithEventId: (NSNumber *) eventId andUserId: (NSNumber *) userId;

-(void) executeWithCompletionBlock: (FetchZeppaEventCompletionBlock) completionBlock;
-(GTLServiceTicket *) fetchEvent;
-(GTLServiceTicket *) fetchEventRelationship;

@end
