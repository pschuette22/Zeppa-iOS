//
//  ZPAEventInfoBaseClass.m
//  Zeppa
//
//  Created by Dheeraj on 28/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAEventInfoBase.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPADateHelper.h"

@implementation ZPAEventInfoBase

- (id) initWithZeppaEvent:(GTLZeppaclientapiZeppaEvent*) event {

    if(self = [super init]) {
        self.zeppaEvent = event;
        self.comments = [[NSMutableArray alloc] init];
        self.relationships = [[NSMutableArray alloc] init];
        self.tags = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/**
 *
 * If this event ended in the past, it is old and should be removed 
 */
- (BOOL) isOldEvent {
    return [ZPADateHelper currentTimeMillis] > self.zeppaEvent.end.longLongValue;
}


@end
