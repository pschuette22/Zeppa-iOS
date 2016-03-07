

//
//  ZPDefaulZeppatUserInfo.m
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADefaultZeppaUserInfo.h"
#import "ZPAZeppaUserSingleton.h"

@implementation ZPADefaultZeppaUserInfo {
    BOOL _isPendingRequest;
    BOOL _didSendRequest;
    BOOL _isFriend;
}

-(id) initWithUserInfo:(GTLZeppaclientapiZeppaUserInfo *)userInfo withRelationship: (GTLZeppaclientapiZeppaUserToUserRelationship*) relationship {
    
    if(self = [super initWithUserInfo:userInfo]) {
        self.userId = userInfo.key.parent.identifier;
        self.mututalFriendIds = [[NSMutableArray alloc] init];
        [self setUserRelationship:relationship];
    }
    
    return self;
}

/**
 * Update this event info object with a defined relationship
 *
 *  @param relationship     - ZeppaUserToUserRelationship between current user and another or nil if none
 */
-(void)setUserRelationship:(GTLZeppaclientapiZeppaUserToUserRelationship *)relationship {
    self.relationship = relationship;
    
    if(relationship) {
        // If there is a defined relationship,
        _isPendingRequest = [relationship.relationshipType isEqualToString:@"PENDING_REQUEST"];
        _isFriend = [relationship.relationshipType isEqualToString:@"MINGLING"];
        NSNumber *userId = [[ZPAZeppaUserSingleton sharedObject] getMyZeppaUserIdentifier];
        _didSendRequest = [relationship.creatorId isEqualToNumber:userId];
        
    } else {
        // The relationship is nil
        _isPendingRequest = NO;
        _didSendRequest = NO;
        _isFriend = NO;
    }
}

/**
 *  Get the relationship between this user and current user
 */
-(GTLZeppaclientapiZeppaUserToUserRelationship*) getRelationship {
    return _relationship;
}


/**
 * YES if there is currently a pending request
 */
-(BOOL) isPendingRequest {
    return _isPendingRequest;
}

-(BOOL) didSendRequest {
    return _didSendRequest;
}

-(BOOL) isFriend; {
    return _isFriend;
}


@end
