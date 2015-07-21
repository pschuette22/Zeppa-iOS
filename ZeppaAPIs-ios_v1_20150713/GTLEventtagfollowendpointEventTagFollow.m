/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLEventtagfollowendpointEventTagFollow.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   eventtagfollowendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLEventtagfollowendpointEventTagFollow (0 custom class methods, 7 custom properties)

#import "GTLEventtagfollowendpointEventTagFollow.h"

#import "GTLEventtagfollowendpointKey.h"

// ----------------------------------------------------------------------------
//
//   GTLEventtagfollowendpointEventTagFollow
//

@implementation GTLEventtagfollowendpointEventTagFollow
@dynamic created, followerId, identifier, key, tagId, tagOwnerId, updated;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

@end
