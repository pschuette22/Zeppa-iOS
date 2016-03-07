
//
//  ZPAZeppaEventSingleton.m
//  Zeppa
//
//  Created by Dheeraj on 21/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAZeppaEventSingleton.h"




static ZPAZeppaEventSingleton *zeppaEventSingleton = nil;

@implementation ZPAZeppaEventSingleton{
    BOOL _didFetchInitialEvents;
    BOOL _isFetchingEvents;
    BOOL _isMoreEvents;
    NSString *_cursor;
    long long _lastQueryTimestamp;
}

// override the intitialize method
- (id) init {
    
    if(self = [super init]) {
        self.zeppaEvents = [[NSMutableArray alloc]init];
        _didFetchInitialEvents = NO;
        _isFetchingEvents = NO;
        _cursor = nil;
        
    }
    
    return self;
}

/**
 * Get the shared instance of the ZeppaEventSingleton
 *  All Zeppa Event data is held here
 *
 */
+(ZPAZeppaEventSingleton *)sharedObject{
    
    if (zeppaEventSingleton == nil) {
        zeppaEventSingleton = [[ZPAZeppaEventSingleton alloc]init];
    }
    return zeppaEventSingleton;
}

+(void)resetObject{
    zeppaEventSingleton = nil;
}

/**
 *  When the singleton is deallocated, remove the notification listener
 */
-(void) dealloc {
    
}

-(void)clear{
    _zeppaEvents = nil;
}

-(void)addZeppaEvent:(ZPAEventInfoBase *)event{
    
    for (ZPAEventInfoBase *eventInfo in _zeppaEvents) {
    
        if ([eventInfo.zeppaEvent.identifier isEqualToNumber: event.zeppaEvent.identifier]){
            return;
        }
    }
    [_zeppaEvents addObject:event];
}

-(BOOL)removeMediator:(ZPAEventInfoBase *)event{
    
    if ([_zeppaEvents containsObject:event]) {
        [_zeppaEvents removeObject:event];
        [self notificationChangeForEvents];
        
        return YES;
    }
    return NO;
}

-(void)removeMediatorsForUser:(long long)userId{
    
    NSMutableArray *removeArr = [NSMutableArray array];
    
    for (ZPAEventInfoBase *eventInfo in _zeppaEvents) {
        
        if ([eventInfo.zeppaEvent.hostId longLongValue] == userId){
            
            
            [removeArr addObject:eventInfo];
            // TODO: remove notifications send regarding this event
           // NotificationSingleton.getInstance().removeNotificationsForEvent(mediator.getEventId().longValue());
            
        }
    }
    if(removeArr.count > 0){
        [_zeppaEvents removeObjectsInArray:removeArr];
        [self notificationChangeForEvents];

    }
    
}

-(void)clearOldEvents{
    
    if (_zeppaEvents.count>0) {
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
       
        for (ZPAEventInfoBase *eventInfo in arr) {
            
            // If the end time is less than the current time (in millis since epoch) remove it
            if ([eventInfo isOldEvent]) {
                [_zeppaEvents addObject:eventInfo];
            }
           
        }
        if (arr.count>0) {
            [_zeppaEvents removeObjectsInArray:arr];
            [self notificationChangeForEvents];

        }
    }
    
    
}
-(void)removeEventById:(long long)eventId{
    
    if (_zeppaEvents.count>0) {
        
        ZPAEventInfoBase *removeEvent = nil;
        
        for (ZPAEventInfoBase *eventInfo in _zeppaEvents) {
            
            if ([eventInfo.zeppaEvent.identifier longLongValue] == eventId) {
                
                removeEvent = eventInfo;
                break;
            }
        }
        if (removeEvent) {
            [_zeppaEvents removeObject:removeEvent];
            [self notificationChangeForEvents];
        }
    }
    
}


