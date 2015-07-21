//
//  ZPAConstants.h
//  Zeppa
//
//  Created by Milan Agarwal on 29/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPAConstants : NSObject


//****************************************************
#pragma mark - Google Plus Authentication Keys
//****************************************************

extern NSString *const kZeppaGooglePlusClientIdKey;
extern NSString *const kZeppaGooglePlusClientSecretKey;
extern NSString *const kZeppaGooglePlusWebClientIdKey;
extern NSString *const kZeppaKeychainItemNameKey;
extern NSString *const kZeppaGoogleCalendarArrayKey;
//****************************************************
#pragma mark - Zeppa Calendar Name
//****************************************************
extern NSString *const kZeppaEventsCalendarNameKey;
extern NSString *const kZeppaEventsCalendarColorCodeKey;

//****************************************************
#pragma mark - Common API Keys
//****************************************************
extern NSString *const kZeppaGoogleAPINextSyncTokenKey;
extern NSString *const kZeppaGoogleAPINextPageTokenKey;
extern NSString *const kZeppaGoogleAPIItemsKey;
extern NSString *const kZeppaGoogleAPIKindKey;

//****************************************************
#pragma mark - User Login keys
//****************************************************

extern NSString *const kZeppaUserIsLoggedInKey;
///This will be used to store the logged in user Google plus id
extern NSString *const kZeppaLoggedInUserGooglePlusIdKey;
extern NSString *const kCurrentZeppaUserId;
extern NSString *const kCurrentZeppaUserEmail;

//****************************************************
#pragma mark - https://www.googleapis.com/plus/v1/people/me Response API Keys
//****************************************************
extern NSString *const kZeppaGooglePlusIdKey;
extern NSString *const kZeppaGooglePlusEmailsKey;
extern NSString *const kZeppaGooglePlusEmailsValueKey;
extern NSString *const kZeppaGooglePlusEmailsTypeKey;
extern NSString *const kZeppaGooglePlusNameKey;
extern NSString *const kZeppaGooglePlusNameFamilyNameKey;
extern NSString *const kZeppaGooglePlusNameGivenNameKey;
extern NSString *const kZeppaGooglePlusImageKey;
extern NSString *const kZeppaGooglePlusImageUrlKey;
extern NSString *const kZeppaGooglePlusGenderKey;


//***************************************************************************
#pragma mark - https://www.googleapis.com/calendar/v3/users/me/calendarList
//***************************************************************************
extern NSString *const kZeppaCalendarListIdKey;
extern NSString *const kZeppaCalendarListDescriptionKey;
extern NSString *const kZeppaCalendarListSummaryKey;

//*********************************************************************************
#pragma mark - https://www.googleapis.com/calendar/v3/calendars/calendarId/events
//*********************************************************************************
extern NSString *const kZeppaEventsIdKey;
extern NSString *const kZeppaEventsSummaryKey;
extern NSString *const kZeppaEventsDescriptionKey;
extern NSString *const kZeppaEventsLocationKey;
extern NSString *const kZeppaEventsCreatorKey;
extern NSString *const kZeppaEventsOrganizerKey;
extern NSString *const kZeppaEventsAttendeesKey;
extern NSString *const kZeppaEventsStartDateKey;
extern NSString *const kZeppaEventsEndDateKey;
extern NSString *const kZeppaEventsDateTimeKey;
extern NSString *const kZeppaEventsDateKey;
extern NSString *const kZeppaEventsTimeZoneKey;
extern NSString *const kZeppaEventsiCalUIDKey ;
extern NSString *const kZeppaEventsSequenceKey;


//****************************************************
#pragma mark - Notifications Keys
//****************************************************
extern NSString *const kZeppaSettingSyncCalendarKey;
extern NSString *const kZeppaSettingNotificationKey;
extern NSString *const kZeppaSettingVibrateKey;
extern NSString *const kZeppaSettingRingKey;
extern NSString *const kZeppaSettingMingleKey;
extern NSString *const kZeppaSettingStartedMingleKey;
extern NSString *const kZeppaSettingEventRecommendationsKey;
extern NSString *const kZeppaSettingEventInvitesKey;
extern NSString *const kZeppaSettingCommentsKey;
extern NSString *const kZeppaSettingEventCanceledKey;
extern NSString *const kZeppaSettingPeopleJoinKey;
extern NSString *const kZeppaSettingPeopleLeaveKey;
extern NSString *const kZeppaTagUpdateNotificationKey;
extern NSString *const kZeppaEventsUpdateNotificationKey;

extern NSString *const kzeppacalendarSync;

@end
