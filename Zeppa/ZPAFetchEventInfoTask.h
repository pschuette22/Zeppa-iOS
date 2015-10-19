//
//  ZPAFetchEventInfoTask.h
//  Zeppa
//
//  Created by Peter Schuette on 8/10/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAAuthenticatonHandler.h"

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLZeppaclientapiZeppaEventToUserRelationship.h"
#import "GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"

#import "ZPAZeppaEventSingleton.h"

@interface ZPAFetchEventInfoTask : NSObject

@property (strong, readonly) GTLServiceZeppaclientapi *eventService;
@property (strong, readonly) GTLServiceZeppaclientapi *relationshipService;
@property (nonatomic, weak) GTMOAuth2Authentication *auth;

@property (nonatomic, strong) NSNumber* eventId;
@property (nonatomic, strong) NSNumber* userId;

@property (nonatomic, retain) GTLZeppaclientapiZeppaEvent *zeppaEvent;
@property (nonatomic, retain) GTLZeppaclientapiZeppaEventToUserRelationship *relationship;

typedef void (^FetchZeppaEventCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);

@property (nonatomic, copy) FetchZeppaEventCompletionBlock completionBlock;

-(id) initWithEventId: (NSNumber *) eventId andUserId: (NSNumber *) userId;

-(void) executeWithCompletionBlock: (FetchZeppaEventCompletionBlock) completionBlock;
-(GTLServiceTicket *) fetchEvent;
-(GTLServiceTicket *) fetchEventRelationship;

@end
