/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLQueryEventcommentendpoint.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   eventcommentendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLQueryEventcommentendpoint (4 custom class methods, 6 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLQuery.h"
#else
  #import "GTLQuery.h"
#endif

@class GTLEventcommentendpointEventComment;

@interface GTLQueryEventcommentendpoint : GTLQuery

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

#pragma mark -
#pragma mark Service level methods
// These create a GTLQueryEventcommentendpoint object.

// Method: eventcommentendpoint.getEventComment
//  Authorization scope(s):
//   kGTLAuthScopeEventcommentendpointUserinfoEmail
// Fetches a GTLEventcommentendpointEventComment.
+ (id)queryForGetEventCommentWithIdentifier:(long long)identifier;

// Method: eventcommentendpoint.insertEventComment
//  Authorization scope(s):
//   kGTLAuthScopeEventcommentendpointUserinfoEmail
// Fetches a GTLEventcommentendpointEventComment.
+ (id)queryForInsertEventCommentWithObject:(GTLEventcommentendpointEventComment *)object;

// Method: eventcommentendpoint.listEventComment
//  Optional:
//   cursor: NSString
//   filter: NSString
//   limit: NSInteger
//   ordering: NSString
//  Authorization scope(s):
//   kGTLAuthScopeEventcommentendpointUserinfoEmail
// Fetches a GTLEventcommentendpointCollectionResponseEventComment.
+ (id)queryForListEventComment;

// Method: eventcommentendpoint.removeEventComment
//  Authorization scope(s):
//   kGTLAuthScopeEventcommentendpointUserinfoEmail
+ (id)queryForRemoveEventCommentWithIdentifier:(long long)identifier;

@end