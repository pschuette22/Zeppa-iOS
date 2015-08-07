//
//  ZPAAuthenticatonHandler.m
//  Zeppa
//
//  Created by Milan Agarwal on 06/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAAuthenticatonHandler.h"
#import "ZPAZeppaCalendarSingleton.h"
#import "ZPACalendarModel.h"
#import "ZPAAppDelegate.h"
#import "ZPAUserDefault.h"
#import "ZPADeviceInfo.h"
#import "ZPALoginVC.h"
#import "ZPAAppData.h"
#import "ZPAZeppaEventTagSingleton.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPANotificationSingleton.h"

#import "ZPASwapperVC.h"


#import "GTLCalendar.h"


static ZPAAuthenticatonHandler *authHandler;


typedef void(^fetchGoogleCalendar)(BOOL success,NSError *errr);

@interface ZPAAuthenticatonHandler ()<GPPSignInDelegate>
@property (nonatomic, strong, readwrite) GTMOAuth2Authentication *auth;
@property (nonatomic, getter=isFirstTime) BOOL firstTime;
@end

@implementation ZPAAuthenticatonHandler{
    
}
///**********************************************
#pragma mark - Singleton Method
///**********************************************
+(instancetype)sharedAuth
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!authHandler) {
            authHandler = [[ZPAAuthenticatonHandler alloc]init];
        }
    });
    return authHandler;
}
///**********************************************
#pragma mark - Auth Method
///**********************************************
-(GTMOAuth2Authentication *)auth{
    
    if (_auth) {
        
    return _auth;
    }
    _auth = [[GPPSignIn sharedInstance] authentication];
    return _auth;
}

+(BOOL)isAuthValid:(GTMOAuth2Authentication *)auth
{
    return ((auth != nil) && [auth canAuthorize]);
}

///**********************************************
#pragma mark - Google Login Authentication
///**********************************************
-(void)signInWithGooglePlus{
    
    if([[GPPSignIn sharedInstance] authentication])
    {
//        if ([_delegate respondsToSelector:@selector(loginWithGoogleAuthSuccessfully:)]) {
//            
//            [_delegate loginWithGoogleAuthSuccessfully:YES];
//        }
//        // fetch all google calendar for authorised user
//        [[ZPAZeppaCalendarSingleton sharedObject] CallCalendarListGoogleApi];
        
    }
    else
    {
        _googleSignIn = [GPPSignIn sharedInstance];
        _googleSignIn.shouldFetchGooglePlusUser = YES;
        _googleSignIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
        _googleSignIn.clientID = kZeppaGooglePlusClientIdKey;
        _googleSignIn.scopes = [NSArray arrayWithObjects:@"https://www.googleapis.com/auth/plus.login",
                                    @"https://www.googleapis.com/auth/plus.profile.emails.read",
                                    @"https://www.googleapis.com/auth/calendar",
                                    @"https://www.googleapis.com/auth/plus.me"
                                    //                       kGTLAuthScopeZeppauserendpointUserinfoEmail,
                                    ,nil];
        
        _googleSignIn.delegate = self;
       [_googleSignIn authenticate];
        
        BOOL authResponse = [_googleSignIn trySilentAuthentication];
        NSLog(@"auth response %d",authResponse);
    }
}
//
///**********************************************
#pragma mark - GPPSignInDelegate Methods
///**********************************************
-(void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error)
    {
        // Do some error handling here.
        [ZPAStaticHelper showAlertWithTitle:@"" andMessage:[error localizedDescription]];
        if ([_delegate respondsToSelector:@selector(loginWithGoogleAuthSuccessfully:)]) {
            
            [_delegate loginWithGoogleAuthSuccessfully:NO];
        }
        _auth = auth;
    }
    else
    {
        if ([_delegate respondsToSelector:@selector(loginWithGoogleAuthSuccessfully:)]) {
            
            [_delegate loginWithGoogleAuthSuccessfully:YES];
        }
        
        _auth = auth;
        __weak  typeof(self)  weakSelf = self;
      [self getGoogleCalendar:^(BOOL success, NSError *errr) {
          
          [weakSelf getEventsForTheGivenCalendar];
          
          
          //[[ZPAZeppaUserSingleton sharedObject].delegate showLoginError];
          
      }];
    }
}
///**********************************************
#pragma mark - LogOut Methods
///**********************************************
-(void)logout{
    
//    [[ZPADeviceInfo sharedObject] removeDeviceInfoWithObject:[ZPADeviceInfo sharedObject].currentDevice];
//    [ZPAUserDefault clearUserDefault];
//    [[ZPAAppDelegate sharedObject] userDidLogoutFromZeppa];
    
    [[GPPSignIn sharedInstance]disconnect];
    
    
    
}

