//
//  ZPAFetchDefaultTagsForUser.h
//  Zeppa
//
//  Created by Dheeraj on 27/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTLZeppaclientapiCollectionResponseEventTag.h"
#import "GTLZeppaclientapiEventTag.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"

#import "GTLZeppaclientapiEventTagFollow.h"
#import "GTLZeppaclientapiCollectionResponseEventTagFollow.h"

@protocol MutualMinglerTagDelegate <NSObject>

@required
-(void)getMutualMinglerTags;


@end

@interface ZPAFetchDefaultTagsForUser : NSObject

@property (nonatomic,assign)id<MutualMinglerTagDelegate>delgate;


@property (nonatomic,readonly) GTLServiceZeppaclientapi *evetTagFollowService;
@property (nonatomic,readonly) GTLServiceZeppaclientapi *evetTagService;

//@property (nonatomic,strong) NSMutableArray * followList;

-(BOOL)isFollowing:(GTLZeppaclientapiEventTag *)tag;

- (void) insertZeppaTagFollow:(GTLZeppaclientapiEventTagFollow *)tagFollow;

-(void)removeZeppaTagFollow:(GTLZeppaclientapiEventTag *)tagFollow;

-(void)executeZeppaApiWithUserId:(long long)userId  andMinglerId:(long long)minglerId;
@end
