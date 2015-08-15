//
//  ZPAAppData.m
//  Zeppa
//
//  Created by Milan Agarwal on 07/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAAppData.h"
#import "GTLCalendar.h"
#import "ZPAAuthenticatonHandler.h"
#import "GTMOAuth2Authentication.h"

#import "iCalHelper.h"
#import "ZPAUserDefault.h"

typedef NS_OPTIONS(NSUInteger, EventsRefreshStatus) {
    EventsRefreshStatusNotSynced    = 0,
    EventsRefreshStatusGoogleSynced = 1 << 0,
    EventsRefreshStatusiOSSynced    = 1 << 1,
};

typedef void(^ZPAGetiOSCalendarEventsCompletionHandler)(BOOL success, NSError *error);



static ZPAAppData *sharedData;
@interface ZPAAppData ()



@property (nonatomic, assign) EventsRefreshStatus eventsRefreshStatus;

@end
@implementation ZPAAppData

//****************************************************
#pragma mark - Singleton Object
//****************************************************

+(instancetype)sharedAppData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedData) {
            sharedData = [[ZPAAppData alloc]init];
            ///Dheeraj--> Zeppa Events Id added for testing purpose need to remove it
//            sharedData.zeppaEventsCalendarId = @"agicent.com_khj43fmte78782f0343s20d3tg@group.calendar.google.com";
        }
    });
    return sharedData;
}

//****************************************************
#pragma mark - Life Cycle
//****************************************************


-(id)init
{
    if (self = [super init]) {
        ///Do any custom intialization here
    }
    return  self;
}


-(void)dealloc
{
    
    ///Clear any strongly held object
    
}

//****************************************************
#pragma mark - Private Methods
//****************************************************


// Get a service object with the current username/password
//
// A "service" object handles networking tasks.  Service objects
// contain user authentication information as well as networking
// state information (such as cookies and the "last modified" date for
// fetched data.)

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
       // GTMOAuth2Authentication *auth = [ZPAAuthenticatonHandler sharedAuth].auth;
        [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    }
    return service;
}



-(GTLServiceTicket *)fetchGoogleCalendarListWithCompletionHandler:(ZPAGenericEndpointServiceCompletionBlock)completion
{
    
    GTLServiceCalendar *calendarService = self.calendarService;
    
    GTLQueryCalendar *calendarListQuery = [GTLQueryCalendar queryForCalendarListList];
    
    GTLServiceTicket *calendarListServiceTicket = [calendarService executeQuery:calendarListQuery completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        if (completion != NULL) {
            completion(ticket, object, error);
            
            
        }
        
    }];
    return calendarListServiceTicket;
    
}

-(BOOL)bothCalendarEventsRefreshed
{
    return (self.eventsRefreshStatus == (EventsRefreshStatusGoogleSynced | EventsRefreshStatusiOSSynced));
}


