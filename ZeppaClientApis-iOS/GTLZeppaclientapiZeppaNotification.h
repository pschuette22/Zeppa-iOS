/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiZeppaNotification.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiZeppaNotification (0 custom class methods, 12 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppaclientapiKey;

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiZeppaNotification
//

@interface GTLZeppaclientapiZeppaNotification : GTLObject
@property (nonatomic, retain) NSNumber *created;  // longLongValue
@property (nonatomic, retain) NSNumber *eventId;  // longLongValue
@property (nonatomic, retain) NSNumber *expires;  // longLongValue
@property (nonatomic, retain) NSNumber *hasSeen;  // boolValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (nonatomic, retain) NSNumber *identifier;  // longLongValue

@property (nonatomic, retain) GTLZeppaclientapiKey *key;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, retain) NSNumber *recipientId;  // longLongValue
@property (nonatomic, retain) NSNumber *senderId;  // longLongValue
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, retain) NSNumber *updated;  // longLongValue
@end