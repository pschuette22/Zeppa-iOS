/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiEventComment.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiEventComment (0 custom class methods, 7 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppaclientapiKey;

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiEventComment
//

@interface GTLZeppaclientapiEventComment : GTLObject
@property (nonatomic, retain) NSNumber *commenterId;  // longLongValue
@property (nonatomic, retain) NSNumber *created;  // longLongValue
@property (nonatomic, retain) NSNumber *eventId;  // longLongValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (nonatomic, retain) NSNumber *identifier;  // longLongValue

@property (nonatomic, retain) GTLZeppaclientapiKey *key;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSNumber *updated;  // longLongValue
@end
