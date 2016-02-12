//
//  ZPADeviceInfo.h
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPAAppDelegate.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAMyZeppaUser.h"
#import "GTLZeppaclientapiDeviceInfo.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLZeppaclientapiCollectionResponseDeviceInfo.h"
@interface ZPADeviceInfo : NSObject

@property (readonly)GTLServiceZeppaclientapi *deviceInfoService;
@property(nonatomic, strong) GTLZeppaclientapiDeviceInfo *currentDevice;
@property(readwrite) BOOL doUpdateToken;

+(ZPADeviceInfo *)sharedObject;
-(void)setLoginDeviceForUser:(ZPAMyZeppaUser *)user;
-(void)updateDeviceInfoWithObject:(GTLZeppaclientapiDeviceInfo *)deviceInfo;
-(void)insertDeviceInfoWithObject: (GTLZeppaclientapiDeviceInfo *)deviceInfo;
-(void)removeDeviceInfoWithObject: (GTLZeppaclientapiDeviceInfo *)deviceInfo;
@end
