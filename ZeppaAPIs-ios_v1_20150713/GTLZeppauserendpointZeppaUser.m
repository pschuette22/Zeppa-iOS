/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLZeppauserendpointZeppaUser.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppauserendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppauserendpointZeppaUser (0 custom class methods, 8 custom properties)

#import "GTLZeppauserendpointZeppaUser.h"

#import "GTLZeppauserendpointKey.h"
#import "GTLZeppauserendpointZeppaUserInfo.h"

// ----------------------------------------------------------------------------
//
//   GTLZeppauserendpointZeppaUser
//

@implementation GTLZeppauserendpointZeppaUser
@dynamic authEmail, created, googleProfileId, identifier, key, updated,
         userInfo, zeppaCalendarId;

+ (NSDictionary *)propertyToJSONKeyMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:@"id"
                                forKey:@"identifier"];
  return map;
}

@end