//
//  ZPAMyZeppaEvent.m
//  Zeppa
//
//  Created by Dheeraj on 21/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAMyZeppaEvent.h"


@implementation ZPAMyZeppaEvent

-(NSArray *)getTagIds{
    
    if (_event.tagIds.count>0) {
        return _event.tagIds ;
    }
     return nil;
}
-(BOOL)isPrivateEvent{
    
    return [self.event.privacy isEqualToString:@"PRIVATE"];
}
-(BOOL)isOldEvent{
    
    long long currentTime = [ZPADateHelper currentTimeMillis];
    return ([self.event.end longLongValue] <= currentTime);
}
-(BOOL)isGuestsMayInvite{
    
    return ([self.event.guestsMayInvite boolValue])?YES:NO;
}
-(BOOL)doesMatchEventId:(long long)eventId{
 
    return ([_event.key.identifier longLongValue] == eventId)?YES:NO;
}
-(BOOL)hostIdDoesMatch:(long long)hostId{
    
    return ([_event.hostId longLongValue] == hostId)?YES:NO;
}
-(NSArray *)getAttendingUserIds{
    
    //_relationships = [NSMutableArray array];
    NSMutableArray *attendingUserIds = [NSMutableArray array];
    for (GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship * relation in _relationships) {
        if ([relation.isAttending boolValue]) {
            [attendingUserIds addObject:relation.userId];
        }
    }
    return attendingUserIds;
}
@end
