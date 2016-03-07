//
//  ZPAMyZeppaUser.m
//  Zeppa
//
//  Created by Peter Schuette on 2/26/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAMyZeppaUser.h"

@implementation ZPAMyZeppaUser

-(id) initWithZeppaUser: (GTLZeppaclientapiZeppaUser*) zeppaUser {
    if(self = [super initWithUserInfo:zeppaUser.userInfo]) {
        self.endPointUser = zeppaUser;
    }
    return self;
}

// Override the get user id method for simplicity
- (NSNumber*) getUserId {
    return self.endPointUser.identifier;
}

@end