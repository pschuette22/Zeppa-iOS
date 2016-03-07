//
//  ZPAEventTagBase.m
//  Zeppa
//
//  Created by Peter Schuette on 3/3/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import "ZPAEventTagBase.h"

@implementation ZPAEventTagBase

-(id) initWithEventTag:(GTLZeppaclientapiEventTag*) tag withOwner:(ZPAUserInfoBase*)owner {
    
    if(self = [super init]){
        self.tag = tag;
        self.ownerInfo = owner;
    }
    
    return self;
}

@end
