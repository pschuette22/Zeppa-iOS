//
//  ZPAFetchMyEventTags.m
//  Zeppa
//
//  Created by Dheeraj on 17/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAFetchMyEventTags.h"
#import "ZPAZeppaEventTagSingleton.h"

@implementation ZPAFetchMyEventTags

-(void)executeZeppaApi{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    [[ZPAZeppaEventTagSingleton sharedObject] executeEventTagListQueryWithCursor:nil];
    });
    
}
@end
