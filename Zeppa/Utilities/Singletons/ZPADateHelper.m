//
//  HJ_DateHelper.m
//  HealthJournal
//
//  Created by Milan Agarwal on 28/07/14.
//  Copyright (c) 2014 Surendra Patle. All rights reserved.
//

#import "ZPADateHelper.h"

static ZPADateHelper *dateHelper;

@interface ZPADateHelper ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation ZPADateHelper
+(ZPADateHelper *)sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateHelper = [[ZPADateHelper alloc]init];
    });
    return dateHelper;
}

-(instancetype)init
{
    if (self = [super init]) {
        self.dateFormatter = [[NSDateFormatter alloc]init];
        [self.dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return  self;
}

-(NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)strDateFormat
{
    NSDate *date = nil;
    
    [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    if (strDate) {
        if (strDateFormat) {
            [self.dateFormatter setDateFormat:strDateFormat];

        }
        
        date = [self.dateFormatter dateFromString:strDate];

    }
    return  date;
}


-(NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)strDateFormat
{
    NSString *strDate = nil;
    
    [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    if (date) {
        if (strDateFormat) {
            [self.dateFormatter setDateFormat:strDateFormat];
        }
        strDate = [self.dateFormatter stringFromDate:date];
    }
    
    return strDate;
}

 //[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

-(NSString *)convertDateToUTCTimeZoneFromDate:(NSString *)date withFormat:(NSString *)strdateFormat{
    
    NSString *strDate=nil;
    NSDate *dateTime=nil;
    if(date){
         [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [self.dateFormatter setDateFormat:strdateFormat];
        
        dateTime=[self.dateFormatter dateFromString:date];
        
       [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        if(strdateFormat){
            [self.dateFormatter setDateFormat:strdateFormat];
        }
        strDate=[self.dateFormatter stringFromDate:dateTime];
    }
    return strDate;
}


-(NSDate *)dateFromString:(NSString *)strDate withFormat:(NSString *)strDateFormat andTimeZone:(NSString *)timeZoneName
{
    NSDate *date = nil;
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    [self.dateFormatter setTimeZone:timeZone];
    [self.dateFormatter setDateFormat:strDateFormat];
    NSDate *sourceDate = [self.dateFormatter dateFromString:strDate];
    
    NSString *strSourceDateFormat = @"yyyy-MM-dd HH:mm:ssZ";
    [self.dateFormatter setDateFormat:strSourceDateFormat];
    NSString *strSourceDate = [self.dateFormatter stringFromDate:sourceDate];

    [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    if (strSourceDate) {
        if (strSourceDateFormat) {
            [self.dateFormatter setDateFormat:strSourceDateFormat];
            
        }
        
        date = [self.dateFormatter dateFromString:strSourceDate];
    }
    return  date;
}


//-(NSString *)convertUTCTimeDateToLocalTimeZone:(NSDate *)date withFormat:(NSString *)strDateFormmat{
//    
//    NSString *strDate=nil;
//    NSDate *dateTime=nil;
//    if(date){
//       // dateTime=[self.dateFormatter dateFromString:date];
//        
//       // [self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//        
//        [self]
//        if(strdateFormat){
//            [self.dateFormatter setDateFormat:strdateFormat];
//        }
//        strDate=[self.dateFormatter stringFromDate:dateTime];
//        
//    }
//    return strDate;
//    
//    
//}


-(NSDate*)removeTimeComponent:(NSDate*)date{
   
    [self.dateFormatter setCalendar: [NSCalendar currentCalendar]];
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd 00:00"];
    
    NSString * dateString = [self.dateFormatter stringFromDate:date];
  //  [self.dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss z"];
    
  //  return [self.dateFormatter dateFromString:[dateString stringByAppendingString:@" +0000"]];
    return [self.dateFormatter dateFromString:dateString];
}




- (NSDate*)get1WeekBackDateForDate:(NSDate*)date{
    
    NSCalendar *currentCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    
    [componentsToSubtract setDay:-7];
    
    NSDate *beginningOfWeek = [currentCalendar dateByAddingComponents:componentsToSubtract
                                                               toDate:date options:0];
    
    return [self removeTimeComponent:beginningOfWeek];
}

-(NSDate*)removeMonth:(int)n fromDate:(NSDate*)date{
    NSCalendar *currentCalendar = [[NSLocale currentLocale] objectForKey:NSLocaleCalendar];
    
    
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setMonth: -n];
    NSDateFormatter *dFormatter = [[NSDateFormatter alloc] init];
    [dFormatter setLocale:[NSLocale currentLocale]];
    [dFormatter setCalendar:[NSCalendar currentCalendar]];
    [dFormatter setDateFormat:@"d"];
    int d = [[dFormatter stringFromDate:date] intValue];
    [componentsToSubtract setDay:1-d];
    
    
    
    NSDate *beginningOfWeek = [currentCalendar dateByAddingComponents:componentsToSubtract
                                                               toDate:date options:0];
    
    
    
    return [self removeTimeComponent:beginningOfWeek];
}

-(NSDate *)get3MBackDateFromDate:(NSDate*)date{
    
    
    NSDate *threeMothBackDate = [self removeMonth:3 fromDate:date];
    
    
    
    return [self removeTimeComponent:threeMothBackDate];
    
}


-(NSDate *)get1MBackDateFromDate:(NSDate*)date{
    
    
    NSDate *oneMonthBackDate = [self removeMonth:1 fromDate:date];
    
    
    
    return [self removeTimeComponent:oneMonthBackDate];
    
}
-(BOOL)isCurrentDateSundayInDateComponent:(NSDateComponents *)dateComponent
{
    
    NSDate *date =[[NSCalendar currentCalendar]dateFromComponents:dateComponent];
    _dateFormatter.dateFormat=@"EEE";
    NSString *weekDay=[_dateFormatter stringFromDate:date];
    if ([weekDay rangeOfString:@"Sun"].location!=NSNotFound) {
        
        return YES;
    }
    return NO;
    
}

-(BOOL)isCurrentDateTodayInDateComponent:(NSDateComponents *)dateComponent
{
    
    NSDate *date =[[NSCalendar currentCalendar]dateFromComponents:dateComponent];
    _dateFormatter.dateFormat=@"yyyy-MM-dd";
    NSString *weekDay=[_dateFormatter stringFromDate:date];
    NSLog(@"%@",weekDay);
    if ([weekDay isEqualToString:[self stringFromDate:[NSDate date] withFormat:@"yyyy-MM-dd"]]) {
        
        return YES;
    }
    return NO;
    
}

-(NSDate *)dateFromDate:(NSDate *)strDate withFormat:(NSString *)strDateFormat{
    
    
    NSDate *date = nil;
    
    [self.dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    if (strDate) {
        if (strDateFormat) {
            [self.dateFormatter setDateFormat:strDateFormat];
            
        }
        date = [self.dateFormatter dateFromString:[self.dateFormatter stringFromDate:strDate]];
        
    }
    return  date;
}
+(long long)currentTimeMillis{
    
    return (long long)([[NSDate date]timeIntervalSince1970]*1000.0);
}

-(NSString *)getEventTimeDuration:(NSNumber *)startTime withEndTime:(NSNumber *)endTime{
    
       
    NSString * eventDuration = [NSString stringWithFormat:@"%@ - %@",[self changeTimeAndFindTimeInterval:startTime],[self changeTimeAndFindTimeInterval:endTime]];
    
    return eventDuration;
}


-(NSString *)changeTimeAndFindTimeInterval:(NSNumber *)inputTime{
    
    NSTimeInterval interval;
    NSString * timeToDisplayString;
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    NSDate *yesterday = [NSDate dateWithTimeInterval:-(24*60*60) sinceDate:[NSDate date]];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    
    [dateformate setDateFormat:@"dd/MM/YYYY"];
    
    NSString * todayStr= [dateformate stringFromDate:[NSDate date]];
    
    NSString * tommorowStr = [dateformate stringFromDate:tomorrow];
    NSString * yesterdayStr = [dateformate stringFromDate:yesterday];
    
    long long currentTimeInMills = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentTimeInMills/1000];
    
    
    double inputChangedTime = [inputTime doubleValue];
    
    
    NSDate * inputDate = [NSDate dateWithTimeIntervalSince1970:inputChangedTime/1000];
    
    NSDate *inputTempDate = [self dateFromDate:inputDate withFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *currTempDate = [self dateFromDate:currentDate withFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *inputStr = [dateformate stringFromDate:inputDate];
    
    //NSString *endDateStr= [[ZPADateHelper sharedHelper]stringFromDate:endDate withFormat:@"dd-MM-yyyy hh:mm a"];
    
    interval = [currTempDate timeIntervalSinceDate:inputTempDate];
    int hours = (int)interval / 3600;
    int minutes = (interval - (hours*3600)) / 60;
    
    minutes = minutes + (hours*60);
    
    if ([inputStr isEqualToString:todayStr]) {
        
        if (minutes >=0 ) {
            
            if (minutes<1) {
                timeToDisplayString = [NSString stringWithFormat:@"Right Now"];
            }else if (minutes<3){
                timeToDisplayString = [NSString stringWithFormat:@"A few moments ago"];
            }else if (minutes<30){
                timeToDisplayString = [NSString stringWithFormat:@"%d minutes ago",minutes];
            }else{
                timeToDisplayString = [self stringFromDate:inputDate withFormat:@" hh:mm a"];
            }
            
        }else{
            minutes *= -1;
            if (minutes<1) {
                timeToDisplayString = [NSString stringWithFormat:@"Right Now"];
            }else if (minutes<3){
                timeToDisplayString = [NSString stringWithFormat:@"A few moments from now"];
            }else if (minutes<30){
                timeToDisplayString = [NSString stringWithFormat:@"%d minutes from now",minutes];
            }else{
                timeToDisplayString = [self stringFromDate:inputDate withFormat:@" hh:mm a"];
            }
        }
    }else if([inputStr isEqualToString:tommorowStr]){
        
        timeToDisplayString = [NSString stringWithFormat:@"Tomorrow %@",[self stringFromDate:inputDate withFormat:@"hh:mm a"]];
        
    }else if([inputStr isEqualToString:yesterdayStr]){
        
        timeToDisplayString = [NSString stringWithFormat:@"Yesterday %@",[self stringFromDate:inputDate withFormat:@"hh:mm a"]];
        
    }else if ([inputTime longLongValue] - currentTimeInMills < (1000 * 60 * 60 * 24 * 7) ){
        
        timeToDisplayString = [NSString stringWithFormat:@"%@ %@",[self stringFromDate:inputDate withFormat:@"EEEE"],[self stringFromDate:inputDate withFormat:@"hh:mm a"]];
        
    }else{
        timeToDisplayString = [self stringFromDate:inputDate withFormat:@"MM/dd/yyyy hh:mm a"];
    }
    return timeToDisplayString;
}

@end
