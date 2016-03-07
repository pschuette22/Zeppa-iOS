//
//  ZPAInitialEventsQuery.h
//  Zeppa
//
//  Created by Peter Schuette on 3/2/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPABaseEventsQuery.h"

@interface ZPAInitialEventsQuery : ZPABaseEventsQuery

- (NSString*) getQueryCursor;
- (long long) getTimestamp;
- (BOOL) getIsLastQuery;

@end
