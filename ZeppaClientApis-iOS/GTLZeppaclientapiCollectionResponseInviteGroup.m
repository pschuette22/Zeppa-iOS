/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiCollectionResponseInviteGroup.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiCollectionResponseInviteGroup (0 custom class methods, 2 custom properties)

#import "GTLZeppaclientapiCollectionResponseInviteGroup.h"

#import "GTLZeppaclientapiInviteGroup.h"

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiCollectionResponseInviteGroup
//

@implementation GTLZeppaclientapiCollectionResponseInviteGroup
@dynamic items, nextPageToken;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"items" : [GTLZeppaclientapiInviteGroup class]
  };
  return map;
}

@end
