//
//  ZPAApplication.h
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPAApplication : NSObject


+(ZPAApplication *)sharedObject;
-(void)initizationsWithCurrentUser:(ZPAMyZeppaUser *)currentUser;
-(ZPAMyZeppaUser*) getCurrentUser;

@end
