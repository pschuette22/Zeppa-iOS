/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiZeppaUser.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiZeppaUser (0 custom class methods, 11 custom properties)

#import "GTLZeppaclientapiZeppaUser.h"

#import "GTLZeppaclientapiKey.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiZeppaUser
//

@implementation GTLZeppaclientapiZeppaUser
@dynamic authEmail, created, identifier, initialTags, key, latitude, longitude,
         phoneNumber, updated, userInfo, zeppaCalendarId;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map = @{
    @"identifier" : @"id"
  };
  return map;
}

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"initialTags" : [NSString class]
  };
  return map;
}

@end
