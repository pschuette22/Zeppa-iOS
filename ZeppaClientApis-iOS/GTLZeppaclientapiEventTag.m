/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiEventTag.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiEventTag (0 custom class methods, 6 custom properties)

#import "GTLZeppaclientapiEventTag.h"

#import "GTLZeppaclientapiKey.h"

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiEventTag
//

@implementation GTLZeppaclientapiEventTag
@dynamic created, identifier, key, ownerId, tagText, updated;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map = @{
    @"identifier" : @"id"
  };
  return map;
}

@end