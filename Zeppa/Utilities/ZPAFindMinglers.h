//
//  ZPAFindMinglers.h
//  Zeppa
//
//  Created by Faran on 24/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAUserInfoBase.h"
#import "ZPADefaultZeppaUserInfo.h"

#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLZeppaclientapiCollectionResponseZeppaUserInfo.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"


@protocol FindMinglerDelegate <NSObject>

-(void)finishLoadingMingler;

@end

@interface ZPAFindMinglers : NSObject

@property (strong,readonly)GTLServiceZeppaclientapi *zeppaUserRelationshipService;

@property (nonatomic,strong) NSMutableArray *uniqueInfoItems;

@property (strong,readonly)GTLServiceZeppaclientapi *zeppaUserInfoService;
@property (strong,readonly)ZPADefaultZeppaUserInfo *defaultZeppaUser;
@property (nonatomic, strong) id<FindMinglerDelegate>delegate;

-(void)getAllContacts;
-(void)executeZeppaApi;

@end
