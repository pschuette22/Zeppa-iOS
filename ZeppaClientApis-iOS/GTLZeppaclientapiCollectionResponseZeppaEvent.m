/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiCollectionResponseZeppaEvent.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiCollectionResponseZeppaEvent (0 custom class methods, 2 custom properties)

#import "GTLZeppaclientapiCollectionResponseZeppaEvent.h"

#import "GTLZeppaclientapiZeppaEvent.h"

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiCollectionResponseZeppaEvent
//

@implementation GTLZeppaclientapiCollectionResponseZeppaEvent
@dynamic items, nextPageToken;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map = @{
    @"items" : [GTLZeppaclientapiZeppaEvent class]
  };
  return map;
}

@end
