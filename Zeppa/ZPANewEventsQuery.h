//
//  ZPANewEventsQuery.h
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPABaseEventsQuery.h"

@interface ZPANewEventsQuery : ZPABaseEventsQuery

- (void) executeWithAuthToken:(NSString *)authToken lastCallTimestamp:(long long) timestamp completion:(OnEventQueryCompletion) completion;

@end
