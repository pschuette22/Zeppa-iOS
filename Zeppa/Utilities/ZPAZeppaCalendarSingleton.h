//
//  ZPAZeppaCalendarSingleton.h
//  Zeppa
//
//  Created by Faran on 02/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLCalendarCalendarListEntry.h"

@class GTLCalendarCalendarList;

@interface ZPAZeppaCalendarSingleton : NSObject

@property (nonatomic, strong) NSMutableArray *allEventList;

+(ZPAZeppaCalendarSingleton *)sharedObject;
+(void)resetObject;

-(void)clear;
-(NSArray *)getAllGoogleCalendar;
-(NSArray *)getAllGoogleSyncCalendar;
-(void)saveCalendarInUserDefault;
-(void)CallCalendarListGoogleApi;
-(NSArray *)getCalendarSummaryArray;
-(void)storeAllEvents;



@end
