//
//  ZPADefaultEventTag.m
//  Zeppa
//
//  Created by Peter Schuette on 3/3/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPADefaultEventTag.h"

@implementation ZPADefaultEventTag

-(id) initWithEventTag:(GTLZeppaclientapiEventTag *)tag withOwner:(ZPAUserInfoBase *)owner withFollow: (GTLZeppaclientapiEventTagFollow*) follow {
    
    // Initialize the model with parent entities
    if(self = [super initWithEventTag:tag withOwner:owner]) {
        self.follow = follow;
    }
    
    return self;
}

/**
 *  Convenience method becuase polymorphism is lame in ios
 */
-(BOOL) isMyTag {
    return NO;
}

/**
 *  true if this is a friends tag
 *  if this is not a friends tag, user interaction is not allowed
 */
-(BOOL) isFriendTag {
    // Verify object type before casting
    if([self.ownerInfo respondsToSelector:@selector(getRelationship)]){
        ZPADefaultZeppaUserInfo* defaultUserInfo = (ZPADefaultZeppaUserInfo*) self.ownerInfo;
        if(defaultUserInfo.relationship) {
            return [defaultUserInfo.relationship.relationshipType isEqualToString:@"MINGLING"];
        }
    }
    
    return NO;
}

/**
 *  true if this is a tag the causes event recommendations for current user
 */
- (BOOL) isFollowing {
    // TODO: return true if calculated interest is greater than %70
    return YES;
}

-(void) onTagTapped:(UIButton*)tagButton {
    // The tag was tapped, if there is a high calculated interest, knock it down
    // If it is low, bump it up
    
    // adjust the ui image as necessary
    
    // TODO: after adjusting interest, update the object
}



@end
