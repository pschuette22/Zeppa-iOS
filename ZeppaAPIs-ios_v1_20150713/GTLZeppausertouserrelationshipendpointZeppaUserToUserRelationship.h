/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppausertouserrelationshipendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship (0 custom class methods, 7 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppausertouserrelationshipendpointKey;

// ----------------------------------------------------------------------------
//
//   GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship
//

@interface GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship : GTLObject
@property (retain) NSNumber *created;  // longLongValue
@property (retain) NSNumber *creatorId;  // longLongValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (retain) NSNumber *identifier;  // longLongValue

@property (retain) GTLZeppausertouserrelationshipendpointKey *key;
@property (copy) NSString *relationshipType;
@property (retain) NSNumber *subjectId;  // longLongValue
@property (retain) NSNumber *updated;  // longLongValue
@end
