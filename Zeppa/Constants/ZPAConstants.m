//
//  ZPAConstants.m
//  Zeppa
//
//  Created by Milan Agarwal on 29/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAConstants.h"

@implementation ZPAConstants

//****************************************************
#pragma mark - Google Plus Authentication Keys
//****************************************************


//NSString *const kZeppaGooglePlusClientIdKey = @"994254449243-4nj1dthb9fgkuorlai6v3pbrgrlvv001.apps.googleusercontent.com";
//
//NSString *const kZeppaGooglePlusClientSecretKey = @"1ShuZnGIfYxJ5_fq3UquOk4z";

NSString *const kZeppaGooglePlusClientIdKey = @"587859844920-7eie3deskfrbhmkm800jarhbq95h7ejl.apps.googleusercontent.com";

NSString *const kZeppaGooglePlusClientSecretKey = @"GA9d_-d-EiDfcd5vNAXbfC4q";
NSString *const kZeppaGooglePlusRedirectURIKey  = @"urn:ietf:wg:oauth:2.0:oob";
NSString *const kZeppaGooglePlusWebClientIdKey = @"587859844920-jiqoh8rn4j8d0941vunu4jfdcl2huv4l.apps.googleusercontent.com";
NSString *const kZeppaKeychainItemNameKey = @"com.zeppamobile.zeppaios.GooglePlus";

NSString *const kZeppaGoogleCalendarArrayKey = @"googleCalendarArray";
//****************************************************
#pragma mark - Zeppa Calendar Name
//****************************************************
NSString *const kZeppaEventsCalendarNameKey = @"Zeppa Events";
NSString *const kZeppaEventsCalendarColorCodeKey = @"#33aaff";


//****************************************************
#pragma mark - Common API Keys
//****************************************************
NSString *const kZeppaGoogleAPINextSyncTokenKey          = @"nextSyncToken";
NSString *const kZeppaGoogleAPINextPageTokenKey          = @"nextPageToken";
NSString *const kZeppaGoogleAPIItemsKey                  = @"items";
NSString *const kZeppaGoogleAPIKindKey                   = @"kind";

//****************************************************
#pragma mark - Zeppa API Values
//****************************************************

NSString *const kZeppaAPISenderId = @"587859844920";


//****************************************************
#pragma mark - User Login keys
//****************************************************
NSString *const kZeppaUserIsLoggedInKey = @"userIsLoggedIn";
NSString *const kZeppaLoggedInUserGooglePlusIdKey = @"loggedInUserGooglePlusId";
NSString *const kCurrentZeppaUserEmail = @"logedInEmailId";
NSString *const kCurrentZeppaUserId = @"logedInZeppaUserId";

//**************************************************************************************
#pragma mark - https://www.googleapis.com/plus/v1/people/me Response API Keys
//**************************************************************************************
NSString *const kZeppaGooglePlusIdKey                   = @"id";
NSString *const kZeppaGooglePlusEmailsKey               = @"emails";
NSString *const kZeppaGooglePlusEmailsValueKey          = @"value";
NSString *const kZeppaGooglePlusEmailsTypeKey           = @"type";
NSString *const kZeppaGooglePlusNameKey                 = @"name";
NSString *const kZeppaGooglePlusNameFamilyNameKey       = @"familyName";
NSString *const kZeppaGooglePlusNameGivenNameKey        = @"givenName";
NSString *const kZeppaGooglePlusImageKey                = @"image";
NSString *const kZeppaGooglePlusImageUrlKey             = @"url";
NSString *const kZeppaGooglePlusGenderKey               = @"gender";

//***************************************************************************
#pragma mark - https://www.googleapis.com/calendar/v3/users/me/calendarList
//***************************************************************************
NSString *const kZeppaCalendarListIdKey                     = @"id";
NSString *const kZeppaCalendarListDescriptionKey            = @"description";
NSString *const kZeppaCalendarListSummaryKey                = @"summary";


//*********************************************************************************
#pragma mark - https://www.googleapis.com/calendar/v3/calendars/calendarId/events
//*********************************************************************************
NSString *const kZeppaEventsIdKey                     = @"id";
NSString *const kZeppaEventsSummaryKey                = @"summary";
NSString *const kZeppaEventsDescriptionKey            = @"description";
NSString *const kZeppaEventsLocationKey               = @"location";
NSString *const kZeppaEventsCreatorKey                = @"creator";
NSString *const kZeppaEventsOrganizerKey              = @"organizer";
NSString *const kZeppaEventsAttendeesKey              = @"attendees";
NSString *const kZeppaEventsStartDateKey              = @"start";
NSString *const kZeppaEventsEndDateKey                = @"end";
NSString *const kZeppaEventsDateTimeKey               = @"dateTime";
NSString *const kZeppaEventsDateKey                   = @"date";
NSString *const kZeppaEventsTimeZoneKey               = @"timeZone";
NSString *const kZeppaEventsiCalUIDKey                = @"iCalUID";
NSString *const kZeppaEventsSequenceKey               = @"sequence";


//****************************************************
#pragma mark - Notifications Keys
//****************************************************

NSString *const kZeppaSettingSyncCalendarKey              = @"syncCalendar";

 NSString *const kZeppaSettingNotificationKey             = @"notification";
 NSString *const kZeppaSettingVibrateKey                  = @"vibrateKey";
 NSString *const kZeppaSettingRingKey                     = @"ringKey";
 NSString *const kZeppaSettingMingleKey                   = @"mingleKey";
 NSString *const kZeppaSettingStartedMingleKey            = @"startedMingle";
 NSString *const kZeppaSettingEventRecommendationsKey     = @"eventRecommendations";
 NSString *const kZeppaSettingEventInvitesKey             = @"eventInvites";
 NSString *const kZeppaSettingCommentsKey                 = @"commentsKey";
 NSString *const kZeppaSettingEventCanceledKey            = @"eventCanceled";
 NSString *const kZeppaSettingPeopleJoinKey               = @"peopleJoin";
 NSString *const kZeppaSettingPeopleLeaveKey              = @"peopleLeave";
 NSString *const kZeppaTagUpdateNotificationKey           = @"tagNotification";
 NSString *const kZeppaEventsUpdateNotificationKey        = @"eventsNotification";

// notification calendar Synchronization Key

NSString *const kzeppacalendarSync                          = @"calendarSync";


//****************************************************
#pragma mark - Observer Keys
//****************************************************

NSString *const kObserveEventsChangedKey = @"observeEventsChanged";
NSString *const kObserveMinglersChangedKey = @"observeMinglersChanged";


@end
