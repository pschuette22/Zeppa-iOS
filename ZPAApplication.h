//
//  ZPAApplication.h
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAFetchInitialMinglers.h"
#import "ZPAFetchMyEventTags.h"
#import "ZPAFetchInitialEvents.h"

@interface ZPAApplication : NSObject
@property (nonatomic, strong)ZPAFetchInitialMinglers *fetchIntialMinglers;
@property (nonatomic, strong)ZPAFetchMyEventTags *fetchMyEventTag;
@property (nonatomic, strong)ZPAFetchInitialEvents *fetchInitialEvent;


+(ZPAApplication *)sharedObject;
-(void)initizationsWithCurrentUser:(ZPAMyZeppaUser *)currentUser;
@end