-(void)getAllEventsFromSyncedGoogleCalendarsWithCompletionHandler:(ZPAGenericEndpointServiceCompletionBlock)completion
{
    
//       typeof(self) __weak weakSelf = self;
//        
//        ///Fetch all the events of Google calendars to be synced in the app
//        GTLBatchQuery *calendarsEventsBatchQuery = [[GTLBatchQuery alloc]init];
//        for (ZPACalendar *calendar in self.arrGoogleSyncedCalendars) {
//            GTLCalendarCalendarListEntry *googleCalendar = calendar.calendar;
//            NSString *calendarID = googleCalendar.identifier;
//            
//            // We will fetch the events for this calendar
//            
//            GTLQueryCalendar *eventsQuery = [GTLQueryCalendar queryForEventsListWithCalendarId:calendarID];
//            eventsQuery.completionBlock = ^(GTLServiceTicket *ticket, id object, NSError *error) {
//                
//                if (!error && [ZPAStaticHelper canUseWebObject:object]) {
//                    for (GTLCalendarEvent *event in object) {
//                        
//                        ///Wrap the GTLCalendarEvent object in wrapper class
//                        ZPAEvent *eventWrapper = [[ZPAEvent alloc]initWithGoogleEvent:event];
//                        eventWrapper.parentCalendarId = calendarID;
//                        
//                        ///Create a array of events if nil
//                        if (!weakSelf.arrSyncedCalendarsEvents) {
//                            weakSelf.arrSyncedCalendarsEvents = [NSMutableArray array];
//                        }
//                        
//                        ///Add event in array of to be synced calendar events
//                        [weakSelf.arrSyncedCalendarsEvents addObject:eventWrapper];
//                        
//                        ///If current event belongs to Zeppa Events calendar on Google then add it to arrZeppaEventsCalendarEvents as well
//                        if ([calendarID isEqualToString:self.zeppaEventsCalendarId]) {
//                           
//                            if (!weakSelf.arrZeppaEventsCalendarEvents) {
//                                weakSelf.arrZeppaEventsCalendarEvents = [NSMutableArray array];
//                            }
//                            
//                            [weakSelf.arrZeppaEventsCalendarEvents addObject:eventWrapper];
//
//                        }
//                        
//                        
//                    }
//                    
//                }
//                else{
//                    
//                    NSLog(@"Error fetching events for calendar id %@ -> %@",calendarID,error.localizedDescription);
//                }
//                
//                
//            };
//            [calendarsEventsBatchQuery addQuery:eventsQuery];
//            
//        }
//        
//        [self.calendarService executeQuery:calendarsEventsBatchQuery
//                         completionHandler:^(GTLServiceTicket *ticket,
//                                             id object, NSError *error) {
//                             // Callback
//                             //
//                             // For batch queries with successful execution,
//                             // the result is a GTLBatchResult object
//                             //
//                             // At this point, the query completion blocks
//                             // have already been called
//                             GTLBatchResult *result = object;
//                             NSLog(@"success = %ld\nfailures = %ld",(unsigned long)result.successes.count, (unsigned long)result.failures.count);
//                             
//                             ///The batch query is complete so update the refresh status
//                             if (completion) {
//                                 completion(ticket,object,error);
//                             }
//                             
//                             
//                             
//                             
//                         }];
//
    
}



