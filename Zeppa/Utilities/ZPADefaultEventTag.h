//
//  ZPADefaultEventTag.h
//  Zeppa
//
//  Created by Peter Schuette on 3/3/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAEventTagBase.h"
#import "GTLZeppaclientapi.h"

@interface ZPADefaultEventTag : ZPAEventTagBase

@property (nonatomic, strong) GTLZeppaclientapiEventTagFollow *follow;

-(id) initWithEventTag:(GTLZeppaclientapiEventTag *)tag withOwner:(ZPAUserInfoBase *)owner withFollow: (GTLZeppaclientapiEventTagFollow*) follow;

-(BOOL) isMyTag;
-(BOOL) isFriendTag;
-(BOOL) isFollowing;
-(void) onTagTapped:(UIButton*)tagButton;

@end
