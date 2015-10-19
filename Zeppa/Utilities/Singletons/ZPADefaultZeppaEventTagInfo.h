//
//  ZPADefaultZeppaEventTagInfo.h
//  Zeppa
//
//  Created by Dheeraj on 28/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAAuthenticatonHandler.h"

#import "GTLZeppaclientapiEventTag.h"
#import "GTLZeppaclientapiEventTagFollow.h"

#import "GTLZeppaclientapiCollectionResponseEventTagFollow.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"

@interface ZPADefaultZeppaEventTagInfo : NSObject

@property (nonatomic,readonly) GTLServiceZeppaclientapi *evetTagFollowService;
@property (nonatomic, strong) GTLZeppaclientapiEventTag *eventTag;
@property (nonatomic, strong) GTLZeppaclientapiEventTagFollow *eventTagFollow;

@property (nonatomic,weak)NSMutableArray *followList;


- (void)insertZeppaTagFollow:(GTLZeppaclientapiEventTagFollow *)tagFollow;

- (void) removeZeppaTagFollow:(GTLZeppaclientapiEventTagFollow *)tagFollow;

-(BOOL)isFollowing;
@end