-(void)getAllEventFromiCalCalendarWithCompletionHandler:(ZPAGetiOSCalendarEventsCompletionHandler)completion
{
    
//    NSMutableArray *weakArriOSSyncedCalendars = self.arriOSSyncedCalendars;
//    typeof(self) __weak weakSelf = self;
//        
//        ///2.Fetch Calendar List for the current user
//        
//        [[iCalHelper sharedHelper].eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
//            
//            [iCalHelper sharedHelper].isAccessGranted = granted;
//            
//            if (!error && granted) {
//                NSLog(@"Access to event store is granted");
//                //---- code here when user allows your app to access their calendar.
//                
//                ///Unwrap the EKCalendar object from ZPACalendar object
//                NSMutableArray *arrEKCalendars = [NSMutableArray array];
//                for (ZPACalendar *calendar in weakArriOSSyncedCalendars) {
//                    [arrEKCalendars addObject:calendar.calendar];
//                }
//
//                
////                NSDateComponents *comps = [[NSDateComponents alloc] init];
////                [comps setYear:1950];
////                [comps setMonth:1];
////                [comps setDay:1];
////                NSDate *start = [[NSCalendar currentCalendar] dateFromComponents:comps];
////
////                [comps setYear:2050];
////                [comps setMonth:1];
////                [comps setDay:1];
////                NSDate *finish = [[NSCalendar currentCalendar] dateFromComponents:comps];
////                
//
//                NSDateComponents *dateComp = [[NSDateComponents alloc]init];
//                [dateComp setYear:-50];
//                [dateComp setMonth:-10];
//                NSDate *start = [[NSCalendar currentCalendar]dateByAddingComponents:dateComp toDate:[NSDate date] options:0];
//                
//                [dateComp setYear:50];
//                [dateComp setMonth:10];
//                NSDate *finish = [[NSCalendar currentCalendar]dateByAddingComponents:dateComp toDate:[NSDate date] options:0];
//                
//                
//                
//                
//                // use Dictionary for remove duplicates produced by events covered more one year segment
//                NSMutableDictionary *eventsDict = [NSMutableDictionary dictionaryWithCapacity:1024];
//                
//                NSDate* currentStart = [NSDate dateWithTimeInterval:0 sinceDate:start];
//                
//                int seconds_in_year = 60*60*24*365;
//                
//                // enumerate events by one year segment because iOS do not support predicate longer than 4 year !
//                while ([currentStart compare:finish] == NSOrderedAscending) {
//                    
//                    NSDate* currentFinish = [NSDate dateWithTimeInterval:seconds_in_year sinceDate:currentStart];
//                    
//                    if ([currentFinish compare:finish] == NSOrderedDescending) {
//                        currentFinish = [NSDate dateWithTimeInterval:0 sinceDate:finish];
//                    }
//                    
//                    NSLog(@"Start Date --> %@\nEnd Date --> %@",currentStart,currentFinish);
//                    
//                    NSPredicate *predicate = [[iCalHelper sharedHelper].eventStore predicateForEventsWithStartDate:currentStart endDate:currentFinish calendars:arrEKCalendars];
//                    [[iCalHelper sharedHelper].eventStore enumerateEventsMatchingPredicate:predicate
//                                                      usingBlock:^(EKEvent *event, BOOL *stop) {
//                                                          
//                                                          if (event) {
//                                                              [eventsDict setObject:event forKey:event.eventIdentifier];
//                                                          }
//                                                          
//                                                      }];
//                    currentStart = [NSDate dateWithTimeInterval:(seconds_in_year + 1) sinceDate:currentStart];
//                    
//                }
//                
//                NSArray *allEvents = [eventsDict allValues];
//                NSLog(@"Total iCal Events = %d",(int)allEvents.count);
//                
//                if (allEvents.count > 0) {
//                    for (EKEvent *event in allEvents) {
//                        
//                        ///Wrap the GTLCalendarEvent object in wrapper class
//                        ZPAEvent *eventWrapper = [[ZPAEvent alloc]initWithEkEvent:event];
//                      //  eventWrapper.eventType = CalendarEventTypeiOS;
//                        eventWrapper.parentCalendarId = event.calendar.calendarIdentifier;
//                       // eventWrapper.event = event;
//                        
//                        ///Create a array of events if nil
//                        if (!weakSelf.arrSyncedCalendarsEvents) {
//                            weakSelf.arrSyncedCalendarsEvents = [NSMutableArray array];
//                        }
//                        
//                        ///Add event in array of to be synced calendar events
//                        [weakSelf.arrSyncedCalendarsEvents addObject:eventWrapper];
//                        
//                        NSLog(@"event --> %@",event);
//                        
//                        
//                        
//                    }
//                    
//                }
//                
//                if (completion) {
//                    completion(YES,error);
//                }
//                
//            }
//            else{
//                
//                NSLog(@"Access to eevent store denied with error %@",error.localizedDescription);
//                if (completion) {
//                    completion(NO,error);
//                }
//                
//            }
//            
//            
//       
//        }];
}
//****************************************************
#pragma mark - Public Interface
//****************************************************
-(UIImage *)defaultUserImage
{
//    NSString *defaultUserImagePath = [[NSBundle mainBundle]pathForResource:@"default_user_image" ofType:@"png"];
//    self.defaultUserImage = [UIImage imageWithContentsOfFile:defaultUserImagePath];
//    return self.defaultUserImage;
    
    return [UIImage imageNamed:@"default_user_image.png"];
}



