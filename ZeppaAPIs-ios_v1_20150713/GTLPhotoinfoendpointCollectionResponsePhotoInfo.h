/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLPhotoinfoendpointCollectionResponsePhotoInfo.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   photoinfoendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLPhotoinfoendpointCollectionResponsePhotoInfo (0 custom class methods, 2 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLPhotoinfoendpointPhotoInfo;

// ----------------------------------------------------------------------------
//
//   GTLPhotoinfoendpointCollectionResponsePhotoInfo
//

// This class supports NSFastEnumeration over its "items" property. It also
// supports -itemAtIndex: to retrieve individual objects from "items".

@interface GTLPhotoinfoendpointCollectionResponsePhotoInfo : GTLCollectionObject
@property (retain) NSArray *items;  // of GTLPhotoinfoendpointPhotoInfo
@property (copy) NSString *nextPageToken;
@end