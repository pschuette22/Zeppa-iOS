/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLQueryPhotoinfoendpoint.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   photoinfoendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLQueryPhotoinfoendpoint (4 custom class methods, 4 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLQuery.h"
#else
  #import "GTLQuery.h"
#endif

@class GTLPhotoinfoendpointPhotoInfo;

@interface GTLQueryPhotoinfoendpoint : GTLQuery

//
// Parameters valid on all methods.
//

// Selector specifying which fields to include in a partial response.
@property (copy) NSString *fields;

//
// Method-specific parameters; see the comments below for more information.
//
@property (copy) NSString *cursor;
// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (assign) long long identifier;
@property (assign) NSInteger limit;

#pragma mark -
#pragma mark Service level methods
// These create a GTLQueryPhotoinfoendpoint object.

// Method: photoinfoendpoint.getPhotoInfo
//  Authorization scope(s):
//   kGTLAuthScopePhotoinfoendpointUserinfoEmail
// Fetches a GTLPhotoinfoendpointPhotoInfo.
+ (id)queryForGetPhotoInfoWithIdentifier:(long long)identifier;

// Method: photoinfoendpoint.insertPhotoInfo
//  Authorization scope(s):
//   kGTLAuthScopePhotoinfoendpointUserinfoEmail
// Fetches a GTLPhotoinfoendpointPhotoInfo.
+ (id)queryForInsertPhotoInfoWithObject:(GTLPhotoinfoendpointPhotoInfo *)object;

// Method: photoinfoendpoint.listPhotoInfo
//  Optional:
//   cursor: NSString
//   limit: NSInteger
//  Authorization scope(s):
//   kGTLAuthScopePhotoinfoendpointUserinfoEmail
// Fetches a GTLPhotoinfoendpointCollectionResponsePhotoInfo.
+ (id)queryForListPhotoInfo;

// Method: photoinfoendpoint.removePhotoInfo
//  Authorization scope(s):
//   kGTLAuthScopePhotoinfoendpointUserinfoEmail
+ (id)queryForRemovePhotoInfoWithIdentifier:(long long)identifier;

@end
