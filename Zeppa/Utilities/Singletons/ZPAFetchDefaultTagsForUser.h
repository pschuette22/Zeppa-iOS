//
//  ZPAFetchDefaultTagsForUser.h
//  Zeppa
//
//  Created by Dheeraj on 27/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTLEventtagendpointCollectionResponseEventTag.h"
#import "GTLEventtagendpointEventTag.h"
#import "GTLServiceEventtagendpoint.h"
#import "GTLQueryEventtagendpoint.h"

#import "GTLEventtagfollowendpointEventTagFollow.h"
#import "GTLEventtagfollowendpointCollectionResponseEventTagFollow.h"
#import "GTLServiceEventtagfollowendpoint.h"
#import "GTLQueryEventtagfollowendpoint.h"

@protocol MutualMinglerTagDelegate <NSObject>

@required
-(void)getMutualMinglerTags;


@end

@interface ZPAFetchDefaultTagsForUser : NSObject

@property (nonatomic,assign)id<MutualMinglerTagDelegate>delgate;


@property (nonatomic,readonly) GTLServiceEventtagfollowendpoint *evetTagFollowService;
@property (nonatomic,readonly) GTLServiceEventtagendpoint *evetTagService;

//@property (nonatomic,strong) NSMutableArray * followList;

-(BOOL)isFollowing:(GTLEventtagendpointEventTag *)tag;

- (void) insertZeppaTagFollow:(GTLEventtagfollowendpointEventTagFollow *)tagFollow;

-(void)removeZeppaTagFollow:(GTLEventtagendpointEventTag *)tagFollow;

-(void)executeZeppaApiWithUserId:(long long)userId  andMinglerId:(long long)minglerId;
@end
