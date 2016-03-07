//
//  ZPAEventInfoBaseClass.h
//  Zeppa
//
//  Created by Dheeraj on 28/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLZeppaclientapiCollectionResponseZeppaEvent.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"


@protocol ZPAEventInfoMethods <NSObject>

@required
- (BOOL) isFeedEvent;
- (BOOL) isInterestingEvent;
- (BOOL) isAttending;
- (BOOL) isWatching;
- (BOOL) isMyEvent;
-(ZPAUserInfoBase*) getHostInfo;

@end

@interface ZPAEventInfoBase : NSObject <ZPAEventInfoMethods>

@property (nonatomic, strong) GTLZeppaclientapiZeppaEvent *zeppaEvent;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, strong) NSMutableArray *relationships;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSString *conflictStatus;
// TODO: hold a list of calendar events with cooresponding time

- (id) initWithZeppaEvent:(GTLZeppaclientapiZeppaEvent*) event;

- (BOOL) isOldEvent;

@end
