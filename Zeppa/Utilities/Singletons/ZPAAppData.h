//
//  ZPAAppData.h
//  Zeppa
//
//  Created by Milan Agarwal on 07/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPACalendar.h"
#import "ZPAEvent.h"
@class GTLServiceTicket;
@class GTLCalendarCalendar;

//****************************************************
#pragma mark - Block Declaration
//****************************************************

typedef void(^ZPACalendarListCompletionHandler)(NSArray *arrCalendars, NSError *error);

///Create ZPAEndpointService Generic  Completion Block
typedef void(^ZPAGenericEndpointServiceCompletionBlock) (GTLServiceTicket *ticket, id object, NSError *error);

typedef void(^ZPARefreshSyncedCalendarsEventsCompletionHandler)(NSArray *arrEvents, NSError *googleEventsRefreshError, NSError *iOSEventsRefreshError);



///This is a singleton class which will contain the app specific data to be used for complete session of the app.
@interface ZPAAppData : NSObject

///The logged in Zeppa User object
@property (nonatomic, strong)ZPAMyZeppaUser *loggedInUser;

///The Default user image to be used throughout the app
@property (nonatomic, strong) UIImage *defaultUserImage;

///Contains List of synced Google Calendars wrapped in ZPACalendar object
@property (nonatomic, strong) NSMutableArray *arrGoogleSyncedCalendars;

///Contains List of synced iOS Calendars wrapped in ZPACalendar object
@property (nonatomic, strong) NSMutableArray *arriOSSyncedCalendars;

///Will hold the events of all the synced calendars in the app
@property (nonatomic, strong) NSMutableArray *arrSyncedCalendarsEvents;

///Will hold the events of the "Zeppa Events" calendar on Google
@property (nonatomic, strong) NSMutableArray *arrZeppaEventsCalendarEvents;

///This is the Google Calendar ID for Zeppa Events Calendar created on Google
@property (nonatomic, strong) NSString *zeppaEventsCalendarId;


@property (nonatomic, strong)NSMutableArray *arrGoogleCalendars;
@property (nonatomic, strong)NSMutableArray *arriOSCalendars;
//@property (nonatomic, copy)ZPARefreshSyncedCalendarsEventsCompletionHandler refreshSyncedCalendarsEventsCompletionHandler;

@property (nonatomic, strong)NSError *googleEventsRefreshError;
@property (nonatomic, strong)NSError *iOSEventsRefreshError;
///This is for Recurrence event in Google Calendar
@property (nonatomic, strong) NSMutableArray *arrRecurrenceEvents;
@property (nonatomic, strong) NSMutableDictionary *dicRecurrenceEventsForMonthFlow;
@property (nonatomic, strong) NSMutableDictionary *dicRecurrenceEventsForDayFlow;

/*!
 * @description Creates the Singleton object of this class
 * @return will always return the Singleton object.
 */
+(instancetype)sharedAppData;



/*!
 * @description It will clear the old Google Calendar list and fetch the new Google Calendar list each time it is called.
 * @param completion will return the array of ZPACalendar object if successful and error as nil otherwise it will return an empty array object with error object containing the reason.
  */
-(void)getGoogleCalendarListWithCompletionhandler:(ZPACalendarListCompletionHandler)completion;


/*!
* @description It will clear the old iOS Calendar list and fetch the new iOS Calendar list each time it is called.
* @param completion will return the array of ZPACalendar object if successful and error as nil otherwise it will return an empty array object with error object containing the reason.
*/
-(void)getiOSCalendarListWithCompletionHandler:(ZPACalendarListCompletionHandler)completion;


/*!
 * @description It will create a calendar on Google calendar of the authenticated user.
 * @param calendar The GTLCalendarCalendar object with summary field provided as required property.
 * @param completion The completion handler to be called asynchronously which will pass the GTLCalendarCalendar object created on Google calendar or error if any occurs.
 * @return GTLServiceTicket object to handle the request any time.
 */
-(GTLServiceTicket *)createGoogleCalendarWithCalendar:(GTLCalendarCalendar *)calendar completionHandler:(ZPAGenericEndpointServiceCompletionBlock)completion;


/*!
 * @description Will fetch all the Google Synced Calendar events listed under arrGoogleSyncedCalendars and all the iOS Synced Calendar events listed under arriOSSyncedCalendars and save them in arrSyncedCalendarsEvents
 * @param completion An asynchronous block to be called once all the events are fetched and will return the array of fetched events if successful otherwise an error object.
*/
-(void)refreshSyncedCalendarsEventsWithCompletionHandler:(ZPARefreshSyncedCalendarsEventsCompletionHandler)completion;





-(void)getAllEventsFromSyncedGoogleCalendarsWithCompletionHandler:(ZPAGenericEndpointServiceCompletionBlock)completion;

/*!
 * @description Will fetch the GTLCalendarCalendarListEntry object with calendarid
 * @param calendarId The google calendar identifier of the calendar
 * @param completion An asynchronous block to be called once the response arrives for the query.
 */
-(GTLServiceTicket *)getCalendarListEntryWithCalendarId:(NSString *)calendarId andCompletionhandler:(ZPAGenericEndpointServiceCompletionBlock)completion;


/*!
 * @description Will fetch the GTLCalendarEvent object with calendarid
 * @param calendarId The google calendar identifier of the calendar
 * @param completion An asynchronous block to be called once the response arrives for the query.
 */
-(GTLServiceTicket *)getGoogleCalendarEventsListWithCalendarId:(NSString *)calendarId andCompletionhandler:(ZPAGenericEndpointServiceCompletionBlock)completion;


@end
