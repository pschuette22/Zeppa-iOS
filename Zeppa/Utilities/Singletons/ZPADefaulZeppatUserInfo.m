

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
    
    if (_relationShip) {
        
        return [_relationShip.relationshipType isEqualToString:@"MINGLING"];
    }
    return NO;
    
}
-(BOOL)requestPending{
    
    if (_relationShip) {
        
        return [_relationShip.relationshipType isEqualToString:@"PENDING_REQUEST"];
    }
    return NO;
}
-(BOOL)didSendRequest{
    
    if (_relationShip) {
        
        return ([_relationShip.creatorId longLongValue] == [[ZPAZeppaUserSingleton sharedObject].userId longLongValue])?YES:NO;
    }
    return NO;
    
}
-(NSNumber *)userId{
    
    return self.zeppaUserInfo.key.parent.identifier;
}


-(void)setUserRelationship:(GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *)relationship{
    relationship = _relationShip;
}


@end
