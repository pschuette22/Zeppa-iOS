//
//  ZPALogHelper.h
//  Zeppa
//
//  Created by Peter Schuette on 8/15/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPALogHelper : NSObject

+(void) log:(NSString*)message fromClass:(NSObject*)clazz;
@end
