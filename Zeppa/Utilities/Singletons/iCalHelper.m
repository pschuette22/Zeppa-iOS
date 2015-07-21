//
//  iCalHelper.m
//  iCalDemo
//
//  Created by Milan Agarwal on 04/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "iCalHelper.h"

static iCalHelper *eventStoreHelper;
@interface iCalHelper()
@end

@implementation iCalHelper

//****************************************************
#pragma mark - Life Cycle
//****************************************************

-(id)init
{
    if (self = [super init]) {
        self.eventStore = [[EKEventStore alloc]init];
            }
    return self;
}


//****************************************************
#pragma mark - Public Interface
//****************************************************

+(instancetype)sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!eventStoreHelper) {
            eventStoreHelper = [[iCalHelper alloc]init];
            
        }
    });
    return eventStoreHelper;
}






@end
