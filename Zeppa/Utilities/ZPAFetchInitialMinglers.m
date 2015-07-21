//
//  ZPAFetchInitialMinglers.m
//  Zeppa
//
//  Created by Dheeraj on 17/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAFetchInitialMinglers.h"

@implementation ZPAFetchInitialMinglers

-(void)executeZeppaApi{
    
    [self getZeppaUserToUserRelationshipListQueryUsingCreatorIdwithCursor:nil];
}
///***********************************************
#pragma  mark - Zeppa UserToUser RelationShip Api
///***********************************************
-(void)getZeppaUserToUserRelationshipListQueryUsingCreatorIdwithCursor:(NSString *)cursorValue{
    
    __weak  typeof(self)  weakSelf = self;
    
    __block NSString *filter = [NSString stringWithFormat:@"creatorId == %@",[ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier];
    __block  NSString *ordering = @"created desc";
    __block NSNumber *limit = [NSNumber numberWithInt:50];
    
    GTLQueryZeppausertouserrelationshipendpoint *u2uRelationshipQuery = [GTLQueryZeppausertouserrelationshipendpoint queryForListZeppaUserToUserRelationship];
    
    [u2uRelationshipQuery setFilter:filter];
    [u2uRelationshipQuery setCursor:cursorValue];
    [u2uRelationshipQuery setOrdering:ordering];
    [u2uRelationshipQuery setLimit:[limit integerValue]];
    
    [self.zeppaUserRelationshipService executeQuery:u2uRelationshipQuery completionHandler:^(GTLServiceTicket *ticket,  GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship *response, NSError *error) {
        //
        
      //  __strong typeof(self) strongSelf = weakSelf;
      //  __typeof__(self) strongSelf = weakSelf;
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            for (GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *mingler in response.items) {
                [weakSelf fetchZeppaUserInfoWithParentIdentifier:mingler.subjectId withCompletion:^(GTLZeppauserinfoendpointZeppaUserInfo *info) {
                    
                    [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:info andRelationShip:mingler];
                    
                }];
            }
            NSString *nextCursor = response.nextPageToken;
            if (nextCursor) {
                [weakSelf getZeppaUserToUserRelationshipListQueryUsingCreatorIdwithCursor:nextCursor];
            }else{
                [weakSelf getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:nil];
            }
        }else{
            [weakSelf getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:nil];
        }
    }];
    
}
-(void)getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:(NSString *)cursorValue{
    
    __block typeof(self)  weakSelf = self;
    __block NSString *filter = [NSString stringWithFormat:@"subjectId == %@",[ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier];
    __block  NSString *ordering = @"created desc";
    __block NSNumber *limit = [NSNumber numberWithInt:50];
    
    GTLQueryZeppausertouserrelationshipendpoint *u2uRelationshipQuery = [GTLQueryZeppausertouserrelationshipendpoint queryForListZeppaUserToUserRelationship];
    
    [u2uRelationshipQuery setFilter:filter];
    [u2uRelationshipQuery setCursor:cursorValue];
    [u2uRelationshipQuery setOrdering:ordering];
    [u2uRelationshipQuery setLimit:[limit integerValue]];
    
    [self.zeppaUserRelationshipService executeQuery:u2uRelationshipQuery completionHandler:^(GTLServiceTicket *ticket,  GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship *response, NSError *error) {
        //
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            for(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *mingler in response.items) {
                [weakSelf fetchZeppaUserInfoWithParentIdentifier:mingler.creatorId withCompletion:^(GTLZeppauserinfoendpointZeppaUserInfo *info) {
                    
                    [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:info andRelationShip:mingler];
                    
                }];
                
            }
            NSString *nextCursor = response.nextPageToken;
            if (nextCursor) {
                [weakSelf getZeppaUserToUserRelationshipListQueryUsingSubjectIdwithCursor:nextCursor];
            }else{
                [weakSelf fetchInitialEvent];
            }
        }else{
            [weakSelf fetchInitialEvent];
        }
    }];
    
}
-(GTLServiceZeppausertouserrelationshipendpoint *)zeppaUserRelationshipService{
    
    static GTLServiceZeppausertouserrelationshipendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppausertouserrelationshipendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}
///***********************************************
#pragma  mark - InitialEvent Class Initializaiton
///***********************************************
-(void)fetchInitialEvent{
    
    _fetchInitial =  [[ZPAFetchInitialEvents alloc]init];
    [_fetchInitial executeZeppaApi];
    
}
@end
