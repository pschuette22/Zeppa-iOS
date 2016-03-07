//
//  ZPAStaticHelper.m
//  Zeppa
//
//  Created by Milan Agarwal on 05/09/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAStaticHelper.h"
#import "ZPAUserDefault.h"
#import "DistanceConverter.h"
#import <CoreLocation/CoreLocation.h>

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

// dynamically calculate the number of lines needed to fit all label text
+ (int)lineCountForLabel:(UILabel *)label
{
    CGFloat labelWidth = label.frame.size.width;
    int lineCount = 0;
    CGSize textSize = CGSizeMake(labelWidth, MAXFLOAT);
    long rHeight = lroundf([label sizeThatFits:textSize].height);
    long charSize = lroundf(label.font.leading);
    lineCount = (int)( rHeight / charSize );
    return lineCount;
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


+ (NSString*) locationSuffixOrNil {
    NSString *locationSuffix = nil;
    
    // Verify location services is enabled and location is authorized
        if([CLLocationManager locationServicesEnabled] &&
           ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
            [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
    
               NSDecimalNumber* lat = [ZPAUserDefault getValueFromUserDefaultUsingKey:kLocationLatitude];
               NSDecimalNumber* lon = [ZPAUserDefault getValueFromUserDefaultUsingKey:kLocationLongitude];
               
               // Verify that these are stored numbers
               if(lat && lon) {
                   // Stored numbers, get the lat/lon window that is within 50 miles
//                   CLLocationCoordinate2D *coordinates = CLLocationCoordinate2DMake([CLLocationDegrees de], CLLocationDegrees longitude)
                   CLLocation *mLocation = [[CLLocation alloc] initWithLatitude:lat.doubleValue longitude:lon.doubleValue];
                   NSArray *maxCoordinates = [DistanceConverter getAreaPoints:50 inUnits:DUUnitMiles from:mLocation];
                   CLLocation *tl_coord = [maxCoordinates objectAtIndex:0];
                   CLLocation *br_coord = [maxCoordinates objectAtIndex:1];
                   
                   // Build the suffix: && latitude <= topLeftLatitude && latitude >= bottomRightLatitude && longitude <= topLeftLongitude && longitude >= bottomRightLongitude
                   locationSuffix = [NSString stringWithFormat:@"&& latitude <= %f && latitude >= %f && longitude <= %f && longitude >= %f",tl_coord.coordinate.latitude, br_coord.coordinate.latitude,tl_coord.coordinate.longitude,br_coord.coordinate.longitude];
                   
               }
               
        }
    
    return locationSuffix;
}


@end
