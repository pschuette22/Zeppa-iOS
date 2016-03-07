//
//  ZPAMyZeppaEvent.m
//  Zeppa
//
//  Created by Dheeraj on 21/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAMyZeppaEvent.h"
#import "ZPAApplication.h"


@implementation ZPAMyZeppaEvent

- (id) initWithZeppaEvent:(GTLZeppaclientapiZeppaEvent *)event {
    if(self = [super initWithZeppaEvent:event]){
        // Other initializations
    }
    return self;
}


-(ZPAMyZeppaUser*) getHostInfo {
    return [[ZPAApplication sharedObject] getCurrentUser];
}


/**
 * Always display your own events in the feed
 */
- (BOOL) isFeedEvent {
    return YES;
}

/**
 *  Your own events are always interesting
 */
- (BOOL) isInterestingEvent {
    return YES;
}
/**
 *  You must attend your own events
 */
- (BOOL) isAttending {
    return YES;
}

/**
 * For now, you always watch your own events... Might change that
 */
- (BOOL) isWatching {
    return YES;
}

/**
 *  Convenience method because polymorphism in ios is a neusance
 */
- (BOOL) isMyEvent {
    return YES;
}

/**
 * Cancel the event
 */
- (void) cancelEvent {
    
}


@end