-(void)didDisconnectWithError:(NSError *)error{
    
    if (error) {
        NSLog(@"Error %@",error.description);
        
    }else{
        
        [[ZPAZeppaCalendarSingleton sharedObject]clear];
        [[ZPAZeppaCalendarSingleton sharedObject]clear];
        [[ZPAZeppaEventSingleton sharedObject]clear];
        [[ZPAZeppaEventTagSingleton sharedObject]clear];
        [[ZPAZeppaUserSingleton sharedObject]clear];
        _auth = nil;
        
        [[ZPADeviceInfo sharedObject] removeDeviceInfoWithObject:[ZPADeviceInfo sharedObject].currentDevice];
        [ZPAUserDefault clearUserDefault];
        [[ZPAAppDelegate sharedObject] userDidLogoutFromZeppa];
        
        
    }
}

///**********************************************
#pragma mark - Calendar API Methods
///**********************************************


-(void)getGoogleCalendar:(fetchGoogleCalendar)completion{
//    
//    
//#warning message Remove isFirstTime Variable when Google authentication is done successfully.
//    
//    if ((![self isFirstTime]) && (![ZPAUserDefault isValueExistsForKey:kZeppaCalendarListIdKey])) {
//        
//        
//        GTLServiceCalendar *calendarService = [self calendarService];//self.calendarService;
//        
//        GTLQueryCalendar *calendarListQuery = [GTLQueryCalendar queryForCalendarListList];
//        
//        
//        [calendarService executeQuery:calendarListQuery completionHandler:^(GTLServiceTicket *ticket, GTLCalendarCalendarList * object, NSError *error) {
//            
//            NSMutableArray *calArray = [NSMutableArray array];
//            for (GTLCalendarCalendarListEntry *calendar in object.items) {
//                
//                ZPACalendarModel *model = [[ZPACalendarModel alloc]init];
//                model.calendarTitle = (calendar.summary)?calendar.summary:@"";
//                model.calendarId = (calendar.identifier)?calendar.identifier:@"";
//                model.calendarHexaColor = (calendar.colorId)?calendar.backgroundColor:@"";
//                model.calendarSync = YES;
//                [calArray addObject:model];
//            }
//           
//            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:calArray];
//            [ZPAUserDefault storedObject:data withKey:kZeppaCalendarListIdKey];
//            completion(YES,nil);
//        }];
//       
//        
//    }if (![self isFirstTime] && ([ZPAUserDefault isValueExistsForKey:kZeppaCalendarListIdKey])) {
//        completion(YES,nil);
//    }
     self.firstTime = YES;

}


-(void)getEventsForTheGivenCalendar{
//    __weak typeof(self) weakSelf = self;
//    for (ZPACalendarModel * calendar in [[ZPAZeppaCalendarSingleton sharedObject] getAllGoogleSyncCalendar]) {
//        
//        GTLServiceCalendar *calendarService = [self calendarService];
//        GTLQueryCalendar *calendarListQuery = [GTLQueryCalendar queryForEventsListWithCalendarId:calendar.calendarId];
//            
//        [calendarService executeQuery:calendarListQuery completionHandler:^(GTLServiceTicket *ticket, GTLCalendarEvents * object, NSError *error) {
//            
//            if (error) {
//              //  [weakSelf getEventsForTheGivenCalendar];
//            }
//            if (!error && [ZPAStaticHelper canUseWebObject:object]) {
//                for (GTLCalendarEvent *event in object) {
//                    
//                    ///Wrap the GTLCalendarEvent object in wrapper class
//                    ZPAEvent *eventWrapper = [[ZPAEvent alloc]initWithGoogleEvent:event];
//                    eventWrapper.parentCalendarId = calendar.calendarId;
//                    eventWrapper.calendarSummary = object.summary;
//                    
//                    ///Create a array of events if nil
//                    if (![ZPAAppData sharedAppData].arrSyncedCalendarsEvents) {
//                        [ZPAAppData sharedAppData].arrSyncedCalendarsEvents = [NSMutableArray array];
//                    }
//                    ///Add event in array of to be synced calendar events
//                    if (![[ZPAAppData sharedAppData].arrSyncedCalendarsEvents containsObject:eventWrapper]) {
//                        [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents addObject:eventWrapper];
//                        
//                    }
//                    
//                }
//                
//                
//                
//              [ZPAAppData sharedAppData].arrSyncedCalendarsEvents  = [[[NSOrderedSet orderedSetWithArray:[ZPAAppData sharedAppData].arrSyncedCalendarsEvents]array] mutableCopy];
//                
//            
//                
//            }
//            else{
//                
//                NSLog(@"Error fetching events for calendar id %@ -> %@",calendar.calendarId,error.localizedDescription);
//            }
//            
//            
//            
//           
//        }];
//         
//    }
    
    
}

