/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2016 Google Inc.
 */

//
//  GTLZeppaclientapiCollectionResponseZeppaEvent.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaclientapi/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppaclientapiCollectionResponseZeppaEvent (0 custom class methods, 2 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppaclientapiZeppaEvent;

// ----------------------------------------------------------------------------
//
//   GTLZeppaclientapiCollectionResponseZeppaEvent
//

// This class supports NSFastEnumeration over its "items" property. It also
// supports -itemAtIndex: to retrieve individual objects from "items".

@interface GTLZeppaclientapiCollectionResponseZeppaEvent : GTLCollectionObject
@property (nonatomic, retain) NSArray *items;  // of GTLZeppaclientapiZeppaEvent
@property (nonatomic, copy) NSString *nextPageToken;
@end
