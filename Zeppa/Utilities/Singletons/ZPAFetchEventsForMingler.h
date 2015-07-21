//
//  ZPAFetchEventsForMingler.h
//  Zeppa
//
//  Created by Dheeraj on 27/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAEventInfoBaseClass.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPAMyZeppaEvent.h"

#import "GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship.h"
#import "GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship.h"
#import "GTLServiceZeppaeventtouserrelationshipendpoint.h"
#import "GTLQueryZeppaeventtouserrelationshipendpoint.h"

@protocol MutualMinglerEventDelegate <NSObject>
@required

-(void)getMutualMinglerEventsList;

@end

@interface ZPAFetchEventsForMingler : ZPAEventInfoBaseClass

@property (nonatomic, assign)id<MutualMinglerEventDelegate>delegate;

@property (nonatomic,readonly)GTLServiceZeppaeventtouserrelationshipendpoint *zeppaEventToUserRelationshipService;

-(void)executeZeppaApiWithMinglerId:(long long)mingleIdentifier;
@end
