//
//  ZPADeviceInfo.m
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADeviceInfo.h"

@implementation ZPADeviceInfo

-(id) initWithDevice: (GTLZeppaclientapiDeviceInfo*) device {
    if(self = [super init]){
        // Other initializations
    }
    return self;
}

-(GTLServiceZeppaclientapi *)service {
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
