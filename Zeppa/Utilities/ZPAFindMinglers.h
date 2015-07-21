//
//  ZPAFindMinglers.h
//  Zeppa
//
//  Created by Faran on 24/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAUserInfoBaseClass.h"
#import "ZPADefaulZeppatUserInfo.h"

#import "GTLZeppauserendpointZeppaUserInfo.h"
#import "GTLZeppauserinfoendpointCollectionResponseZeppaUserInfo.h"
#import "GTLQueryZeppauserinfoendpoint.h"
#import "GTLServiceZeppauserinfoendpoint.h"

#import "GTLServiceZeppausertouserrelationshipendpoint.h"


@protocol FindMinglerDelegate <NSObject>

-(void)finishLoadingMingler;

@end

@interface ZPAFindMinglers : ZPAUserInfoBaseClass

@property (strong,readonly)GTLServiceZeppausertouserrelationshipendpoint *zeppaUserRelationshipService;

@property (nonatomic,strong) NSMutableArray *uniqueInfoItems;
@property (nonatomic,strong) NSMutableArray *recognizedEmails;
@property (nonatomic,strong) NSMutableArray *recognizedNumbers;

@property (strong,readonly)GTLServiceZeppauserinfoendpoint *zeppaUserInfoService;
@property (strong,readonly)ZPADefaulZeppatUserInfo *defaultZeppaUser;
@property (nonatomic, strong) id<FindMinglerDelegate>delegate;

-(void)getAllContacts;
-(void)executeZeppaApi;

@end
