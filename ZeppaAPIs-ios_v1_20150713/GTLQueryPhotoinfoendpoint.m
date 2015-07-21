/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLQueryPhotoinfoendpoint.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   photoinfoendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLQueryPhotoinfoendpoint (4 custom class methods, 4 custom properties)

#import "GTLQueryPhotoinfoendpoint.h"

#import "GTLPhotoinfoendpointCollectionResponsePhotoInfo.h"
#import "GTLPhotoinfoendpointPhotoInfo.h"

@implementation GTLQueryPhotoinfoendpoint

@dynamic cursor, fields, identifier, limit;

+ (NSDictionary *)parameterNameMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

#pragma mark -
#pragma mark Service level methods
// These create a GTLQueryPhotoinfoendpoint object.

+ (id)queryForGetPhotoInfoWithIdentifier:(long long)identifier {
  NSString *methodName = @"photoinfoendpoint.getPhotoInfo";
  GTLQueryPhotoinfoendpoint *query = [self queryWithMethodName:methodName];
  query.identifier = identifier;
  query.expectedObjectClass = [GTLPhotoinfoendpointPhotoInfo class];
  return query;
}

+ (id)queryForInsertPhotoInfoWithObject:(GTLPhotoinfoendpointPhotoInfo *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"photoinfoendpoint.insertPhotoInfo";
  GTLQueryPhotoinfoendpoint *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLPhotoinfoendpointPhotoInfo class];
  return query;
}

+ (id)queryForListPhotoInfo {
  NSString *methodName = @"photoinfoendpoint.listPhotoInfo";
  GTLQueryPhotoinfoendpoint *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLPhotoinfoendpointCollectionResponsePhotoInfo class];
  return query;
}

+ (id)queryForRemovePhotoInfoWithIdentifier:(long long)identifier {
  NSString *methodName = @"photoinfoendpoint.removePhotoInfo";
  GTLQueryPhotoinfoendpoint *query = [self queryWithMethodName:methodName];
  query.identifier = identifier;
  return query;
}

@end