-(void)getEventsForTheGivenCalendarWithCalendarId:(NSString *)calendarId{
//    __weak typeof(self) weakSelf = self;
//    
//        GTLServiceCalendar *calendarService = [self calendarService];
//        GTLQueryCalendar *calendarListQuery = [GTLQueryCalendar queryForEventsListWithCalendarId:calendarId];
//        
//        [calendarService executeQuery:calendarListQuery completionHandler:^(GTLServiceTicket *ticket, GTLCalendarEvents * object, NSError *error) {
//            
//            if (error) {
//                //  [weakSelf getEventsForTheGivenCalendar];
//            }
//            if (!error && [ZPAStaticHelper canUseWebObject:object]) {
//                for (GTLCalendarEvent *event in object) {
//                    
//                    ///Wrap the GTLCalendarEvent object in wrapper class
//                    ZPAEvent *eventWrapper = [[ZPAEvent alloc]initWithGoogleEvent:event];
//                    eventWrapper.parentCalendarId = calendarId;
//                    eventWrapper.calendarSummary = object.summary;
//                    
//                    ///Create a array of events if nil
//                    if (![ZPAAppData sharedAppData].arrSyncedCalendarsEvents) {
//                        [ZPAAppData sharedAppData].arrSyncedCalendarsEvents = [NSMutableArray array];
//                    }
//                    ///Add event in array of to be synced calendar events
//                    if (![[ZPAAppData sharedAppData].arrSyncedCalendarsEvents containsObject:eventWrapper]) {
//                        [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents addObject:eventWrapper];
//
//                    }
//                    
//                    
//                }
//                
//            }
//            else{
//                
//                NSLog(@"Error fetching events for calendar id %@ -> %@",calendarId,error.localizedDescription);
//            }
//            
//            
//            
//            
//        }];
    
    }
    
    



-(void)getEventsForCurrentDay:(NSString * )calendarId{
//    for (ZPACalendarModel * calendar in [[ZPAZeppaCalendarSingleton sharedObject] getAllGoogleSyncCalendar]) {
//
//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDateComponents *components = [cal components:( NSMonthCalendarUnit | NSYearCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[NSDate date]];
//
//    //[components setDay:]
//    [components setHour:23];
//    [components setMinute:59];
//    [components setSecond:59];
//
//    
//    GTLServiceCalendar *calendarService = [self calendarService];
//    GTLQueryCalendar *calendarListQuery = [GTLQueryCalendar queryForEventsListWithCalendarId:calendar.calendarId];
// 
//    [calendarListQuery setTimeMin:[GTLDateTime dateTimeForAllDayWithDate:[NSDate date]]];
//    [calendarListQuery setTimeMax:[GTLDateTime dateTimeWithDateComponents:components]];
//
//    [calendarService executeQuery:calendarListQuery completionHandler:^(GTLServiceTicket *ticket, GTLCalendarEvents * object, NSError *error) {
//        if (!error){
//            
//            NSLog(@"%@",object);
//        }
//        
//    }];
//    }
}

    
    


- (GTLServiceCalendar *)calendarService {
    static GTLServiceCalendar *service = nil;
    
    if (!service) {
        service = [[GTLServiceCalendar alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them
        service.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically
        service.retryEnabled = YES;
        [service setAuthorizer:_auth];
    }
    return service;
}


- (GTLServiceCalendar *)calendarService1 {
    static GTLServiceCalendar *service1 = nil;
    
    if (!service1) {
        service1 = [[GTLServiceCalendar alloc] init];
        
        // Have the service object set tickets to fetch consecutive pages
        // of the feed so we do not need to manually fetch them
        service1.shouldFetchNextPages = YES;
        
        // Have the service object set tickets to retry temporary error conditions
        // automatically
        service1.retryEnabled = YES;
        [service1 setAuthorizer:[_googleSignIn authentication]];
    }
    return service1;
}
@end
