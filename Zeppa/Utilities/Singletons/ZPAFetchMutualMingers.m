//
//  ZPAFetchMutualMingers.m
//  Zeppa
//
//  Created by Dheeraj on 27/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAFetchMutualMingers.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPADefaulZeppatUserInfo.h"
#import "GTLZeppaclientapiKey.h"

@implementation ZPAFetchMutualMingers{
    
    long long _userId;
    ZPADefaulZeppatUserInfo *_mingler;
    NSMutableArray *_result;
}
-(void)executeZeppaMinglerApiWithZeppaUser:(ZPADefaulZeppatUserInfo *)zeppaUser withUserIndetifier:(long long)identifier{
    
    _result = [NSMutableArray array];
    _userId = identifier;
    _mingler = zeppaUser;
    [self executeZeppaUserToUserRelationshipListQueryForCreatorId:nil];
}
-(void)executeZeppaUserToUserRelationshipListQueryForCreatorId:(NSString *)cursorValue{
        
       __weak typeof(self) weakSelf = self;
        GTLQueryZeppaclientapi *u2uRelationshipQuery = [GTLQueryZeppaclientapi queryForListZeppaUserToUserRelationshipWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
        
     [u2uRelationshipQuery setFilter:[NSString stringWithFormat:@"creatorId == %@ && subjectId != %lld && relationshipType == 'MINGLING'",_mingler.zeppaUserInfo.key.parent.identifier,_userId]];
        [u2uRelationshipQuery setCursor:cursorValue];
        [u2uRelationshipQuery setLimit:[[NSNumber numberWithInt:50] integerValue]];
        
        [self.zeppaUserToUserRelationship executeQuery:u2uRelationshipQuery completionHandler:^(GTLServiceTicket *ticket,  GTLZeppaclientapiCollectionResponseZeppaUserToUserRelationship *response, NSError *error) {
            //
            if(error){
                // error
            } else if(response && response.items && response.items.count > 0){
               
                
               NSString *currentCursor = response.nextPageToken;
                
                for (GTLZeppaclientapiZeppaUserToUserRelationship *relation in response.items) {
                    
                    if (relation.subjectId>0) {
                        
                        [_result addObject:relation.subjectId];
                    }
                    
                }
                if (currentCursor) {
                    [weakSelf executeZeppaUserToUserRelationshipListQueryForCreatorId:currentCursor];
                }else{
                    [weakSelf executeZeppaUserToUserRelationshipListQueryForSubjectId:nil];
                }
                
            } else {
                [weakSelf executeZeppaUserToUserRelationshipListQueryForSubjectId:nil];
            }
        }];
        
}
-(void)executeZeppaUserToUserRelationshipListQueryForSubjectId:(NSString *)cursorValue{
    
    
    __weak typeof(self) weakSelf = self;
    GTLQueryZeppaclientapi *u2uRelationshipQuery = [GTLQueryZeppaclientapi queryForListZeppaUserToUserRelationshipWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [u2uRelationshipQuery setFilter:[NSString stringWithFormat:@"subjectId == %@ && creatorId != %lld && relationshipType == 'MINGLING'",_mingler.zeppaUserInfo.key.parent.identifier,_userId]];
    [u2uRelationshipQuery setCursor:cursorValue];
    [u2uRelationshipQuery setLimit:[[NSNumber numberWithInt:50] integerValue]];
    
    [self.zeppaUserToUserRelationship executeQuery:u2uRelationshipQuery completionHandler:^(GTLServiceTicket *ticket,  GTLZeppaclientapiCollectionResponseZeppaUserToUserRelationship *response, NSError *error) {
        //
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            for (GTLZeppaclientapiZeppaUserToUserRelationship *relation in response.items) {
                
                if (relation.creatorId>0) {
                    
                    [_result addObject:relation.creatorId];
                }
                
            }
            
            NSString *currentCursor = response.nextPageToken;
            if (currentCursor) {
                [weakSelf executeZeppaUserToUserRelationshipListQueryForSubjectId:currentCursor];
            }else{
                
                [weakSelf finishQuery];
            }
            
        } else {
            [weakSelf finishQuery];
        }
    }];
    
}
-(void)finishQuery{
    
    _mingler.minglersIds = [_result mutableCopy];
    
    @try {
        
        if (_delegate && [_delegate respondsToSelector:@selector(getMutualMinglerList)]) {
            [_delegate getMutualMinglerList];
        }
        
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }

    
}
-(GTLServiceZeppaclientapi *)zeppaUserToUserRelationship{
    
    static GTLServiceZeppaclientapi *service = nil;
        if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}
@end