-(ZPAEventInfoBase *)getEventById:(long long)eventId{
    
    
    if (eventId) {
     
        for (ZPAEventInfoBase *eventInfo in _zeppaEvents) {
            if (eventInfo.zeppaEvent.identifier.longLongValue == eventId) {
                return eventInfo;
            }
            
        }
    }
    return nil;
}
-(NSArray *)getEventMediatorsForFriend:(long long)userId{
    
//    [self clearOldEvents];
    
    NSMutableArray *friendEvent = [[NSMutableArray alloc] init];
    
    for (ZPAEventInfoBase *eventInfo in _zeppaEvents) {
        
        if (eventInfo.zeppaEvent.hostId.longLongValue == userId) {
            [friendEvent addObject:eventInfo];
        }
    }
//    [ZPAStaticHelper sortArrayAlphabatically:friendEvent withKey:@"zeppaEvent.start"];
    ///Sorting is required
    
    return friendEvent;
}

-(NSArray *)getHostedEventMediators{
    
//    [self clearOldEvents];
    
    NSMutableArray *hostedEventMediators = [[NSMutableArray alloc] init];
    
    for (ZPAEventInfoBase *eventInfo in _zeppaEvents) {
        
        if ([eventInfo isMyEvent]) {
            [hostedEventMediators addObject:eventInfo];
           
        }
    }
    
    [ZPAStaticHelper sortArrayAlphabatically:hostedEventMediators withKey:@"zeppaEvent.start"];
    ///Sorting is required
    
    return hostedEventMediators;
    
}
-(NSArray *)getInterestingEventMediators{
    
//    [self clearOldEvents];
    
    NSMutableArray *interestingEventMediators = [[NSMutableArray alloc] init];
    
    for (ZPAEventInfoBase *eventInfo in _zeppaEvents) {
        
        if ([eventInfo isInterestingEvent]) {
            [interestingEventMediators addObject:eventInfo];
        }
        
    }
//    [ZPAStaticHelper sortArrayAlphabatically:interestingEventMediators withKey:@"event.start"];
    ///Sorting is required
    
    return interestingEventMediators;
    
    
}

