//
//  ZPADeviceInfo.h
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ZPADeviceInfo : NSObject
@property(nonatomic, strong) GTLZeppaclientapiDeviceInfo *device;

-(id) initWithDevice: (GTLZeppaclientapiDeviceInfo*) device;

@end
