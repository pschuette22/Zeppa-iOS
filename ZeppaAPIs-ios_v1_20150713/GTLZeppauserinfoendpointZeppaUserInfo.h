/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLZeppauserinfoendpointZeppaUserInfo.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppauserinfoendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLZeppauserinfoendpointZeppaUserInfo (0 custom class methods, 9 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLObject.h"
#else
  #import "GTLObject.h"
#endif

@class GTLZeppauserinfoendpointKey;

// ----------------------------------------------------------------------------
//
//   GTLZeppauserinfoendpointZeppaUserInfo
//

@interface GTLZeppauserinfoendpointZeppaUserInfo : GTLObject
@property (retain) NSNumber *created;  // longLongValue
@property (copy) NSString *familyName;
@property (copy) NSString *givenName;
@property (copy) NSString *googleAccountEmail;

// identifier property maps to 'id' in JSON (to avoid Objective C's 'id').
@property (retain) NSNumber *identifier;  // longLongValue

@property (copy) NSString *imageUrl;
@property (retain) GTLZeppauserinfoendpointKey *key;
@property (copy) NSString *primaryUnformattedNumber;
@property (retain) NSNumber *updated;  // longLongValue
@end
