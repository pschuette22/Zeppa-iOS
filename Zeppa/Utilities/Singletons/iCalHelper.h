//
//  iCalHelper.h
//  iCalDemo
//
//  Created by Milan Agarwal on 04/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
@import EventKit;

@interface iCalHelper : NSObject

@property (nonatomic, assign)BOOL isAccessGranted;
@property (nonatomic, strong)EKEventStore *eventStore;

+(instancetype)sharedHelper;

@end