-(void)getGoogleCalendarListWithCompletionhandler:(ZPACalendarListCompletionHandler)completion
{
    ///Always create a new Google Calendar array
    self.arrGoogleCalendars = [NSMutableArray array];
    NSMutableArray *weakArrGoogleCalendars = self.arrGoogleCalendars;
    
    ///2.Fetch Calendar List for the current user
    [self fetchGoogleCalendarListWithCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        if (!error) {
          //  self.calendarList = object;
            GTLCalendarCalendarList *calendarList = object;
            NSLog(@"Calendar List --> %@",calendarList);
            for (GTLCalendarCalendarListEntry *calendar in calendarList.items) {
            
                ///Create a ZPACalendar Objects
                ZPACalendar * googleCalendar = [[ZPACalendar alloc]init];
                googleCalendar.calendarType = CalendarTypeGoogle;
                googleCalendar.calendar = calendar;
                googleCalendar.shouldBeSynced = NO;
                
                [weakArrGoogleCalendars addObject:googleCalendar];
            }
            
         /*   //Fetch Events in each google calendar
            GTLBatchQuery *calendarsEventsBatchQuery = [[GTLBatchQuery alloc]init];
           
            for (GTLCalendarCalendarListEntry *calendars in calendarList.items) {
                NSString *calendarID = calendars.identifier;
                
                // We will fetch the events for this calendar
                
                GTLQueryCalendar *eventsQuery = [GTLQueryCalendar queryForEventsListWithCalendarId:calendarID];
                eventsQuery.completionBlock = ^(GTLServiceTicket *ticket, id object, NSError *error) {
                    
                    if (!error) {
                        calendars.items = object;
                        for (GTLCalendarEvent *event in calendars.items) {
                            NSLog(@"Event --> \n %@",event);
                        }
                        
                    }
                    else{
                        
                        NSLog(@"Error fetching events for calendar id %@ -> %@",calendarID,error.localizedDescription);
                    }
                    
                };
                [calendarsEventsBatchQuery addQuery:eventsQuery];
                
            }
            
            [self.calendarService executeQuery:calendarsEventsBatchQuery
                             completionHandler:^(GTLServiceTicket *ticket,
                                                 id object, NSError *error) {
                                 // Callback
                                 //
                                 // For batch queries with successful execution,
                                 // the result is a GTLBatchResult object
                                 //
                                 // At this point, the query completion blocks
                                 // have already been called
                                 GTLBatchResult *result = object;
                                 NSLog(@"success = %ld\nfailures = %ld",(unsigned long)result.successes.count, (unsigned long)result.failures.count);
                                 
                             }];
          //   */
            
            
        }
        else{
//         [ZPAStaticHelper showAlertWithTitle:NSLocalizedString(@"Fetch Calendar List Error", nil) andMessage:error.localizedDescription];
            ///Handle any error here
        }
        
        if (completion) {
            completion(weakArrGoogleCalendars, error);
        }
        
        
    }];
    
}

-(void)getiOSCalendarListWithCompletionHandler:(ZPACalendarListCompletionHandler)completion
{
    
    ///Always create a new iOS Calendar array
    self.arriOSCalendars = [NSMutableArray array];
    NSMutableArray *weakArriOSCalendars = self.arriOSCalendars;
    
    ///2.Fetch Calendar List for the current user
   [[iCalHelper sharedHelper].eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        
        [iCalHelper sharedHelper].isAccessGranted = granted;
        
        if (!error && granted) {
            NSLog(@"Access to event store is granted");
            
            ///Fetch all available calendars
            NSArray *arrCalendars = [[iCalHelper sharedHelper].eventStore calendarsForEntityType:EKEntityTypeEvent];
            for (EKCalendar *calendar in arrCalendars) {
                ZPACalendar *iOSCalendar = [[ZPACalendar alloc]init];
                iOSCalendar.calendarType = CalendarTypeiOS;
                iOSCalendar.calendar = calendar;
                iOSCalendar.shouldBeSynced = NO;
                [weakArriOSCalendars addObject:iOSCalendar];
            }
            NSLog(@"Available Calendars --> %@",arrCalendars);
            
        }
        else{
            
            NSLog(@"Access to eevent store denied with error %@",error.localizedDescription);
            
        }
        
        if (completion) {
            completion(weakArriOSCalendars,error);
        }
        
    }];
}
-(GTLServiceTicket *)createGoogleCalendarWithCalendar:(GTLCalendarCalendar *)calendar completionHandler:(ZPAGenericEndpointServiceCompletionBlock)completion
{
    
    GTLServiceCalendar *calendarService = self.calendarService;
    
    GTLQueryCalendar *createNewCalendarQuery = [GTLQueryCalendar queryForCalendarsInsertWithObject:calendar];
    
    GTLServiceTicket *createNewCalendarServiceTicket = [calendarService executeQuery:createNewCalendarQuery completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        if (completion != NULL) {
            completion(ticket, object, error);
        }
        
    }];
    return createNewCalendarServiceTicket;
    
}


