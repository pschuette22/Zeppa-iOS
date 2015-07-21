
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
    ConflictStatus conflictSt;
}

+(ZPAZeppaEventSingleton *)sharedObject{
    
    if (zeppaEventSingleton == nil) {
        zeppaEventSingleton = [[ZPAZeppaEventSingleton alloc]init];
        zeppaEventSingleton.zeppaEvents = [[NSMutableArray alloc]init];
        zeppaEventSingleton.relationships = [[NSMutableArray alloc]init];
        
    }
    return zeppaEventSingleton;
}

+(void)resetObject{
    
    zeppaEventSingleton = nil;
}
-(void)clear{
    
    _zeppaEvents = nil;
    
}

-(void)addZeppaEvents:(ZPAMyZeppaEvent *)event{
    
    for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
    
        if ([myZeppaEvent.event.identifier longLongValue] == [event.event.identifier longLongValue]){
            return;
            }
    }
    [_zeppaEvents addObject:event];
    
}
-(BOOL)removeMediator:(ZPAMyZeppaEvent *)event{
    
    if ([_zeppaEvents containsObject:event]) {
        [_zeppaEvents removeObject:event];
        return YES;
    }
    return NO;
}
-(void)removeMediatorsForUser:(long long)userId{
    
    NSMutableArray *removeArr = [NSMutableArray array];
    
    for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
        
        if (([myZeppaEvent.event.hostId longLongValue] == userId) && !(myZeppaEvent.getAttendingUserIds)){
            
            
            [removeArr addObject:myZeppaEvent];
           // NotificationSingleton.getInstance().removeNotificationsForEvent(mediator.getEventId().longValue());
            
        }
    }
    [_zeppaEvents removeObjectsInArray:removeArr];
}
-(void)clearOldEvents{
    
    if (_zeppaEvents.count>0) {
        
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_zeppaEvents];
        long long currentTime = (long long)[ZPADateHelper currentTimeMillis];
        
       
        for (ZPAMyZeppaEvent *myZeppaEvent in arr) {
            
            if ([myZeppaEvent.event.end isEqualToNumber:[NSNumber numberWithLongLong:currentTime]] ) {
                [_zeppaEvents removeObject:myZeppaEvent];
            }
           /* NotificationSingleton.getInstance()
            .removeNotificationsForEvent(
                                         mediator.getEventId().longValue());
            */
        }
//        if (arr.count>0) {
//            [_zeppaEvents removeObjectsInArray:arr];
//        }
    }
    
    
}
-(void)removeEventById:(long long)eventId{
    
    if (_zeppaEvents.count>0) {
        
        ZPAMyZeppaEvent *removeEvent = nil;
        
        for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
            
            if ([myZeppaEvent.event.identifier longLongValue] == eventId) {
                
                removeEvent = myZeppaEvent;
                break;
            }
        }
        if (removeEvent) {
            [_zeppaEvents removeObject:removeEvent];
        }
    }
    
}
-(BOOL)relationshipAlreadyHeld:(GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *)relation{
    
    
    for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
        
        if( [myZeppaEvent.relationship.identifier longLongValue] == [relation.identifier longLongValue]){
        
            return YES;
        }
    }
    return NO;
    
}
-(ZPAMyZeppaEvent *)getEventById:(long long)eventId{
    
    
    if (eventId) {
     
        for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
            if ([myZeppaEvent doesMatchEventId:eventId]) {
                return myZeppaEvent;
            }
            
        }
    }
    return nil;
}
-(NSArray *)getEventMediatorsForFriend:(long long)userId{
    
    [self clearOldEvents];
    NSMutableArray *friendEvent = [NSMutableArray array];
    
    for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
        
        if ([myZeppaEvent hostIdDoesMatch:userId]) {
            [friendEvent addObject:myZeppaEvent];
        }
    }
    [ZPAStaticHelper sortArrayAlphabatically:friendEvent withKey:@"event.start"];
    ///Sorting is required
    
    return friendEvent;
}

-(NSArray *)getHostedEventMediators{
    
    [self clearOldEvents];
    
    NSMutableArray *hostedEventMediators = [NSMutableArray array];
    
    for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
        
        if ([myZeppaEvent hostIdDoesMatch:[[self getUserId] longLongValue]]) {
            [hostedEventMediators addObject:myZeppaEvent];
           
        }
    }
    
    [ZPAStaticHelper sortArrayAlphabatically:hostedEventMediators withKey:@"event.start"];
    ///Sorting is required
    
    return hostedEventMediators;
    
}
-(NSArray *)getInterestingEventMediators{
    
    [self clearOldEvents];
    
    NSMutableArray *interestingEventMediators = [NSMutableArray array];
    
    for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
        
        if (myZeppaEvent.isAgenda == YES || [myZeppaEvent.relationship.isAttending boolValue] == YES || [myZeppaEvent hostIdDoesMatch:[[self getUserId] longLongValue]] ) {
            [interestingEventMediators addObject:myZeppaEvent];
        }
        
    }
    [ZPAStaticHelper sortArrayAlphabatically:interestingEventMediators withKey:@"event.start"];
    ///Sorting is required
    
    return interestingEventMediators;
    
    
}


