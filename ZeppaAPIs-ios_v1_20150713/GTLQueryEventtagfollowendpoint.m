/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLQueryEventtagfollowendpoint.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   eventtagfollowendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLQueryEventtagfollowendpoint (5 custom class methods, 6 custom properties)

#import "GTLQueryEventtagfollowendpoint.h"

#import "GTLEventtagfollowendpointCollectionResponseEventTagFollow.h"
#import "GTLEventtagfollowendpointEventTagFollow.h"

@implementation GTLQueryEventtagfollowendpoint

@dynamic cursor, fields, filter, identifier, limit, ordering;

+ (NSDictionary *)parameterNameMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

#pragma mark -
#pragma mark Service level methods
// These create a GTLQueryEventtagfollowendpoint object.

+ (id)queryForGetEventTagFollowWithIdentifier:(long long)identifier {
  NSString *methodName = @"eventtagfollowendpoint.getEventTagFollow";
  GTLQueryEventtagfollowendpoint *query = [self queryWithMethodName:methodName];
  query.identifier = identifier;
  query.expectedObjectClass = [GTLEventtagfollowendpointEventTagFollow class];
  return query;
}

+ (id)queryForInsertEventTagFollowWithObject:(GTLEventtagfollowendpointEventTagFollow *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"eventtagfollowendpoint.insertEventTagFollow";
  GTLQueryEventtagfollowendpoint *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLEventtagfollowendpointEventTagFollow class];
  return query;
}

+ (id)queryForListEventTagFollow {
  NSString *methodName = @"eventtagfollowendpoint.listEventTagFollow";
  GTLQueryEventtagfollowendpoint *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLEventtagfollowendpointCollectionResponseEventTagFollow class];
  return query;
}

+ (id)queryForRemoveEventTagFollowWithIdentifier:(long long)identifier {
  NSString *methodName = @"eventtagfollowendpoint.removeEventTagFollow";
  GTLQueryEventtagfollowendpoint *query = [self queryWithMethodName:methodName];
  query.identifier = identifier;
  return query;
}

+ (id)queryForUpdateEventTagFollowWithObject:(GTLEventtagfollowendpointEventTagFollow *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"eventtagfollowendpoint.updateEventTagFollow";
  GTLQueryEventtagfollowendpoint *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLEventtagfollowendpointEventTagFollow class];
  return query;
}

@end