-(NSNumber *)getUserId{
    
    return [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
}

//-(void)setConflictIndicator:(UIImageView *)imageView withZeppaEvent:(ZPAMyZeppaEvent *)zeppaEvent{
//  
//    NSLog(@"%d",[zeppaEvent.relationship.isAttending boolValue]);
//    if ([zeppaEvent.relationship.isAttending boolValue] == YES) {
//        conflictSt= ConflictStatusAttending;
//        [self setConflictImage:imageView];
//        return;
//    }else if (conflictSt != ConflictStatusUnknown){
//        [self setConflictImage:imageView];
//    }else{
//        imageView.hidden=YES;
//    }
//    [self determineAndSetConflictStatus:imageView withZeppaEvent:zeppaEvent];
//}
//
//-(void)setConflictImage:(UIImageView *)imageView{
//    
//    switch (conflictSt) {
//        case ConflictStatusAttending:
//            imageView.image = [UIImage imageNamed:@"small_circle_blue.png"];
//            break;
//        case ConflictStatusCompleteConflict:
//            imageView.image = [UIImage imageNamed:@"small_circle_red.png"];
//            break;
//        case ConflictStatusNoConflict:
//            imageView.image = [UIImage imageNamed:@"small_circle_green.png"];
//            break;
//        case ConflictStatusPartialConflict:
//            imageView.image = [UIImage imageNamed:@"small_circle_yellow.png"];
//            break;
//            
//            
//        default:
//            imageView.image = [UIImage imageNamed:@"view.Gone"];
//            break;
//    }
//    imageView.hidden=NO;
//}
//
//-(void)determineAndSetConflictStatus:(UIImageView *)imageView withZeppaEvent:(ZPAMyZeppaEvent *)zeppaEvent{
//
//    
//    conflictSt = ConflictStatusNoConflict;
//    [self setConflictImage:imageView];
//    
//    long long eventStart = [zeppaEvent.event.start longLongValue];
//    
//    long long fiveMinBuffer = 5 * 60 * 1000;
//    
////    for (int i = 0 ; i<[ZPAAppData sharedAppData].arrSyncedCalendarsEvents.count; i++) {
////        
////        ZPAEvent * allEvent = [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents objectAtIndex:i];
////        
////        
////        long long start = (long long)([allEvent.startDateTime timeIntervalSince1970] * 1000.0) - fiveMinBuffer;
////        
////        long long end = (long long)([allEvent.endDateTime timeIntervalSince1970] * 1000.0) + fiveMinBuffer;
////
//////        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start/1000];
//////        
//////        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end/1000];
//////        
//////        NSDate *eventStartDate = [NSDate dateWithTimeIntervalSince1970:[zeppaEvent.event.start longLongValue]/1000];
//////        
//////        NSDate *eventEndDate = [NSDate dateWithTimeIntervalSince1970:[zeppaEvent.event.end longLongValue]/1000];
////        
//////        if ([self date:eventStartDate isBetweenDate:startDate andDate:endDate] && [self date:eventEndDate isBetweenDate:startDate andDate:endDate]) {
//////            
//////            conflictSt = ConflictStatusCompleteConflict;
//////            [self setConflictImage:imageView];
//////            break;
//////            
//////        }else if (![self date:eventStartDate isBetweenDate:startDate andDate:endDate] && ![self date:startDate isBetweenDate:eventEndDate andDate:endDate] ){
//////            
//////            conflictSt = ConflictStatusPartialConflict;
//////            [self setConflictImage:imageView];
//////            break;
//////
//////        }
////        
////        
////        
////        if (eventStart <= start && [zeppaEvent.event.end longLongValue] == end) {
////            
////            conflictSt = ConflictStatusCompleteConflict;
////            [self setConflictImage:imageView];
////            break;
////        }else if (start < [zeppaEvent.event.end longLongValue] && [zeppaEvent.event.end longLongValue] < end){
////            
////            conflictSt = ConflictStatusPartialConflict;
////            [self setConflictImage:imageView];
////            break;
////            
////        }
//// //           else{
//////            conflictSt = ConflictStatusPartialConflict;
//////            [self setConflictImage:imageView];
//////            temp = end;
//////        }
////        
////    }
// 
//    
//    
//}

//-(NSArray *)getAttendingUserIds:(ZPAMyZeppaEvent *)zeppaEvent{
//    
//    //_relationships = [NSMutableArray array];
//    NSMutableArray *attendingUserIds = [NSMutableArray array];
//    
//    for (GTLZeppaclientapiZeppaEventToUserRelationship * relation in _relationships) {
//        if ([relation.isAttending boolValue] && [relation.eventId isEqualToNumber:zeppaEvent.event.identifier]) {
//            [attendingUserIds addObject:relation.userId];
//        }
//    }
//    
//    
//    return [[NSOrderedSet orderedSetWithArray:attendingUserIds] array];
//}

// ***********************************
# pragma mark Zeppa Event Queries
// ***********************************

/**
 * Start task to fetch the initial events to display to this user
 *  @returns YES if the task was started
 */
-(BOOL) fetchInitialEvents:(OnEventQueryCompletion) completion {
    
    if(_didFetchInitialEvents) {
        // initial events were already fetched, no task started
        return NO;
    }
    
    if(_isFetchingEvents) {
        // Currently fetching events, no task started
        return NO;
    }
    
    // Else, we start to fetch initial events
    _isFetchingEvents = YES;
    // Get a weak instance of the singleton
    ZPAInitialEventsQuery *initialEventQuery = [[ZPAInitialEventsQuery alloc] init];
    
    [initialEventQuery executeWithAuthToken:[[ZPAAuthenticatonHandler sharedAuth] authToken] completion:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        
        if(error) {
            // TODO: Handle an error on initial fetch. Maybe try to recover
        } else {
        
            _didFetchInitialEvents = YES;
            _isFetchingEvents = NO;
            _isMoreEvents = ![initialEventQuery getIsLastQuery];
            _cursor = [initialEventQuery getQueryCursor];
        
            
            // Should order the events
            
            
            [self notificationChangeForEvents];
        }
        
        // Call the completion, if it should be handled
        if(completion) {
            completion(ticket, response, error);
        }
        
    }];
    
    _lastQueryTimestamp = [ZPADateHelper currentTimeMillis];

    
    return YES;
}

