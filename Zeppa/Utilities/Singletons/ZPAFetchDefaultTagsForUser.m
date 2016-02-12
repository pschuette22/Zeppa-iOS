

//
//  ZPAFetchDefaultTagsForUser.m
//  Zeppa
//
//  Created by Dheeraj on 27/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAFetchDefaultTagsForUser.h"

#import "ZPAAuthenticatonHandler.h"
#import "ZPADefaultZeppaEventTagInfo.h"
#import "ZPAZeppaEventTagSingleton.h"
#import "ZPAMyZeppaEvent.h"


@implementation ZPAFetchDefaultTagsForUser{
    
    long long _userIdSelf;
    long long _userIdMingler;
    NSMutableArray * _followList;
    ZPAMyZeppaEvent * _event;
    NSMutableArray * _result;
    NSMutableArray * _tagIdsArray;
}

-(BOOL)isFollowing:(GTLZeppaclientapiEventTag *)tag{
    
    for (GTLZeppaclientapiEventTagFollow *tagFollow in _followList) {
        
        if ([tag.identifier isEqualToNumber: tagFollow.tagId]) {
            return YES;
        
        }
    }
    return NO;
}

-(void)executeZeppaApiWithUserId:(long long)userId  andMinglerId:(long long)minglerId{
    
    _followList = [NSMutableArray array];
    _result = [NSMutableArray array];
    _tagIdsArray = [NSMutableArray array];
    _userIdSelf = userId;
    _userIdMingler = minglerId;
    _event = [[ZPAMyZeppaEvent alloc]init];
    [self executeZeppaEventListUsingUserIdWithCursor:nil];
}



-(void)executeZeppaEventListUsingUserIdWithCursor:(NSString *)cursorValue{
    
    __weak typeof(self) weakSelf = self;
    
    GTLQueryZeppaclientapi *eventQuery = [GTLQueryZeppaclientapi queryForListEventTagFollowWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [eventQuery setFilter:[NSString stringWithFormat:@"tagOwnerId == %lld && followerId == %lld",_userIdMingler,_userIdSelf]];
    [eventQuery setCursor: cursorValue];
    [eventQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.evetTagFollowService executeQuery:eventQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseEventTagFollow *response, NSError *error) {
        //
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            [_followList addObjectsFromArray:response.items];
            
            NSString *currentCursor = response.nextPageToken;
            if (response.items.count >= 25 && currentCursor) {
                [weakSelf executeZeppaEventListUsingUserIdWithCursor:currentCursor];
            }else{
                [weakSelf executeEventTagListQueryWithCursor:nil];
            }
            
        } else {
            [weakSelf executeEventTagListQueryWithCursor:nil];
        }
        
    }];
    
}
-(void)executeEventTagListQueryWithCursor:(NSString *)cursorValue {
    
    __weak typeof(self) weakSelf = self;
    GTLQueryZeppaclientapi *tagQuery = [GTLQueryZeppaclientapi queryForListEventTagWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    [tagQuery setFilter:[NSString stringWithFormat: @"ownerId == %lld",_userIdMingler]];
    [tagQuery setCursor: cursorValue];
    [tagQuery setOrdering:@"created desc"];
    [tagQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.evetTagService executeQuery:tagQuery
                                     completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseEventTag *response, NSError *error) {
        if(error){
                                             
        }else if(response && response.items && response.items.count > 0){
                                            
            for (GTLZeppaclientapiEventTag *eventTag in response.items) {
                
//                GTLZeppaclientapiEventTagFollow *follow = nil;
//                for (GTLZeppaclientapiEventTagFollow *eventTagFollow in _followList) {
//                    if ([eventTag.identifier longLongValue] == [eventTagFollow.tagId longLongValue]) {
//                        follow = eventTagFollow;
//                       // break;
//                    }
//                    
//                }
//                if (follow) {
//                    [_followList removeObject:follow];
//                }
                ZPADefaultZeppaEventTagInfo *zeppaEventInfo = [[ZPADefaultZeppaEventTagInfo alloc]init];
                zeppaEventInfo.eventTag  = eventTag;
              //  zeppaEventInfo.eventTagFollow = follow;
                
                [_result addObject:eventTag];
                [_tagIdsArray addObject:eventTag.identifier];
            }
            NSString *currentCursor = response.nextPageToken;
            if (response.items.count >= 25 && currentCursor) {
                [weakSelf executeEventTagListQueryWithCursor:currentCursor];
            }else{
                [[ZPAZeppaEventTagSingleton sharedObject] updateEventTagsForUserId:_userIdMingler andZeppaEventTagsArray:_result];
                [weakSelf finishTagQuery];
            }

        }else{
            [[ZPAZeppaEventTagSingleton sharedObject] updateEventTagsForUserId:_userIdMingler andZeppaEventTagsArray:_result];
            [weakSelf finishTagQuery];
        }
                                         
    }];
    
}

- (void) insertZeppaTagFollow:(GTLZeppaclientapiEventTagFollow *)tagFollow{
    
    
    GTLZeppaclientapiEventTagFollow *follow = [[GTLZeppaclientapiEventTagFollow alloc] init];
    
    [follow setTagId:tagFollow.tagId];
    [follow setTagOwnerId:tagFollow.tagOwnerId];
    [follow setFollowerId:tagFollow.followerId];
    
    GTLQueryZeppaclientapi *insertFollowTask = [GTLQueryZeppaclientapi queryForInsertEventTagFollowWithObject:follow idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.evetTagFollowService executeQuery:insertFollowTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiEventTagFollow *response, NSError *error) {
        //
        
        if(error){
            // Handle Error
        } else if (response.identifier) {
            [_followList addObject:response];
        } else {
            // returned null object
        }
        
    }];
    
}

-(void)removeZeppaTagFollow:(GTLZeppaclientapiEventTag *)tag{
    
    long long tagFollowId = 0;
    for (GTLZeppaclientapiEventTagFollow *followTag in _followList) {
        if ([tag.identifier isEqualToNumber:followTag.tagId]) {
            tagFollowId = [followTag.identifier longLongValue];
            [self removeTagFollow:tagFollowId andWithfollowTag:followTag];
            return;
        }
    }
   
}
-(void)removeTagFollow:(long long)tagFollowId andWithfollowTag:(GTLZeppaclientapiEventTagFollow *)followTag{
    
    GTLQueryZeppaclientapi *removeFollowTask = [GTLQueryZeppaclientapi queryForRemoveEventTagFollowWithIdentifier:tagFollowId idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.evetTagFollowService executeQuery:removeFollowTask completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        //
        if(error){
            // error
        } else {
            [_followList removeObject:followTag];
            NSLog(@"success tagFollow removed ");
        }
    }];
    
}


-(void)finishTagQuery{
    
    _event.getTagIds = [_tagIdsArray mutableCopy];
   
    @try {
        
        if (_delgate && [_delgate respondsToSelector:@selector(getMutualMinglerTags)]) {
            [_delgate getMutualMinglerTags];
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
}

-(GTLServiceZeppaclientapi *)evetTagFollowService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}
-(GTLServiceZeppaclientapi *)evetTagService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
}
@end