-(ZPAMyZeppaEvent *)getMatchingEventMediator:(GTLZeppaeventendpointZeppaEvent *)event{
    
    NSString *eTitle = event.title;
    long long eStart = [event.start longLongValue];
    long long eEnd   = [event.end longLongValue];
    for (ZPAMyZeppaEvent *myZeppaEvent in _zeppaEvents) {
        
        NSString *mTitle  =  myZeppaEvent.event.title;
        long long mStart  =  [myZeppaEvent.event.start longLongValue];
        long long mEnd    =  [myZeppaEvent.event.end longLongValue];
        
        if ([eTitle isEqualToString:mTitle] && (eStart == mStart) && (eEnd == mEnd)) {
            return myZeppaEvent;
        }
        
    }
    return nil;
    
}
-(NSNumber *)getUserId{
    
    return [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
}
-(void)setConflictIndicator:(UIImageView *)imageView withZeppaEvent:(ZPAMyZeppaEvent *)zeppaEvent{
  
    NSLog(@"%d",[zeppaEvent.relationship.isAttending boolValue]);
    if ([zeppaEvent.relationship.isAttending boolValue] == YES) {
        conflictSt= ConflictStatusAttending;
        [self setConflictImage:imageView];
        return;
    }else if (conflictSt != ConflictStatusUnknown){
        [self setConflictImage:imageView];
    }else{
        imageView.hidden=YES;
    }
    [self determineAndSetConflictStatus:imageView withZeppaEvent:zeppaEvent];
}

-(void)setConflictImage:(UIImageView *)imageView{
    
    switch (conflictSt) {
        case ConflictStatusAttending:
            imageView.image = [UIImage imageNamed:@"small_circle_blue.png"];
            break;
        case ConflictStatusCompleteConflict:
            imageView.image = [UIImage imageNamed:@"small_circle_red.png"];
            break;
        case ConflictStatusNoConflict:
            imageView.image = [UIImage imageNamed:@"small_circle_green.png"];
            break;
        case ConflictStatusPartialConflict:
            imageView.image = [UIImage imageNamed:@"small_circle_yellow.png"];
            break;
            
            
        default:
            imageView.image = [UIImage imageNamed:@"view.Gone"];
            break;
    }
    imageView.hidden=NO;
}

-(void)determineAndSetConflictStatus:(UIImageView *)imageView withZeppaEvent:(ZPAMyZeppaEvent *)zeppaEvent{

    
    conflictSt = ConflictStatusNoConflict;
    [self setConflictImage:imageView];
    
    long long eventStart = [zeppaEvent.event.start longLongValue];
    
    long long fiveMinBuffer = 5 * 60 * 1000;
    
    for (int i = 0 ; i<[ZPAAppData sharedAppData].arrSyncedCalendarsEvents.count; i++) {
        
        ZPAEvent * allEvent = [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents objectAtIndex:i];
        
        
        long long start = (long long)([allEvent.startDateTime timeIntervalSince1970] * 1000.0) - fiveMinBuffer;
        
        long long end = (long long)([allEvent.endDateTime timeIntervalSince1970] * 1000.0) + fiveMinBuffer;

//        NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:start/1000];
//        
//        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:end/1000];
//        
//        NSDate *eventStartDate = [NSDate dateWithTimeIntervalSince1970:[zeppaEvent.event.start longLongValue]/1000];
//        
//        NSDate *eventEndDate = [NSDate dateWithTimeIntervalSince1970:[zeppaEvent.event.end longLongValue]/1000];
        
//        if ([self date:eventStartDate isBetweenDate:startDate andDate:endDate] && [self date:eventEndDate isBetweenDate:startDate andDate:endDate]) {
//            
//            conflictSt = ConflictStatusCompleteConflict;
//            [self setConflictImage:imageView];
//            break;
//            
//        }else if (![self date:eventStartDate isBetweenDate:startDate andDate:endDate] && ![self date:startDate isBetweenDate:eventEndDate andDate:endDate] ){
//            
//            conflictSt = ConflictStatusPartialConflict;
//            [self setConflictImage:imageView];
//            break;
//
//        }
        
        
        
        
        
        
        
        if (eventStart <= start && [zeppaEvent.event.end longLongValue] == end) {
            
            conflictSt = ConflictStatusCompleteConflict;
            [self setConflictImage:imageView];
            break;
        }else if (start < [zeppaEvent.event.end longLongValue] && [zeppaEvent.event.end longLongValue] < end){
            
            conflictSt = ConflictStatusPartialConflict;
            [self setConflictImage:imageView];
            break;
            
        }
 //           else{
//            conflictSt = ConflictStatusPartialConflict;
//            [self setConflictImage:imageView];
//            temp = end;
//        }
        
    }
 
    
    
}

-(NSArray *)getAttendingUserIds:(ZPAMyZeppaEvent *)zeppaEvent{
    
    //_relationships = [NSMutableArray array];
    NSMutableArray *attendingUserIds = [NSMutableArray array];
    
    for (GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship * relation in _relationships) {
        if ([relation.isAttending boolValue] && [relation.eventId isEqualToNumber:zeppaEvent.event.identifier]) {
            [attendingUserIds addObject:relation.userId];
        }
    }
    
    
    return [[NSOrderedSet orderedSetWithArray:attendingUserIds] array];
}


-(void)notificationChangeForEvents{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kZeppaEventsUpdateNotificationKey object:nil];
}

- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    return (([date compare:beginDate] != NSOrderedAscending) && ([date compare:endDate] != NSOrderedDescending));

}

@end
