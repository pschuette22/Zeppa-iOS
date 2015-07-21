/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppausertouserrelationshipendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship (0 custom class methods, 2 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship;

// ----------------------------------------------------------------------------
//
//   GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship
//

// This class supports NSFastEnumeration over its "items" property. It also
// supports -itemAtIndex: to retrieve individual objects from "items".

@interface GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship : GTLCollectionObject
@property (retain) NSArray *items;  // of GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship
@property (copy) NSString *nextPageToken;
@end