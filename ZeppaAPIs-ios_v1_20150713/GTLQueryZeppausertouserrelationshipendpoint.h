/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLQueryZeppausertouserrelationshipendpoint.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppausertouserrelationshipendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLQueryZeppausertouserrelationshipendpoint (5 custom class methods, 7 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLQuery.h"
#else
  #import "GTLQuery.h"
#endif

@class GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship;

@interface GTLQueryZeppausertouserrelationshipendpoint : GTLQuery

//
// Parameters valid on all methods.
//

// Selector specifying which fields to include in a partial response.
@property (copy) NSString *fields;

//
// Method-specific parameters; see the comments below for more information.
//
@property (copy) NSString *cursor;
@property (copy) NSString *filter;
// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (assign) long long identifier;
@property (assign) NSInteger limit;
@property (copy) NSString *ordering;
@property (assign) long long relationshipId;

#pragma mark -
#pragma mark Service level methods
// These create a GTLQueryZeppausertouserrelationshipendpoint object.

// Method: zeppausertouserrelationshipendpoint.getZeppaUserToUserRelationship
//  Authorization scope(s):
//   kGTLAuthScopeZeppausertouserrelationshipendpointUserinfoEmail
// Fetches a GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.
+ (id)queryForGetZeppaUserToUserRelationshipWithRelationshipId:(long long)relationshipId;

// Method: zeppausertouserrelationshipendpoint.insertZeppaUserToUserRelationship
//  Authorization scope(s):
//   kGTLAuthScopeZeppausertouserrelationshipendpointUserinfoEmail
// Fetches a GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.
+ (id)queryForInsertZeppaUserToUserRelationshipWithObject:(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *)object;

// Method: zeppausertouserrelationshipendpoint.listZeppaUserToUserRelationship
//  Optional:
//   cursor: NSString
//   filter: NSString
//   limit: NSInteger
//   ordering: NSString
//  Authorization scope(s):
//   kGTLAuthScopeZeppausertouserrelationshipendpointUserinfoEmail
// Fetches a GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship.
+ (id)queryForListZeppaUserToUserRelationship;

// Method: zeppausertouserrelationshipendpoint.removeZeppaUserToUserRelationship
//  Authorization scope(s):
//   kGTLAuthScopeZeppausertouserrelationshipendpointUserinfoEmail
+ (id)queryForRemoveZeppaUserToUserRelationshipWithIdentifier:(long long)identifier;

// Method: zeppausertouserrelationshipendpoint.updateZeppaUserToUserRelationship
//  Authorization scope(s):
//   kGTLAuthScopeZeppausertouserrelationshipendpointUserinfoEmail
// Fetches a GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship.
+ (id)queryForUpdateZeppaUserToUserRelationshipWithObject:(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *)object;

@end
