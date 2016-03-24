/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiDeviceInfo.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiDeviceInfo (0 custom class methods, 12 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppaclientapiKey;

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiDeviceInfo
//

@interface GTLZeppaclientapiDeviceInfo : GTLObject
@property (nonatomic, retain) NSNumber *bugfix;  // intValue
@property (nonatomic, retain) NSNumber *created;  // longLongValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (nonatomic, retain) NSNumber *identifier;  // longLongValue

@property (nonatomic, retain) GTLZeppaclientapiKey *key;
@property (nonatomic, retain) NSNumber *lastLogin;  // longLongValue
@property (nonatomic, retain) NSNumber *loggedIn;  // boolValue
@property (nonatomic, retain) NSNumber *ownerId;  // longLongValue
@property (nonatomic, copy) NSString *phoneType;
@property (nonatomic, copy) NSString *registrationId;
@property (nonatomic, retain) NSNumber *update;  // intValue
@property (nonatomic, retain) NSNumber *updated;  // longLongValue
@property (nonatomic, retain) NSNumber *version;  // intValue
@end