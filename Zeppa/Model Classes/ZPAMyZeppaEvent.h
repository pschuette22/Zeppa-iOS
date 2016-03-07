//
//  ZPAMyZeppaEvent.h
//  Zeppa
//
//  Created by Dheeraj on 21/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAEventInfoBase.h"
#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLZeppaclientapiKey.h"
#import "GTLZeppaclientapiZeppaEventToUserRelationship.h"

@interface ZPAMyZeppaEvent : ZPAEventInfoBase <ZPAEventInfoMethods>

- (id) initWithZeppaEvent:(GTLZeppaclientapiZeppaEvent *)event;

- (BOOL) isFeedEvent;
- (BOOL) isInterestingEvent;
- (BOOL) isAttending;
- (BOOL) isWatching;
- (void) cancelEvent;
- (BOOL) isMyEvent;
-(ZPAMyZeppaUser*) getHostInfo;


@end
