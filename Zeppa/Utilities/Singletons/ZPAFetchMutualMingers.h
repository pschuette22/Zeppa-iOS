//
//  ZPAFetchMutualMingers.h
//  Zeppa
//
//  Created by Dheeraj on 27/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAUserInfoBaseClass.h"

#import "GTLZeppausertouserrelationshipendpointCollectionResponseZeppaUserToUserRelationship.h"
#import "GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship.h"
#import "GTLServiceZeppausertouserrelationshipendpoint.h"
#import "GTLQueryZeppausertouserrelationshipendpoint.h"

#import "ZPADefaulZeppatUserInfo.h"


@protocol MutualMinglerDelegate <NSObject>

@required
-(void)getMutualMinglerList;

@end

@interface ZPAFetchMutualMingers : NSObject
@property (nonatomic, strong)GTLServiceZeppausertouserrelationshipendpoint *zeppaUserToUserRelationship;
@property (nonatomic, assign)id<MutualMinglerDelegate>delegate;

-(void)executeZeppaMinglerApiWithZeppaUser:(ZPADefaulZeppatUserInfo *)zeppaUser withUserIndetifier:(long long)identifier;
@end