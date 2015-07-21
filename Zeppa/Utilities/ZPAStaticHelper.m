//
//  ZPAStaticHelper.m
//  Zeppa
//
//  Created by Milan Agarwal on 05/09/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAStaticHelper.h"

@implementation ZPAStaticHelper

+(BOOL)canUseWebObject:(id)webObject
{
    if (webObject != nil
        && (![webObject isKindOfClass:[NSNull class]])) {
        return YES;
    }
    return NO;
}

+(CGSize)calculateSizeWithFont:(UIFont *)font constraintSize:(CGSize)constraintSize andText:(NSString *)text
{
    if ((!font)
        ||(!text)
        ||(text.length == 0)) {
        return CGSizeZero;
    }
    CGSize size;
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName];
    
    size = [text boundingRectWithSize:constraintSize
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:stringAttributes context:nil].size;
    
    return size;
}

//****************************************************
#pragma mark - Add Event Screen
//****************************************************

+(int)addEventTitleMaxCharactersLimit
{
    return 40;
}
+(int)addEventDescriptionMaxCharactersLimit
{
    return 400;
}

+(int)addEventMaxTagSelectionLimit
{
    return 6;
}

//****************************************************
#pragma mark - Add New Tag Method
//****************************************************
+(int)getMaxCharacterInTextField{
    
    return 15;
}


//****************************************************
#pragma mark - Alert View Method
//****************************************************

+(void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert show];

}

//****************************************************
#pragma mark - Colors
//****************************************************

+(UIColor *)zeppaThemeColor
{
    return [UIColor colorWithRed:10/255.0f green:210/255.0f blue:255/255.0f alpha:1.0f];

}

+(UIColor *)backgroundColorForSectionHeader
{
    
    return [UIColor colorWithRed:10/255.0f green:210/255.0f blue:255/255.0f alpha:1.0f];
    
}

+(UIColor *)titleColorForHeaders
{
    return [UIColor whiteColor];
}

+(UIColor *)greyBorderColor
{
    return [UIColor colorWithRed:209/255.0f green:209/255.0f blue:209/255.0f alpha:1.0f];

}

+(UIColor *)backgroundTextureColor
{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture"]];
}

//****************************************************
#pragma mark - ContentOffsect Method
//****************************************************
+(void)setContentOffSetof:(id)view insideInView:(id)baseView
{
        CGRect rect = [view bounds];
        rect = [view convertRect:rect toView:baseView];
        CGPoint point = rect.origin ;
        point.x = 0;
        point.y -= 80;
        [baseView setContentOffset:point animated:YES];
}


//****************************************************
#pragma mark - CornarRadius Method
//****************************************************
+(void)setCornarRadiusofView:(UIView *)view andRadius:(float)radius withBordarColor:(UIColor *)bordarColor andBordarWidth:(float)width{
    
    view.layer.cornerRadius = radius;
    view.layer.borderWidth = width;
    view.layer.borderColor = bordarColor.CGColor;
    view.layer.masksToBounds = YES;
    
}

//****************************************************
#pragma mark - Xib File Method
//****************************************************
+(ZPADateAndTimePicker *)datePickerView{
    
    return  [[[NSBundle mainBundle]loadNibNamed:@"Dialog_iPhone" owner:nil options:nil] objectAtIndex:0];
    
}
+(ZPACustomPicker *)customPickerView{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"Dialog_iPhone" owner:nil options:nil] objectAtIndex:1];
}

//****************************************************
#pragma mark - Private Method
//****************************************************
+(BOOL)isValidString:(NSString *)string{
    
    if (!string || [string length]==0) {
        return NO;
    }
    return YES;
}

+(void)sortArrayAlphabatically:(NSMutableArray *)array withKey:(NSString *)string{
    
    NSSortDescriptor * sortDiscriptor = [NSSortDescriptor sortDescriptorWithKey:string ascending:YES];
    
    [array sortUsingDescriptors:[NSArray arrayWithObject:sortDiscriptor]];
    
}

@end
