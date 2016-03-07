/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiZeppaEventToUserRelationship.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiZeppaEventToUserRelationship (0 custom class methods, 14 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppaclientapiKey;
@class GTLZeppaclientapiZeppaEvent;

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiZeppaEventToUserRelationship
//

@interface GTLZeppaclientapiZeppaEventToUserRelationship : GTLObject
@property (nonatomic, retain) NSNumber *created;  // longLongValue
@property (nonatomic, retain) GTLZeppaclientapiZeppaEvent *event;
@property (nonatomic, retain) NSNumber *eventHostId;  // longLongValue
@property (nonatomic, retain) NSNumber *eventId;  // longLongValue
@property (nonatomic, retain) NSNumber *expires;  // longLongValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (nonatomic, retain) NSNumber *identifier;  // longLongValue

@property (nonatomic, retain) NSNumber *invitedByUserId;  // longLongValue
@property (nonatomic, retain) NSNumber *isAttending;  // boolValue
@property (nonatomic, retain) NSNumber *isRecommended;  // boolValue
@property (nonatomic, retain) NSNumber *isWatching;  // boolValue
@property (nonatomic, retain) GTLZeppaclientapiKey *key;
@property (nonatomic, retain) NSNumber *updated;  // longLongValue
@property (nonatomic, retain) NSNumber *userId;  // longLongValue
@property (nonatomic, retain) NSNumber *wasInvited;  // boolValue
@end
