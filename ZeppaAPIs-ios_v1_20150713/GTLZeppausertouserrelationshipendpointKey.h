/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLZeppausertouserrelationshipendpointKey.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppausertouserrelationshipendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppausertouserrelationshipendpointKey (0 custom class methods, 7 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppausertouserrelationshipendpointKey;

// ----------------------------------------------------------------------------
//
//   GTLZeppausertouserrelationshipendpointKey
//

@interface GTLZeppausertouserrelationshipendpointKey : GTLObject
@property (copy) NSString *appId;
@property (retain) NSNumber *complete;  // boolValue

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (retain) NSNumber *identifier;  // longLongValue

@property (copy) NSString *kind;
@property (copy) NSString *name;

// Remapped to 'namespaceProperty' to avoid language reserved word 'namespace'.
@property (copy) NSString *namespaceProperty;

@property (retain) GTLZeppausertouserrelationshipendpointKey *parent;
@end