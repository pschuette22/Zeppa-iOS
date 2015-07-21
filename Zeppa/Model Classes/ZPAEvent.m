//
//  ZPAEvent.m
//  Zeppa
//
//  Created by Milan Agarwal on 06/09/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAEvent.h"
#import "ZPAStaticHelper.h"
#import "ZPADateHelper.h"
#import "GTLCalendarEvent.h"
#import <EventKit/EventKit.h>


@implementation ZPAEvent
-(instancetype)initWithGoogleEvent:(GTLCalendarEvent *)event{
    
    if (self=[super init]) {
        
        self.eventType = CalendarEventTypeGoogle;
        self.event = event;
        ///
        if(![[event JSON] objectForKey:@"recurringEventId"]){
            
            if ([[event JSON] objectForKey:@"recurrence"]){
                if (![ZPAAppData sharedAppData].arrRecurrenceEvents) {
                    [ZPAAppData sharedAppData].arrRecurrenceEvents=[NSMutableArray array];
                }
                [[ZPAAppData sharedAppData].arrRecurrenceEvents addObject:event];
            }
            
            
            ///Fetch Start Date
            NSDictionary *dictStartDate = [[event JSON] objectForKey:kZeppaEventsStartDateKey];
            if ([ZPAStaticHelper canUseWebObject:dictStartDate]) {
                ///Check for All-Day Event
                NSString *strStartDate = [dictStartDate objectForKey:kZeppaEventsDateKey];
                NSString *strStartDateTime = [dictStartDate objectForKey:kZeppaEventsDateTimeKey];
                
                if ([ZPAStaticHelper canUseWebObject:strStartDate]) {
                    self.isAllDay = YES;
                    //  strStartDate = [strStartDate app]
                    NSDate *startDateTime = [[ZPADateHelper sharedHelper]dateFromString:strStartDate withFormat:@"yyyy-MM-dd"];
                    NSLog(@"startdate %@",startDateTime);
                    if (startDateTime) {
                        self.startDateTime = startDateTime;
                    }
                }
                
                
                else if ([ZPAStaticHelper canUseWebObject:strStartDateTime]) {
                    NSDate *startDateTime = nil;
                    /*
                     NSString *timeZone = [dictStartDate objectForKey:kZeppaEventsTimeZoneKey];
                     //                                timeZone = @"America/Mendoza";
                     //                            strStartDateTime = @"2014-03-29 05:30:00";
                     if ([ZPAStaticHelper canUseWebObject:timeZone]) {
                     startDateTime = [[ZPADateHelper sharedHelper]dateFromString:strStartDateTime withFormat:@"yyyy-MM-dd HH:mm:ss" andTimeZone:timeZone];
                     }
                     else{
                     */
                    strStartDateTime = [strStartDateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    
                    startDateTime = [[ZPADateHelper sharedHelper]dateFromString:strStartDateTime withFormat:@"yyyy-MM-dd HH:mm:ssZ"];
                    /*
                     }
                     */
                    NSLog(@"startdate %@",startDateTime);
                    if (startDateTime) {
                        self.startDateTime = startDateTime;
                    }
                    
                    
                }
                
                
            }
            
            ///Fetch end Date
            NSDictionary *dictEndDate = [[event JSON] objectForKey:kZeppaEventsEndDateKey];
            if ([ZPAStaticHelper canUseWebObject:dictEndDate]) {
                
                ///Check for All-Day Event
                NSString *strEndDate = [dictStartDate objectForKey:kZeppaEventsDateKey];
                NSString *strEndDateTime = [dictEndDate objectForKey:kZeppaEventsDateTimeKey];
                
                if ([ZPAStaticHelper canUseWebObject:strEndDate]) {
                    self.isAllDay = YES;
                    //  strStartDate = [strStartDate app]
                    NSDate *endDateTime = [[ZPADateHelper sharedHelper]dateFromString:strEndDate withFormat:@"yyyy-MM-dd"];
                    NSLog(@"enddate %@",endDateTime);
                    if (endDateTime) {
                        self.endDateTime = endDateTime;
                    }
                }
                
                
                else if ([ZPAStaticHelper canUseWebObject:strEndDateTime]) {
                    NSDate *endDateTime = nil;
                    /*
                     NSString *timeZone = [dictEndDate objectForKey:kZeppaEventsTimeZoneKey];
                     //                                timeZone = @"America/Mendoza";
                     //                            strStartDateTime = @"2014-03-29 05:30:00";
                     if ([ZPAStaticHelper canUseWebObject:timeZone]) {
                     endDateTime = [[ZPADateHelper sharedHelper]dateFromString:strEndDateTime withFormat:@"yyyy-MM-dd HH:mm:ss" andTimeZone:timeZone];
                     }
                     else{
                     */
                    strEndDateTime = [strEndDateTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    
                    endDateTime = [[ZPADateHelper sharedHelper]dateFromString:strEndDateTime withFormat:@"yyyy-MM-dd HH:mm:ssZ"];
                    /*
                     }
                     */
                    NSLog(@"startdate %@",endDateTime);
                    if (endDateTime) {
                        self.endDateTime = endDateTime;
                    }
                    
                    
                }
                
                
            }
            
        }
        
    }
    return self;
}
-(instancetype)initWithEkEvent:(EKEvent *)event
{
    self.eventType = CalendarEventTypeiOS;
    self.event = event;
    if (self=[super init]) {
        if (event.isAllDay){
            if (event.startDate){
                self.startDateTime=event.startDate;
            }
            if (event.endDate){
                self.endDateTime=event.endDate;
            }
        }else{
            
            if (event.startDate){
                self.startDateTime=event.startDate;
                
            }
            if (event.endDate) {
                self.endDateTime=event.endDate;
            }
            
        }
        
    }
    
    
    return self;
}
@end
