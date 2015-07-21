/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLEventtagendpointKey.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   eventtagendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLEventtagendpointKey (0 custom class methods, 7 custom properties)

#import "GTLEventtagendpointKey.h"

// ----------------------------------------------------------------------------
//
//   GTLEventtagendpointKey
//

@implementation GTLEventtagendpointKey
@dynamic appId, complete, identifier, kind, name, namespaceProperty, parent;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObjectsAndKeys:
      @"id", @"identifier",
      @"namespace", @"namespaceProperty",
      nil];
  return map;
}

@end
