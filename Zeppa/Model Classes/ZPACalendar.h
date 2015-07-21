//
//  ZPACalendar.h
//  Zeppa
//
//  Created by Milan Agarwal on 06/09/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    
    CalendarTypeiOS = 0,
    CalendarTypeGoogle
    
}CalendarType;

@interface ZPACalendar : NSObject<NSCoding>

@property (nonatomic, assign) CalendarType calendarType;
///This can be of either GTLCalendarCalendarListEntry type for Google calendar or it can be of EKCalendar type for iOS calendar
@property (nonatomic, strong) id calendar;

///This will contains object of class ZPAEvent or may be google or ios event
///@todo Have to figure out the good way to handle ios and google events
///Milan-->Decided to use the arrSyncedCalendarsEvents array in ZPAAppData class, instead of below property, which contains all the events of the synced calendars and will be refreshed whenever the calendars to be synced is changed or at regular synchronization interval.
//@property (nonatomic, strong) NSMutableArray * arrEvents;

@property (nonatomic, assign) BOOL shouldBeSynced;


//@property (nonatomic, strong) NSString * calendarId;
//@property (nonatomic, strong) NSString * kind;
//@property (nonatomic, strong) NSString * description;
//@property (nonatomic, strong) NSString * summary;
//
/////Next sync token and page token for incremental syncing of Calendar
//@property (nonatomic, strong) NSString          *nextSyncTokenForCalendar;


@end
