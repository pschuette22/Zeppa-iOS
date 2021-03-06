/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiZeppaUser.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiZeppaUser (0 custom class methods, 11 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppaclientapiKey;
@class GTLZeppaclientapiZeppaUserInfo;

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiZeppaUser
//

@interface GTLZeppaclientapiZeppaUser : GTLObject
@property (nonatomic, copy) NSString *authEmail;
@property (nonatomic, retain) NSNumber *created;  // longLongValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (nonatomic, retain) NSNumber *identifier;  // longLongValue

@property (nonatomic, retain) NSArray *initialTags;  // of NSString
@property (nonatomic, retain) GTLZeppaclientapiKey *key;
@property (nonatomic, retain) NSNumber *latitude;  // longLongValue
@property (nonatomic, retain) NSNumber *longitude;  // longLongValue
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, retain) NSNumber *updated;  // longLongValue
@property (nonatomic, retain) GTLZeppaclientapiZeppaUserInfo *userInfo;
@property (nonatomic, copy) NSString *zeppaCalendarId;
@end
