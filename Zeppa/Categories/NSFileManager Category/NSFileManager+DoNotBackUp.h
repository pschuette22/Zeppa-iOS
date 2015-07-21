//
//  NSFileManager+DoNotBackUp.h
//  iBuildMart
//
//  Created by Kalpna Mishra on 18/06/14.
//  Copyright (c) 2014 Kalpna Mishra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (DoNotBackUp)
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;
@end
