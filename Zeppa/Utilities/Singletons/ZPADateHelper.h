//
//  HJ_DateHelper.h
//  HealthJournal
//
//  Created by Milan Agarwal on 28/07/14.
//  Copyright (c) 2014 Surendra Patle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPADateHelper : NSObject

+(ZPADateHelper *)sharedHelper;

-(NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)strDateFormat;
-(NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)strDateFormat;
-(NSString *)convertDateToUTCTimeZoneFromDate:(NSString *)date withFormat:(NSString *)strdateFormat;
-(NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)strDateFormat andTimeZone:(NSString *)timeZoneName;
-(BOOL)isCurrentDateSundayInDateComponent:(NSDateComponents *)dateComponent;
-(BOOL)isCurrentDateTodayInDateComponent:(NSDateComponents *)dateComponent;
-(NSDate *)dateFromDate:(NSDate *)strDate withFormat:(NSString *)strDateFormat;

-(NSString *)getEventTimeDuration:(NSNumber *)startTime withEndTime:(NSNumber *)endTime;
-(NSString *)changeTimeAndFindTimeInterval:(NSNumber *)inputTime;

-(NSDate *)get3MBackDateFromDate:(NSDate*)date;
-(NSDate *)get1MBackDateFromDate:(NSDate*)date;
-(NSDate*)removeMonth:(int)n fromDate:(NSDate*)date;
- (NSDate*)get1WeekBackDateForDate:(NSDate*)date;
-(NSDate*)removeTimeComponent:(NSDate*)date;

+(long long)currentTimeMillis;
@end
