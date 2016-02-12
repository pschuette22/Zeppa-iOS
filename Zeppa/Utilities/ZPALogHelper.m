//
//  ZPALogHelper.m
//  Zeppa
//
//  Created by Peter Schuette on 8/15/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import "ZPALogHelper.h"

@implementation ZPALogHelper

// turn off logging when deployed
const BOOL DO_LOGGING = YES;
const int LABEL_COUNT = 1;

const NSString * const kLabelNames[] = {
    @"GoogleOAuth" //, @"FooBar"
};


/*!
 * @description Log helper method so we can quickly toggle classes that should log on and off without removing log messages
 */
+(void) log:(NSString*)message fromClass:(NSObject*)clazz{
    NSString *className = NSStringFromClass([clazz class]);
    
    if(DO_LOGGING){
        static NSArray* names;
        if(names == nil){
            names = [[NSArray alloc]initWithObjects:kLabelNames count: LABEL_COUNT];
        }
        
        if([names containsObject:className]){
            NSLog(@"%@",message);
        }
    }
}
@end
