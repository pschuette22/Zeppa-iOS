//
//  ZPAApplication.m
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAApplication.h"
#import "ZPAMyZeppaUser.h"
#import "ZPADeviceInfo.h"
#import "ZPAUserDefault.h"

#import "GTLZeppauserendpointZeppaUserInfo.h"
#import "GTLZeppauserendpointZeppaUser.h"
#import "GTLCalendarCalendarListEntry.h"


@implementation ZPAApplication{
    
    ZPAMyZeppaUser *loggedInUser;
}
+(ZPAApplication *)sharedObject{
    
    static ZPAApplication *app;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        app = [[ZPAApplication alloc] init];
    });
    return app;
}
-(void)initizationsWithCurrentUser:(ZPAMyZeppaUser *)currentUser{
    
    loggedInUser = currentUser;
  
    ///// Set User Default
    [self setLoggedInUserIdInUserDefault];
    [self setLoggedInAccountEmailInUserDefault];
    
    
    
    
    //Get all mingle for this user
    [self fetchInitialMinglers];
    
    // Load this users event tags
    [self fetchMyEventTags];
    
    
    ///Update or Insert Device of current user
    [[ZPADeviceInfo sharedObject] setLoginDeviceForUser:loggedInUser];
    
    ///Get all SyncGoogleCalendar
   // [self setGoogleSyncCalendarIntoArray];
    
    [self setDefaultValueOnSettingScreenIfNeeded];
    
    //Get all Events for this user
    [self fetchInitialEvents];
    
}
-(void)setLoggedInUserIdInUserDefault{
    
    [ZPAUserDefault storedObject:[NSString stringWithFormat:@"%@",loggedInUser.endPointUser.identifier] withKey:kCurrentZeppaUserId];
    
    // [ZPAUserDefault storedObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithLongLong:5107179300323328]] withKey:kCurrentZeppaUserId];
    
}
-(void)setLoggedInAccountEmailInUserDefault{
    
    [ZPAUserDefault storedObject:loggedInUser.endPointUser.userInfo.googleAccountEmail withKey:kCurrentZeppaUserEmail];
}
-(void)fetchInitialMinglers{
    _fetchIntialMinglers = [[ZPAFetchInitialMinglers alloc]init];
    [_fetchIntialMinglers executeZeppaApi];
   
}
-(void)fetchMyEventTags{
    _fetchMyEventTag = [[ZPAFetchMyEventTags alloc]init];
    [_fetchMyEventTag executeZeppaApi];
}
-(void)fetchInitialEvents{
    _fetchInitialEvent = [[ZPAFetchInitialEvents alloc]init];
    [_fetchInitialEvent executeZeppaApi];
    
}
-(void)setGoogleSyncCalendarIntoArray{
    
    NSMutableArray *calendarArray  = [NSMutableArray array];
    BOOL isSync = YES;
    
    [[ZPAAppData sharedAppData]getGoogleCalendarListWithCompletionhandler:^(NSArray *arrCalendars, NSError *error) {
        
        if(arrCalendars.count>0){
            
            for (ZPACalendar * googleCalendar in arrCalendars) {
                GTLCalendarCalendarListEntry *calendar = googleCalendar.calendar;
                
                if ([calendar.summary length]>0) {
                    
                    NSMutableDictionary *calendarDictionary= [NSMutableDictionary dictionaryWithObjectsAndKeys:calendar.summary,@"summary",@(isSync),@"sync", nil];
                    [calendarArray addObject:calendarDictionary];
                    
                }
                
            }
            
            NSLog(@"calenddars %@",calendarArray);
            
            
            //NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:arrCalendars];
            //[ZPAUserDefault storedObject:encodedObject withKey:kZeppaGoogleCalendarArrayKey];
          [ZPAAppData sharedAppData].arrGoogleSyncedCalendars = [arrCalendars mutableCopy];
            
        [[ZPAAppData sharedAppData]getAllEventsFromSyncedGoogleCalendarsWithCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            
            NSLog(@"evetn %@",object);
            
        }];
            
        }
    }];
    
}
-(void)setDefaultValueOnSettingScreenIfNeeded{
    
    
    if(![ZPAUserDefault isValueExistsForKey:kZeppaSettingNotificationKey]){
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingVibrateKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingRingKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingMingleKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingStartedMingleKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingEventRecommendationsKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingEventInvitesKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingCommentsKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingEventCanceledKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingPeopleJoinKey];
        [dic setObject:[NSNumber numberWithBool:YES] forKey:kZeppaSettingPeopleLeaveKey];
        [ZPAUserDefault storedObject:dic withKey:kZeppaSettingNotificationKey];

    }
}
@end
