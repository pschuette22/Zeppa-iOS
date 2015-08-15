//
//  ZPAUserDefault.h
//  Zeppa
//
//  Created by Dheeraj on 10/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPAUserDefault : NSObject

//StoredObject in userDefault with key
+(void)storedObject:(id)object withKey:(NSString *)key;
//get Data from userDefault with Key
+(id)getValueFromUserDefaultUsingKey:(NSString *)key;
//RemoveObject in userDefault with key
+(void)removeObjectUsingKey:(NSString *)key;
//clear all data in userDefault

+(BOOL)isValueExistsForKey:(NSString *)key;
+(void)clearUserDefault;

+(BOOL)doSendNotificationForType:(NSString*)type;

@end
