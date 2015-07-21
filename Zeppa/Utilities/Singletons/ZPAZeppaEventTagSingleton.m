//
//  ZPAZeppaEvent.m
//  Zeppa
//
//  Created by Dheeraj on 13/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAZeppaEventTagSingleton.h"
#import "ZPAAddEventVC.h"

static ZPAZeppaEventTagSingleton *zeppaEvent = nil;

@implementation ZPAZeppaEventTagSingleton
+(ZPAZeppaEventTagSingleton *)sharedObject{
    
    if (zeppaEvent == nil) {
        zeppaEvent = [[ZPAZeppaEventTagSingleton alloc]init];
        zeppaEvent.abstactEventTagArray = [[NSMutableArray alloc]init];
        zeppaEvent.tagId = [NSMutableArray array];
    }
    return zeppaEvent;
}
+(void)resetObject{

    zeppaEvent = nil;
}
-(void)clear{
    
    _abstactEventTagArray = nil;
    
}
-(NSNumber *)getCurrentUserId{
    
    return [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
}
-(void)addEventTagsFromArray:(NSArray *)array{
    
    _abstactEventTagArray = [array mutableCopy];
}
-(GTLEventtagendpointEventTag *)newTagInstance{
    
    GTLEventtagendpointEventTag *tag = [[GTLEventtagendpointEventTag alloc]init];
    tag.ownerId = [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
    return tag;
}
-(NSArray *)getMyTags{
    
    return [self getZeppaTagForUser:[[self getCurrentUserId] longLongValue]];

}
-(NSArray *)getZeppaTagForUser:(long long)userId{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (GTLEventtagendpointEventTag *tag in _abstactEventTagArray) {
        if ([tag.ownerId longLongValue]== userId) {
            [arr addObject:tag];
        }
    }
    return [NSArray arrayWithArray:arr];
}

-(void)updateEventTagsForUserId:(long long)userId andZeppaEventTagsArray:(NSMutableArray *)eventTagsArray{
    
    NSArray *arr = [self getZeppaTagForUser:userId];
    
    if (arr.count>0) {
        [_abstactEventTagArray removeObjectsInArray:arr];
    }
    if (eventTagsArray.count>0) {
        [_abstactEventTagArray addObjectsFromArray:eventTagsArray];
    }
}
-(GTLEventtagendpointEventTag *)getZeppaTagWithId:(long long)tagId{
    
    for (GTLEventtagendpointEventTag *tag in _abstactEventTagArray) {
        if ([tag.identifier isEqualToNumber:[NSNumber numberWithLongLong:tagId]]) {
            return tag;
        }
    }
    return nil;
}
-(NSArray *)getTagsFromTagIdsArray:(NSArray *)ids{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<ids.count; i++) {
        
        GTLEventtagendpointEventTag *tag = [self getZeppaTagWithId:[[ids objectAtIndex:i] longLongValue]];
        if (tag) {
            [arr addObject:tag];
        }
    }
    return arr;
}

-(void)removeZeppaEventTag:(GTLEventtagendpointEventTag *)tag{
    
    if ([_abstactEventTagArray containsObject:tag]) {
        [_abstactEventTagArray removeObject:tag];
    }
}
-(void)removeZeppaEventTagsUsingUserId:(long long)userId{
    NSMutableArray *arr = [NSMutableArray array];
    for (GTLEventtagendpointEventTag *tag in _abstactEventTagArray) {
        if ([tag.ownerId longLongValue] == userId) {
            [arr addObject:tag];
        }
    }
    if (arr.count>0) {
        [_abstactEventTagArray removeObjectsInArray:arr];
        
    }
    
}
-(void)deleteEventTagWithEventTagId:(long long)identifier{
    [self executeRemoveRequestWithIdentifier:identifier];
}
///*****************************************
#pragma mark - ZeppaEventTag Api
///*****************************************
-(void)executeEventTagListQueryWithCursor:(NSString *)cursorValue{
    
    __weak typeof(self) weakSelf = self;
    NSString *filter = [NSString stringWithFormat:@"userId == %lld",[[self getCurrentUserId] longLongValue]];
    NSNumber *limit = [NSNumber numberWithInt:50];
    
    GTLQueryEventtagendpoint *tagQuery = [GTLQueryEventtagendpoint queryForListEventTag];
    [tagQuery setFilter: filter];
    [tagQuery setCursor: cursorValue];
    [tagQuery setLimit:[limit integerValue]];
    
    [self.eventTagService executeQuery:tagQuery completionHandler:^(GTLServiceTicket *ticket, GTLEventtagendpointCollectionResponseEventTag *response, NSError *error) {
            if(error){
                                             
            }else if(response && response.items &&response.items.count > 0){
                for (GTLEventtagendpointEventTag *tag in response.items) {
                    if (tag) {
                        [weakSelf.abstactEventTagArray addObject:tag];
                    }
                }
                NSString *currentCursor = [response nextPageToken];
                if (currentCursor) {
                    [weakSelf executeEventTagListQueryWithCursor:currentCursor];
                }
                                             
            }else{
               
                NSLog(@"MyEvent Tag count%d andValue %@",(unsigned)_abstactEventTagArray.count,_abstactEventTagArray);
                // Operation didn’t return anything
            }
        }];
}
-(void)executeInsetEventTagWithEventTag:(GTLEventtagendpointEventTag *)eventTag WithCompletion:(getTagCompletionHandler)completion{
    
    
    __weak typeof(self) weakSelf = self;
    GTLQueryEventtagendpoint *insertEventTagTask = [GTLQueryEventtagendpoint queryForInsertEventTagWithObject:eventTag];
    
    [self.eventTagService executeQuery:insertEventTagTask completionHandler:^(GTLServiceTicket *ticket, GTLEventtagendpointEventTag *result, NSError *error) {
        //
        
        if(error) {
            // error
        } else if(result.identifier){
            [weakSelf.abstactEventTagArray addObject:result];
            [weakSelf.tagId addObject: result.identifier] ;
            completion (result, nil);
        } else {
            // returned null object
        }
        
    }];
}
-(void)executeRemoveRequestWithIdentifier:(long long)identifier{
    
    
    __weak typeof(self) weakSelf = self;
    GTLQueryEventtagendpoint *removeTagTask = [GTLQueryEventtagendpoint queryForRemoveEventTagWithTagId:identifier];
    
    [self.eventTagService executeQuery:removeTagTask completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if (error){
            GTLEventtagendpointEventTag *eventTag = [self getZeppaTagWithId:identifier];
            
            if (eventTag) {
                [weakSelf.abstactEventTagArray removeObject:eventTag];
            }
            // error
        } else {
            // removed successfully
        }
    }];
    
}
-(GTLServiceEventtagendpoint *)eventTagService{
    
    static GTLServiceEventtagendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceEventtagendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer: [ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
    
}
-(void)notificationChange{
  [[NSNotificationCenter defaultCenter]postNotificationName:kZeppaTagUpdateNotificationKey object:nil];
}
@end
