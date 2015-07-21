//
//  ZPAEvent.h
//  Zeppa
//
//  Created by Milan Agarwal on 06/09/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import<EventKit/EventKit.h>

#import "GTLCalendarEvent.h"



typedef enum{
    
    CalendarEventTypeiOS = 0,
    CalendarEventTypeGoogle
    
}CalendarEventType;

@interface ZPAEvent : NSObject

///To identify whether the event is of iOS calendar or From Google Calendar
@property (nonatomic, assign) CalendarEventType eventType;

///This can be of type GTLCalendarEvent if its of CalendarEventTypeGoogle otherwise it will be of type EKEvent if its of CalendarEventTypeiOS
@property (nonatomic, strong) id event;

///The unique idenfier of the calendar to which this event belongs to.
@property (nonatomic, strong) NSString *parentCalendarId;

@property (nonatomic, strong) NSString *calendarSummary;

//@property (nonatomic, strong) NSString * eventId;
//@property (nonatomic, strong) NSString * kind;
//@property (nonatomic, strong) NSString * description;
//@property (nonatomic, strong) NSString * summary;
//@property (nonatomic, strong) NSString * parentCalendarSummary;
//@property (nonatomic, strong) NSString * iCalUID;
//@property (nonatomic, strong) NSString * location;
@property (nonatomic, strong) NSDate * startDateTime;
@property (nonatomic, strong) NSDate * endDateTime;
//@property (nonatomic, strong) NSDictionary * dictCreatorInfo;
//@property (nonatomic, strong) NSDictionary * dictOrganiserInfo;
//@property (nonatomic, strong) NSArray * arrAttendeesInfo;
@property (nonatomic, assign) BOOL isAllDay;

-(instancetype)initWithGoogleEvent:(GTLCalendarEvent *)event;
-(instancetype)initWithEkEvent:(EKEvent *)event;
@end
