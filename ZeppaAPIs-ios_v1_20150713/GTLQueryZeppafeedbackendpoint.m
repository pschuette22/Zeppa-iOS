/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLQueryZeppafeedbackendpoint.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppafeedbackendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLQueryZeppafeedbackendpoint (5 custom class methods, 7 custom properties)

#import "GTLQueryZeppafeedbackendpoint.h"

#import "GTLZeppafeedbackendpointCollectionResponseZeppaFeedback.h"
#import "GTLZeppafeedbackendpointZeppaFeedback.h"

@implementation GTLQueryZeppafeedbackendpoint

@dynamic cursor, fields, filter, identifier, limit, ordering,
         parameterDeclaration;

+ (NSDictionary *)parameterNameMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

#pragma mark -
#pragma mark Service level methods
// These create a GTLQueryZeppafeedbackendpoint object.

+ (id)queryForGetZeppaFeedbackWithIdentifier:(long long)identifier {
  NSString *methodName = @"zeppafeedbackendpoint.getZeppaFeedback";
  GTLQueryZeppafeedbackendpoint *query = [self queryWithMethodName:methodName];
  query.identifier = identifier;
  query.expectedObjectClass = [GTLZeppafeedbackendpointZeppaFeedback class];
  return query;
}

+ (id)queryForInsertZeppaFeedbackWithObject:(GTLZeppafeedbackendpointZeppaFeedback *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"zeppafeedbackendpoint.insertZeppaFeedback";
  GTLQueryZeppafeedbackendpoint *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLZeppafeedbackendpointZeppaFeedback class];
  return query;
}

+ (id)queryForListZeppaFeedback {
  NSString *methodName = @"zeppafeedbackendpoint.listZeppaFeedback";
  GTLQueryZeppafeedbackendpoint *query = [self queryWithMethodName:methodName];
  query.expectedObjectClass = [GTLZeppafeedbackendpointCollectionResponseZeppaFeedback class];
  return query;
}

+ (id)queryForRemoveZeppaFeedbackWithIdentifier:(long long)identifier {
  NSString *methodName = @"zeppafeedbackendpoint.removeZeppaFeedback";
  GTLQueryZeppafeedbackendpoint *query = [self queryWithMethodName:methodName];
  query.identifier = identifier;
  return query;
}

+ (id)queryForUpdateZeppaFeedbackWithObject:(GTLZeppafeedbackendpointZeppaFeedback *)object {
  if (object == nil) {
    GTL_DEBUG_ASSERT(object != nil, @"%@ got a nil object", NSStringFromSelector(_cmd));
    return nil;
  }
  NSString *methodName = @"zeppafeedbackendpoint.updateZeppaFeedback";
  GTLQueryZeppafeedbackendpoint *query = [self queryWithMethodName:methodName];
  query.bodyObject = object;
  query.expectedObjectClass = [GTLZeppafeedbackendpointZeppaFeedback class];
  return query;
}

@end
