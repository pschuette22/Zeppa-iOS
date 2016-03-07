//
//  ZPAMoreEventsQuery.h
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPABaseEventsQuery.h"

@interface ZPAMoreEventsQuery : ZPABaseEventsQuery

- (void) executeWithAuthToken:(NSString *)authToken withCursor:(NSString*) cursor completion:(OnEventQueryCompletion) completion;

- (BOOL) getIsMoreEvents;

@end
