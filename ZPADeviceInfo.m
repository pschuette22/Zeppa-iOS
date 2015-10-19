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
        device.doUpdateToken = NO;
    });
    return device;
}
///****************************************
#pragma mark Devices Informations Methods
///****************************************
-(void)setLoginDeviceForUser:(ZPAMyZeppaUser *)user{
    // If this object holds a valid registration id, update device in background
    if([self doUpdateToken] && [self getRegistrationId]){
        loggedInUser = user;
        GTLZeppaclientapiDeviceInfo *deviceInfo = [[GTLZeppaclientapiDeviceInfo alloc]init];
        [deviceInfo setOwnerId:loggedInUser.endPointUser.identifier];
        [deviceInfo setPhoneType:@"iOS"];
        [deviceInfo setRegistrationId:[self getRegistrationId]];
        [deviceInfo setLoggedIn:[NSNumber numberWithInt:1]];
        
        [deviceInfo setLastLogin:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
        [deviceInfo setVersion:[NSNumber numberWithInt:1]];
        [deviceInfo setUpdate:[NSNumber numberWithInt:0]];
        [deviceInfo setBugfix:[NSNumber numberWithInt:0]];
        
        [self getDeviceInfoWithObject:deviceInfo withCursor:nil];
    }
    
}
-(void)getDeviceInfoWithObject: (GTLZeppaclientapiDeviceInfo *)deviceInfo withCursor:(NSString *)cursorValue{
    
    __weak typeof(self) weakSelf = self;
    GTLQueryZeppaclientapi *deviceQuery = [GTLQueryZeppaclientapi queryForListDeviceInfoWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    [deviceQuery setFilter:[NSString stringWithFormat:@"ownerId == %@",loggedInUser.endPointUser.identifier]];
    [deviceQuery setCursor:cursorValue];
    [deviceQuery setOrdering:nil];
    [deviceQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [self.deviceInfoService executeQuery:deviceQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseDeviceInfo *response, NSError *error) {
        //
        
        if(error){
            // error occurred
        } else if(response && response.items && response.items.count > 0){
            
            for (GTLZeppaclientapiDeviceInfo *device in response.items) {
                
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
-(void)insertDeviceInfoWithObject: (GTLZeppaclientapiDeviceInfo *)deviceInfo {
    
    if([self doUpdateToken] && deviceInfo){
        [self setDoUpdateToken:NO];
       __weak typeof(self) weakSelf = self;
        GTLQueryZeppaclientapi *insertTask = [GTLQueryZeppaclientapi queryForInsertDeviceInfoWithObject:deviceInfo idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
        [self.deviceInfoService executeQuery:insertTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiDeviceInfo *deviceInfo, NSError *error) {
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


- (void)updateDeviceInfoWithObject:(GTLZeppaclientapiDeviceInfo *)deviceInfo {
    
    if([self doUpdateToken] && deviceInfo){
        [self setDoUpdateToken:NO];
       __weak typeof(self) weakSelf = self;
        [deviceInfo setRegistrationId:[self getRegistrationId]];
        [deviceInfo setLoggedIn:[NSNumber numberWithInt:1]]; // 1 for logged in, 0 for not
        [deviceInfo setLastLogin:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]];
    
        GTLQueryZeppaclientapi *updateDeviceInfoTask = [GTLQueryZeppaclientapi queryForUpdateDeviceInfoWithObject:deviceInfo idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
        [[self deviceInfoService] executeQuery:updateDeviceInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiDeviceInfo *response, NSError *error) {
        
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

-(void)removeDeviceInfoWithObject: (GTLZeppaclientapiDeviceInfo *)deviceInfo{
    
    if(deviceInfo){
       __weak typeof(self) weakSelf = self;
        GTLQueryZeppaclientapi *updateDeviceInfoTask = [GTLQueryZeppaclientapi queryForRemoveDeviceInfoWithIdentifier:deviceInfo.identifier.longLongValue idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
        
        [[self deviceInfoService] executeQuery:updateDeviceInfoTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiDeviceInfo *response, NSError *error) {
        
            if(error){
            // Error occured
            } else {
                // Device was removed
            }
        }];
    
    }
}
-(GTLServiceZeppaclientapi *)deviceInfoService {
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    // Set Auth that is held in the delegate
    return service;
}

-(NSString *)getRegistrationId{
    
    return [ZPAAppDelegate sharedObject].registrationToken;
    
}
@end
