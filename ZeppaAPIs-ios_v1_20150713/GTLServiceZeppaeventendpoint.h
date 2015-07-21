/* This file was generated by the ServiceGenerator.
 * The ServiceGenerator is Copyright (c) 2015 Google Inc.
 */

//
//  GTLServiceZeppaeventendpoint.h
//

// ----------------------------------------------------------------------------
// NOTE: This file is generated from Google APIs Discovery Service.
// Service:
//   zeppaeventendpoint/v1
// Description:
//   This is an API
// Classes:
//   GTLServiceZeppaeventendpoint (0 custom class methods, 0 custom properties)

#if GTL_BUILT_AS_FRAMEWORK
  #import "GTL/GTLService.h"
#else
  #import "GTLService.h"
#endif

@interface GTLServiceZeppaeventendpoint : GTLService

// No new methods

// Clients should create a standard query with any of the class methods in
// GTLQueryZeppaeventendpoint.h. The query can the be sent with GTLService's
// execute methods,
//
//   - (GTLServiceTicket *)executeQuery:(GTLQuery *)query
//                    completionHandler:(void (^)(GTLServiceTicket *ticket,
//                                                id object, NSError *error))handler;
// or
//   - (GTLServiceTicket *)executeQuery:(GTLQuery *)query
//                             delegate:(id)delegate
//                    didFinishSelector:(SEL)finishedSelector;
//
// where finishedSelector has a signature of:
//
//   - (void)serviceTicket:(GTLServiceTicket *)ticket
//      finishedWithObject:(id)object
//                   error:(NSError *)error;
//
// The object passed to the completion handler or delegate method
// is a subclass of GTLObject, determined by the query method executed.

@end
