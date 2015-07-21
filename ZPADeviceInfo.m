//
//  ZPADeviceInfo.m
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADeviceInfo.h"

@implementation ZPADeviceInfo{
    
    ZPAMyZeppaUser *loggedInUser;
}

+(ZPADeviceInfo *)sharedObject{
    
    static ZPADeviceInfo *device;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    device = [[ZPADeviceInfo alloc]init];
    });
    return device;
}
///****************************************
#pragma mark Devices Informations Methods
///****************************************
-(void)setLoginDeviceForUser:(ZPAMyZeppaUser *)user{
    
    loggedInUser = user;
    GTLDeviceinfoendpointDeviceInfo *deviceInfo = [[GTLDeviceinfoendpointDeviceInfo alloc]init];
    [deviceInfo setOwnerId:loggedInUser.endPointUser.identifier];
    [deviceInfo setPhoneType:@"iOS"];
    [deviceInfo setRegistrationId:[self getRegistrationId]];
    [deviceInfo setLoggedIn:[NSNumber numberWithInt:1]];
    [deviceInfo setLastLogin:[NSNumber numberWithLong:[ZPADateHelper currentTimeMillis]]];
    [deviceInfo setVersion:[NSNumber numberWithInt:1]];
    [deviceInfo setUpdate:[NSNumber numberWithInt:0]];
    [deviceInfo setBugfix:[NSNumber numberWithInt:0]];
    
    [self getDeviceInfoWithObject:deviceInfo withCursor:nil];
    
}
-(void)getDeviceInfoWithObject: (GTLDeviceinfoendpointDeviceInfo *)deviceInfo withCursor:(NSString *)cursorValue{
    
    __weak typeof(self) weakSelf = self;
    GTLQueryDeviceinfoendpoint *deviceQuery = [GTLQueryDeviceinfoendpoint queryForListDeviceInfo];
    [deviceQuery setFilter:[NSString stringWithFormat:@"ownerId == %@",loggedInUser.endPointUser.identifier]];
    [deviceQuery setCursor:cursorValue];
    [deviceQuery setOrdering:nil];
    [deviceQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.deviceInfoService executeQuery:deviceQuery completionHandler:^(GTLServiceTicket *ticket, GTLDeviceinfoendpointCollectionResponseDeviceInfo *response, NSError *error) {
        //
        
        if(error){
            // error occurred
        } else if(response && response.items && response.items.count > 0){
            
            for (GTLDeviceinfoendpointDeviceInfo *device in response.items) {
                
                if ([device.registrationId isEqualToString:deviceInfo.registrationId]) {
                    [weakSelf updateDeviceInfoWithObject:device];
                    return;
                }
            }
            NSString *cursor = response.nextPageToken;
            if(cursor){
                [weakSelf getDeviceInfoWithObject:deviceInfo withCursor:cursor];
            }else{
                [weakSelf insertDeviceInfoWithObject:deviceInfo];
            }
        }else{
           [self insertDeviceInfoWithObject:deviceInfo];
        }
    }];
    
    
}
-(void)insertDeviceInfoWithObject: (GTLDeviceinfoendpointDeviceInfo *)deviceInfo {
    
    if(deviceInfo){
       __weak typeof(self) weakSelf = self;
        GTLQueryDeviceinfoendpoint *insertTask = [GTLQueryDeviceinfoendpoint queryForInsertDeviceInfoWithObject:deviceInfo];
    
        [self.deviceInfoService executeQuery:insertTask completionHandler:^(GTLServiceTicket *ticket, GTLDeviceinfoendpointDeviceInfo *deviceInfo, NSError *error) {
        //
        
            if(error){
            // Error
            }else if (deviceInfo.identifier) {
                weakSelf.currentDevice = deviceInfo;
            // Success
            
            } else {
            // Nil Object Returned
            }
        }];
    }
}
- (void)updateDeviceInfoWithObject:(GTLDeviceinfoendpointDeviceInfo *)deviceInfo {
    
    if(deviceInfo){
       __weak typeof(self) weakSelf = self;
        [deviceInfo setRegistrationId:[self getRegistrationId]];
        [deviceInfo setLoggedIn:[NSNumber numberWithInt:1]]; // 1 for logged in, 0 for not
        [deviceInfo setLastLogin:[NSNumber numberWithLong:[ZPADateHelper currentTimeMillis]]];
    
        GTLQueryDeviceinfoendpoint *updateDeviceInfoTask = [GTLQueryDeviceinfoendpoint queryForUpdateDeviceInfoWithObject:deviceInfo];
        [[self deviceInfoService] executeQuery:updateDeviceInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLDeviceinfoendpointDeviceInfo *response, NSError *error) {
        
            if(error){
            // Error occured
            } else if (response.identifier) {
            
               weakSelf.currentDevice = response;
                NSLog(@"Update Device Successfully");
            
            } else {
            // Returned null object
            }
        
        }];
    }
}
-(void)removeDeviceInfoWithObject: (GTLDeviceinfoendpointDeviceInfo *)deviceInfo{
    
    if(deviceInfo){
       __weak typeof(self) weakSelf = self;
        GTLQueryDeviceinfoendpoint *updateDeviceInfoTask = [GTLQueryDeviceinfoendpoint queryForRemoveDeviceInfoWithObject:deviceInfo];
        [[self deviceInfoService] executeQuery:updateDeviceInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLDeviceinfoendpointDeviceInfo *response, NSError *error) {
        
            if(error){
            // Error occured
            } else if (response.identifier) {
            
            weakSelf.currentDevice = response;
            NSLog(@"Insert Device Successfully");
            
            } else {
            // Returned null object
            }
        }];
    
    }
}
-(GTLServiceDeviceinfoendpoint *)deviceInfoService {
    static GTLServiceDeviceinfoendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceDeviceinfoendpoint alloc] init];
        service.retryEnabled = YES;
    }
    // Set Auth that is held in the delegate
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}

-(NSString *)getRegistrationId{
    
    return [ZPAAppDelegate sharedObject].currentDeviceToken;
    
}
@end
