/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLPhotoinfoendpointCollectionResponsePhotoInfo.m
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   photoinfoendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLPhotoinfoendpointCollectionResponsePhotoInfo (0 custom class methods, 2 custom properties)

#import "GTLPhotoinfoendpointCollectionResponsePhotoInfo.h"

#import "GTLPhotoinfoendpointPhotoInfo.h"

// ----------------------------------------------------------------------------
//
//   GTLPhotoinfoendpointCollectionResponsePhotoInfo
//

@implementation GTLPhotoinfoendpointCollectionResponsePhotoInfo
@dynamic items, nextPageToken;

+ (NSDictionary *)arrayPropertyToClassMap {
  NSDictionary *map =
    [NSDictionary dictionaryWithObject:[GTLPhotoinfoendpointPhotoInfo class]
                                forKey:@"items"];
  return map;
}

@end
