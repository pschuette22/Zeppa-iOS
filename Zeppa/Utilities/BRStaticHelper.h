//
//  BRStaticHelper.h
//  Bravo
//
//  Created by Dheeraj on 23/12/14.
//  Copyright (c) 2014 Agicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BRStaticHelper : NSObject

+(BRStaticHelper *)sharedObject;
//****************************************************
#pragma mark - ContentOffsect Method
//****************************************************
-(void)setContentOffSetof:(id)view insideInView:(id)baseView withLastFieldTagValue:(NSInteger)lastTag;
//****************************************************
#pragma mark - checkAllFieldHasValue Method
//****************************************************
+(BOOL)checkAllFieldHasValue:(NSString *)firstArg, ...
NS_REQUIRES_NIL_TERMINATION;


+(BOOL)checkEmptyTextField:(UITextField *)firstArg,...NS_REQUIRES_NIL_TERMINATION;

@end
