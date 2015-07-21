//
//  ZPAUserDefault.m
//  Zeppa
//
//  Created by Dheeraj on 10/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAUserDefault.h"

@implementation ZPAUserDefault

+(void)storedObject:(id)object withKey:(NSString *)key{
    
    
    if ([object isKindOfClass:[NSData class]] || [object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSDate class]] || [object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:object forKey:key];
        [userDefault synchronize];
        NSLog(@"Object is successfully stored in UserDefault %@",key);
        
    }else{
        NSLog(@"Object can't be stored in UserDefault");
    }
    
}
+(id)getValueFromUserDefaultUsingKey:(NSString *)key{
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:key]) {
        return [userDefault objectForKey:key];
    }
    return nil;
    
}
+(void)removeObjectUsingKey:(NSString *)key{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault objectForKey:key]) {
        [userDefault removeObjectForKey:key];
        [userDefault synchronize];
    }else{
        NSLog(@"Object does not exist in UserDefault %@",key);
    }
}
+(void)clearUserDefault{
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    if(appDomain){
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    }
}
+(BOOL)isValueExistsForKey:(NSString *)key{
    
    NSUserDefaults *userDafault = [NSUserDefaults standardUserDefaults];
    return ([userDafault objectForKey:key])?YES:NO;
    
}
@end