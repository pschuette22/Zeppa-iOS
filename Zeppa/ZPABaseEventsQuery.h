//
//  ZPABaseEventsQuery.h
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAStaticHelper.h"
#import "ZPAConstants.h"
#import "ZPAUserDefault.h"
#import "ZPADateHelper.h"

@protocol ZPAEventsQueryMethods <NSObject>
- (NSString*) authToken;
- (NSInteger) getLimit;
- (BOOL) addEventsForEventResponse: (GTLZeppaclientapiCollectionResponseZeppaEvent *)response;
- (BOOL) addEventsForEventRelationshipResponse: (GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *)response;
- (void) onCompletion:(GTLServiceTicket*)ticket withResponse: (GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *) response withError: (NSError*) error;
-(NSNumber *) currentUserId;
@end

@interface ZPABaseEventsQuery : NSObject <ZPAEventsQueryMethods>

typedef void (^OnEventQueryCompletion)(GTLServiceTicket*,GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship*,NSError*);

// Execute method
-(void) executeWithAuthToken:(NSString *)authToken completion:(OnEventQueryCompletion) completion;

// Service method
-(GTLServiceZeppaclientapi*) service;


@end
