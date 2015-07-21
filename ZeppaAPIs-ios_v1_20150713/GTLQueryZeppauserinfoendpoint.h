/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLQueryZeppauserinfoendpoint.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppauserinfoendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLQueryZeppauserinfoendpoint (5 custom class methods, 7 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLQuery.h"
#else
  #import "GTLQuery.h"
#endif

@class GTLZeppauserinfoendpointZeppaUserInfo;

@interface GTLQueryZeppauserinfoendpoint : GTLQuery

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
@property (assign) long long requestedParentId;

#pragma mark -
#pragma mark Service level methods
// These create a GTLQueryZeppauserinfoendpoint object.

// Method: zeppauserinfoendpoint.fetchZeppaUserInfoByParentId
//  Authorization scope(s):
//   kGTLAuthScopeZeppauserinfoendpointUserinfoEmail
// Fetches a GTLZeppauserinfoendpointZeppaUserInfo.
+ (id)queryForFetchZeppaUserInfoByParentIdWithRequestedParentId:(long long)requestedParentId;

// Method: zeppauserinfoendpoint.getZeppaUserInfo
//  Authorization scope(s):
//   kGTLAuthScopeZeppauserinfoendpointUserinfoEmail
// Fetches a GTLZeppauserinfoendpointZeppaUserInfo.
+ (id)queryForGetZeppaUserInfoWithIdentifier:(long long)identifier;

// Method: zeppauserinfoendpoint.insertZeppaUserInfo
//  Authorization scope(s):
//   kGTLAuthScopeZeppauserinfoendpointUserinfoEmail
// Fetches a GTLZeppauserinfoendpointZeppaUserInfo.
+ (id)queryForInsertZeppaUserInfoWithObject:(GTLZeppauserinfoendpointZeppaUserInfo *)object;

// Method: zeppauserinfoendpoint.listZeppaUserInfo
//  Optional:
//   cursor: NSString
//   filter: NSString
//   limit: NSInteger
//   ordering: NSString
//  Authorization scope(s):
//   kGTLAuthScopeZeppauserinfoendpointUserinfoEmail
// Fetches a GTLZeppauserinfoendpointCollectionResponseZeppaUserInfo.
+ (id)queryForListZeppaUserInfo;

// Method: zeppauserinfoendpoint.updateZeppaUserInfo
//  Authorization scope(s):
//   kGTLAuthScopeZeppauserinfoendpointUserinfoEmail
// Fetches a GTLZeppauserinfoendpointZeppaUserInfo.
+ (id)queryForUpdateZeppaUserInfoWithObject:(GTLZeppauserinfoendpointZeppaUserInfo *)object;

@end