-(void)refreshSyncedCalendarsEventsWithCompletionHandler:(ZPARefreshSyncedCalendarsEventsCompletionHandler)completion
{

    ///Save the completion handler to be called later when both iOS and Google calendar events are synced. DO remember to null this completion handler when done.
//    self.refreshSyncedCalendarsEventsCompletionHandler = completion;
    typeof(self) __weak weakSelf = self;
    
    
    
    ///Fetch all the events of Google calendars to be synced in the app
    if (self.arrGoogleSyncedCalendars
        && self.arrGoogleSyncedCalendars.count > 0) {
        
        [self getAllEventsFromSyncedGoogleCalendarsWithCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
           
            weakSelf.eventsRefreshStatus |= EventsRefreshStatusGoogleSynced;
            weakSelf.googleEventsRefreshError = error;
            if ([weakSelf bothCalendarEventsRefreshed]) {
                  [self sortArray:self.arrSyncedCalendarsEvents bySortDescriptorKey:@"startDateTime" withAscendingOrder:YES];
                if (completion) {
                    completion(weakSelf.arrSyncedCalendarsEvents,weakSelf.googleEventsRefreshError,weakSelf.iOSEventsRefreshError);
                }
            }

        }];
        
    }
    else{
        
        ///No calendar selected from Google Calendars to be synced
        self.eventsRefreshStatus |= EventsRefreshStatusGoogleSynced;
        self.googleEventsRefreshError = nil;
        if ([self bothCalendarEventsRefreshed]) {
              [self sortArray:self.arrSyncedCalendarsEvents bySortDescriptorKey:@"startDateTime" withAscendingOrder:YES];
            if (completion) {
                completion(self.arrSyncedCalendarsEvents,self.googleEventsRefreshError,self.iOSEventsRefreshError);
            }
        }
        
    }

    
    ///Fetch all the events of iOS calendars to be synced in the app
    NSMutableArray *weakArriOSSyncedCalendars = self.arriOSSyncedCalendars;
    if (weakArriOSSyncedCalendars
        && weakArriOSSyncedCalendars.count > 0) {
        
        [self getAllEventFromiCalCalendarWithCompletionHandler:^(BOOL success, NSError *error) {
            
            if (!success && error) {
                ///Handle iOS calendar error here
                
            }
            
            weakSelf.eventsRefreshStatus |= EventsRefreshStatusiOSSynced;
            weakSelf.iOSEventsRefreshError = error;
            ///If iOS events are also fetched then call the completion handler
            if ([weakSelf bothCalendarEventsRefreshed]) {
                  [self sortArray:self.arrSyncedCalendarsEvents bySortDescriptorKey:@"startDateTime" withAscendingOrder:YES];
                if (completion) {
                    completion(weakSelf.arrSyncedCalendarsEvents,weakSelf.googleEventsRefreshError,weakSelf.iOSEventsRefreshError);
                }
            }
            
            
        }];
    }
    else{
        
        self.eventsRefreshStatus |= EventsRefreshStatusiOSSynced;
        self.iOSEventsRefreshError = nil;
        
        ///If iOS events are also fetched then call the completion handler
        if ([self bothCalendarEventsRefreshed]) {
            [self sortArray:self.arrSyncedCalendarsEvents bySortDescriptorKey:@"startDateTime" withAscendingOrder:YES];
            if (completion) {
                completion(self.arrSyncedCalendarsEvents,self.googleEventsRefreshError,self.iOSEventsRefreshError);
            }
        }
        
    }
    
}

-(NSMutableArray *)sortArray:(NSMutableArray *)arr bySortDescriptorKey:(NSString *)key withAscendingOrder:(BOOL)value
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:value];
    //     NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    
    [arr sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    return arr;
    
}

-(GTLServiceTicket *)getCalendarListEntryWithCalendarId:(NSString *)calendarId andCompletionhandler:(ZPAGenericEndpointServiceCompletionBlock)completion
{
    GTLServiceCalendar *calendarService = self.calendarService;
    
    GTLQueryCalendar *calendarListEntryQuery = [GTLQueryCalendar queryForCalendarListGetWithCalendarId:calendarId];
    
    GTLServiceTicket *calendarListEntryServiceTicket = [calendarService executeQuery:calendarListEntryQuery completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        if (completion != NULL) {
            completion(ticket, object, error);
        }
        
    }];
    return calendarListEntryServiceTicket;

}

-(GTLServiceTicket *)getGoogleCalendarEventsListWithCalendarId:(NSString *)calendarId andCompletionhandler:(ZPAGenericEndpointServiceCompletionBlock)completion
{
      
    GTLServiceCalendar *calendarService = self.calendarService;
    
    GTLQueryCalendar *calendarEventsListQuery = [GTLQueryCalendar queryForEventsListWithCalendarId:calendarId];
    
    GTLServiceTicket *calendarEventsListServiceTicket = [calendarService executeQuery:calendarEventsListQuery completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        if (completion != NULL) {
            completion(ticket, object, error);
        }
        
    }];
    return calendarEventsListServiceTicket;


}


@end
