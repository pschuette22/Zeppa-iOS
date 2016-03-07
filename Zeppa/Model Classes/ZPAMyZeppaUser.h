//
//  ZPAMyZeppaUser.h
//  Zeppa
//
//  Created by Peter Schuette on 2/26/16.
//  Copyright © 2016 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLZeppaclientapiZeppaUser.h"
#import "GTLZeppaclientapiDeviceInfo.h"
#import "ZPAUserInfoBase.h"


///This class is the wrapper class which wraps GTLZeppaclientapiZeppaUser class to include more data for zeppa user to be used in the app


///It is similar as MyZeppaUserMediator in android.
@interface ZPAMyZeppaUser : ZPAUserInfoBase

@property (nonatomic, strong) GTLZeppaclientapiZeppaUser *endPointUser;

-(id) initWithZeppaUser: (GTLZeppaclientapiZeppaUser*) zeppaUser;

// Update methods

@end
