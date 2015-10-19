

//
//  ZPDefaulZeppatUserInfo.m
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADefaulZeppatUserInfo.h"
#import "ZPAZeppaUserSingleton.h"

static ZPADefaulZeppatUserInfo *defaultUserInfo = nil;

@implementation ZPADefaulZeppatUserInfo

+(ZPADefaulZeppatUserInfo *)sharedObject{
    
    if (defaultUserInfo == nil) {
        defaultUserInfo = [[ZPADefaulZeppatUserInfo alloc]init];
        defaultUserInfo.user = [ZPAAppData sharedAppData].loggedInUser;
    }
    return defaultUserInfo;
}
+(void)resetObject{
    
    defaultUserInfo = nil;
    
}
-(BOOL)isMingling{
    
    if (_relationship) {
        
        return [_relationship.relationshipType isEqualToString:@"MINGLING"];
    }
    return NO;
    
}
-(BOOL)requestPending{
    
    if (_relationship) {
        
        return [_relationship.relationshipType isEqualToString:@"PENDING_REQUEST"];
    }
    return NO;
}
-(BOOL)didSendRequest{
    
    if (_relationship) {
        
        return ([_relationship.creatorId longLongValue] == [[ZPAZeppaUserSingleton sharedObject].userId longLongValue])?YES:NO;
    }
    return NO;
    
}
-(NSNumber *)userId{
    
    return self.zeppaUserInfo.key.parent.identifier;
}


-(void)setUserRelationship:(GTLZeppaclientapiZeppaUserToUserRelationship *)relationship{
    self.relationship = relationship;
}


@end
