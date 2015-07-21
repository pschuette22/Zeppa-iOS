//
//  ZPAStaticHelper.h
//  Zeppa
//
//  Created by Milan Agarwal on 05/09/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZPADateAndTimePicker.h"
#import "ZPACustomPicker.h"


@interface ZPAStaticHelper : NSObject

/*!
 * @description It is a utility method to check whether object (basically object from web API response) is valid or not and can be used or not. The check is basically on the basis of the rule that the object should not be nil neither it should be of NSNull type
 * @param webObject is the object that needs to be validated
 * @return YES if it is valid and can be used otherwise NO
 */

+(BOOL)canUseWebObject:(id)webObject;

+(CGSize)calculateSizeWithFont:(UIFont *)font constraintSize:(CGSize)constraintSize andText:(NSString *)text;


//****************************************************
#pragma mark - Add Event Screen
//****************************************************

+(int)addEventTitleMaxCharactersLimit;
+(int)addEventDescriptionMaxCharactersLimit;
+(int)addEventMaxTagSelectionLimit;

//****************************************************
#pragma mark - Add New Tag Method
//****************************************************
+(int)getMaxCharacterInTextField;


//****************************************************
#pragma mark - Alert View Method
//****************************************************

/*!
 * @description Its a helper method to show alertview on screen
 * @param title Title of the alert message
 * @param message Error message to be displayed
 */

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message;


//****************************************************
#pragma mark - Colors
//****************************************************

+(UIColor *)zeppaThemeColor;

+(UIColor *)backgroundColorForSectionHeader;

+(UIColor *)titleColorForHeaders;

+(UIColor *)greyBorderColor;

+(UIColor *)backgroundTextureColor;


//****************************************************
#pragma mark - ContentOffsect Method
//****************************************************
+(void)setContentOffSetof:(id)view insideInView:(id)baseView;

//****************************************************
#pragma mark - CornarRadius Method
//****************************************************
+(void)setCornarRadiusofView:(UIView *)view andRadius:(float)radius withBordarColor:(UIColor *)bordarColor andBordarWidth:(float)width;

//****************************************************
#pragma mark - Xib File Method
//****************************************************

+(ZPADateAndTimePicker *)datePickerView;
+(ZPACustomPicker *)customPickerView;


//****************************************************
#pragma mark - Private Method
//****************************************************
+(BOOL)isValidString:(NSString *)string;


+(void)sortArrayAlphabatically:(NSMutableArray *)array withKey:(NSString *)string;
@end
