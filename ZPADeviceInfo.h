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
#import "GTLDeviceinfoendpointDeviceInfo.h"
#import "GTLQueryDeviceinfoendpoint.h"
#import "GTLServiceDeviceinfoendpoint.h"
#import "GTLDeviceinfoendpointCollectionResponseDeviceInfo.h"
@interface ZPADeviceInfo : NSObject

@property (readonly)GTLServiceDeviceinfoendpoint *deviceInfoService;
@property(nonatomic, strong) GTLDeviceinfoendpointDeviceInfo *currentDevice;

+(ZPADeviceInfo *)sharedObject;
-(void)setLoginDeviceForUser:(ZPAMyZeppaUser *)user;
- (void)updateDeviceInfoWithObject:(GTLDeviceinfoendpointDeviceInfo *)deviceInfo;
-(void)insertDeviceInfoWithObject: (GTLDeviceinfoendpointDeviceInfo *)deviceInfo;
-(void)removeDeviceInfoWithObject: (GTLDeviceinfoendpointDeviceInfo *)deviceInfo;
@end
