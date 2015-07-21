/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLEventtagendpointEventTag.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   eventtagendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLEventtagendpointEventTag (0 custom class methods, 6 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLEventtagendpointKey;

// ----------------------------------------------------------------------------
//
//   GTLEventtagendpointEventTag
//

@interface GTLEventtagendpointEventTag : GTLObject
@property (retain) NSNumber *created;  // longLongValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (retain) NSNumber *identifier;  // longLongValue

@property (retain) GTLEventtagendpointKey *key;
@property (retain) NSNumber *ownerId;  // longLongValue
@property (copy) NSString *tagText;
@property (retain) NSNumber *updated;  // longLongValue
@end