-(BOOL) fetchNewEvents:(OnEventQueryCompletion) completion {
    if(!_didFetchInitialEvents) {
        // didn't fetch initial events yet, no task started
        return NO;
    }
    
    if(_isFetchingEvents) {
        // Currently fetching events, no task started
        return NO;
    }
    // Set is fetching so another task isn't processed
    _isFetchingEvents = YES;
    
    // preserve previous last call time stamp in case of error
    long long previousLastCallTimeStamp = _lastQueryTimestamp;
    
    ZPANewEventsQuery *newEventsQuery = [[ZPANewEventsQuery alloc] init];
    
    [newEventsQuery executeWithAuthToken:[[ZPAAuthenticatonHandler sharedAuth] authToken] lastCallTimestamp:_lastQueryTimestamp completion:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        
        _isFetchingEvents = NO; // no longer running query
        
        if(error){
            // handle the error
            // Reset the last call time stamp
            _lastQueryTimestamp = previousLastCallTimeStamp;
        } else {
            // Because this was a refresh, we can reorder the events
            // Post a notification that events changed
            [self notificationChangeForEvents];
        }
        
        // If there is a completion block, call it
        if(completion) {
            completion(ticket, response, error);
        }
        
    }];
     
     _lastQueryTimestamp = [ZPADateHelper currentTimeMillis];

    return YES;
}

-(BOOL) fetchMoreEvents:(OnEventQueryCompletion) completion {
    if(!_didFetchInitialEvents) {
        // didn't fetch initial events yet, no task started
        return NO;
    }
    
    if(_isFetchingEvents) {
        // Currently fetching events, no task started
        return NO;
    }
    
    if(!_isMoreEvents) {
        // There aren't any more events, why bother?
        return NO;
    }
    // Set is fetching so another task isn't processed
    _isFetchingEvents = YES;
    
    
    ZPAMoreEventsQuery *moreEventsQuery = [[ZPAMoreEventsQuery alloc] init];
    
    [moreEventsQuery executeWithAuthToken:[[ZPAAuthenticatonHandler sharedAuth] authToken] withCursor:_cursor completion:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        
        _isFetchingEvents = NO; // no longer running query
        
        if(error){
            // handle the error
            
        } else {
            // Because this was a refresh, we can reorder the events
            // Post a notification that events changed
            _isMoreEvents = [moreEventsQuery getIsMoreEvents];
            if(_isMoreEvents){
                _cursor = response.nextPageToken;
            }
            [self notificationChangeForEvents];
        }
        
        // If there is a completion block, call it
        if(completion) {
            completion(ticket, response, error);
        }
        
    }];
    
    return YES;
}



-(void) didReceiveNotification:(NSNotification*)notification {
    
    if([notification.name isEqualToString:kNotifDidUpdateLocation]) {
        // The device location updated
        // set the cursor to nil so events that may have previously been out of range may be fetched
        _cursor = nil;
        _isMoreEvents = YES; // reset the more events check
        // basic query to fetch events that may have come in range without worrying about completion
        [self fetchMoreEvents:nil];
    }
    
}

-(void)notificationChangeForEvents{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kZeppaEventsUpdateNotificationKey object:nil];
}

-(void)sortHeldEvents {
    [ZPAStaticHelper sortArrayAlphabatically:self.zeppaEvents withKey:@"event.start"];
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    return (([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));

}

@end
