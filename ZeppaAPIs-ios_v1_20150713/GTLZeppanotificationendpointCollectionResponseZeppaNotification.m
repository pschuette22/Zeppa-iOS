/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLZeppanotificationendpointCollectionResponseZeppaNotification.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppanotificationendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppanotificationendpointCollectionResponseZeppaNotification (0 custom class methods, 2 custom properties)

#import "GTLZeppanotificationendpointCollectionResponseZeppaNotification.h"

#import "GTLZeppanotificationendpointZeppaNotification.h"

// ----------------------------------------------------------------------------
//
//   GTLZeppanotificationendpointCollectionResponseZeppaNotification
//

@implementation GTLZeppanotificationendpointCollectionResponseZeppaNotification
@dynamic items, nextPageToken;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:[GTLZeppanotificationendpointZeppaNotification class]
                                forKey:@"items"];
  return map;
}

@end