//
//  ZPADefaultZeppaEventTagInfo.h
//  Zeppa
//
//  Created by Dheeraj on 28/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAAuthenticatonHandler.h"

#import "GTLEventtagendpointEventTag.h"
#import "GTLEventtagfollowendpointEventTagFollow.h"

#import "GTLEventtagfollowendpointEventTagFollow.h"
#import "GTLEventtagfollowendpointCollectionResponseEventTagFollow.h"
#import "GTLServiceEventtagfollowendpoint.h"
#import "GTLQueryEventtagfollowendpoint.h"

@interface ZPADefaultZeppaEventTagInfo : NSObject

@property (nonatomic,readonly) GTLServiceEventtagfollowendpoint *evetTagFollowService;
@property (nonatomic, strong) GTLEventtagendpointEventTag *eventTag;
@property (nonatomic, strong) GTLEventtagfollowendpointEventTagFollow *eventTagFollow;

@property (nonatomic,weak)NSMutableArray *followList;


- (void)insertZeppaTagFollow:(GTLEventtagfollowendpointEventTagFollow *)tagFollow;

- (void) removeZeppaTagFollow:(GTLEventtagfollowendpointEventTagFollow *)tagFollow;

-(BOOL)isFollowing;
@end
