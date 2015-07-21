//
//  NSFileManager+DoNotBackUp.m
//  iBuildMart
//
//  Created by Kalpna Mishra on 18/06/14.
//  Copyright (c) 2014 Kalpna Mishra. All rights reserved.
//

#import "NSFileManager+DoNotBackUp.h"
#include <sys/xattr.h>

@implementation NSFileManager (DoNotBackUp)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if (&NSURLIsExcludedFromBackupKey == nil) { // iOS <= 5.0.1
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    } else { // iOS >= 5.1
        NSError *error = nil;
        [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return error == nil;
    }
}

@end
