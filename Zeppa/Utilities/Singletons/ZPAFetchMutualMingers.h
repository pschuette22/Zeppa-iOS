//
//  ZPAFetchMutualMingers.h
//  Zeppa
//
//  Created by Dheeraj on 27/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAUserInfoBaseClass.h"

#import "GTLZeppaclientapiCollectionResponseZeppaUserToUserRelationship.h"
#import "GTLZeppaclientapiZeppaEventToUserRelationship.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"

#import "ZPADefaulZeppatUserInfo.h"


@protocol MutualMinglerDelegate <NSObject>

@required
-(void)getMutualMinglerList;

@end

@interface ZPAFetchMutualMingers : NSObject
@property (nonatomic, strong)GTLServiceZeppaclientapi *zeppaUserToUserRelationship;
@property (nonatomic, assign)id<MutualMinglerDelegate>delegate;

-(void)executeZeppaMinglerApiWithZeppaUser:(ZPADefaulZeppatUserInfo *)zeppaUser withUserIndetifier:(long long)identifier;
@end