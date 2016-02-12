//
//  ZPAZeppaCalendarSingleton.m
//  Zeppa
//
//  Created by Faran on 02/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAZeppaCalendarSingleton.h"
//#import <GoogleOpenSource/GoogleOpenSource.h>
//#import <GooglePlus/GooglePlus.h>
#import "GTLCalendar.h"
#import "ZPACalendarModel.h"
#import "ZPAUserDefault.h"



static ZPAZeppaCalendarSingleton * zeppaCalendarSingleton = nil;
@interface ZPAZeppaCalendarSingleton ()
@property (nonatomic, strong) NSMutableArray *calendarList;
@end
@implementation ZPAZeppaCalendarSingleton

+(ZPAZeppaCalendarSingleton *)sharedObject{
    
    if (zeppaCalendarSingleton == nil) {
        zeppaCalendarSingleton = [[ZPAZeppaCalendarSingleton alloc]init];
        [zeppaCalendarSingleton getAllGoogleCalendar];
        zeppaCalendarSingleton.allEventList = [[NSMutableArray alloc]init];
    }
    return zeppaCalendarSingleton;
    
}
+(void)resetObject{
    zeppaCalendarSingleton = nil;
}

-(void)clear{
    _calendarList = nil;
}

-(NSArray *)getAllGoogleCalendar{
    
    if (!self.calendarList) {
        self.calendarList = [[NSMutableArray alloc]init];
        NSData *row = [ZPAUserDefault getValueFromUserDefaultUsingKey:kZeppaCalendarListIdKey];
        NSArray *cal = [NSKeyedUnarchiver unarchiveObjectWithData:row];
        [self.calendarList addObjectsFromArray:cal];
        
    }
    
    return self.calendarList;
}
-(NSArray *)getAllGoogleSyncCalendar{
    
    NSMutableArray *calArray = [NSMutableArray array];
    for (ZPACalendarModel *model in self.calendarList) {
        
        if (model.calendarSync == YES) {
            [calArray addObject:model];
        }
        
    }
    return calArray;
}


-(void)storeAllEvents{
    
    NSString * eventsString  = @"all Events";

    [_allEventList addObject:[ZPAAppData sharedAppData].arrSyncedCalendarsEvents];
    
    [ZPAUserDefault storedObject:eventsString withKey:@"allEvents"];
    
}

-(NSArray *)getCalendarSummaryArray{
    
    NSMutableArray *summaryArray = [NSMutableArray array];
    
    for (GTLCalendarCalendarListEntry *calendar in _calendarList){
        
        [summaryArray addObject:calendar.summary];
    }
    
    return summaryArray;
}
-(void)saveCalendarInUserDefault{
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.calendarList];
    [ZPAUserDefault storedObject:data withKey:kZeppaCalendarListIdKey];
    
}
///**********************************************
#pragma mark - GoogleCalendar Api Call
///**********************************************
-(void)CallCalendarListGoogleApi{
    
    
    NSMutableArray *calendarArray = [NSMutableArray array];
    GTLServiceCalendar *calendarService = [self calendarService];
    GTLQueryCalendar *calendarListQuery = [GTLQueryCalendar queryForCalendarListList];
    
    
    [calendarService executeQuery:calendarListQuery completionHandler:^(GTLServiceTicket *ticket, GTLCalendarCalendarList * object, NSError *error) {
        for (GTLCalendarCalendarListEntry *calendar in object.items) {
            
    
            ZPACalendarModel *calendarModel = [[ZPACalendarModel alloc]init];
            calendarModel.calendarTitle = calendar.summary;
            calendarModel.calendarId = calendar.identifier;
            calendarModel.calendarHexaColor = calendar.backgroundColor;
            calendarModel.calendarSync = YES;
            [calendarArray addObject:calendarModel];
                    
             [[ZPAZeppaCalendarSingleton sharedObject].calendarList addObject:calendar];
           // [self getEventsForTheGivenCalendar:calendar.identifier];
        }
        
        if ([ZPAZeppaCalendarSingleton sharedObject].calendarList.count>0) {
            
            [ZPAZeppaCalendarSingleton sharedObject].calendarList = [[[NSOrderedSet orderedSetWithArray:[ZPAZeppaCalendarSingleton sharedObject].calendarList] array] mutableCopy];
        }
    // [self saveAllCalendarInUserDefault:calendarArray];
        
    }];
    
    
}
-(void)saveAllCalendarInUserDefault:(NSArray *)arr{
    
    if (arr.count>0) {
        
        NSData *row = [ZPAUserDefault getValueFromUserDefaultUsingKey:kZeppaCalendarListIdKey];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:row];
        NSMutableArray *userDafaultArray = [NSMutableArray arrayWithArray:[dic objectForKey:@"calendar"]];
        
        NSInteger counter = 0;
        if (row) {
            NSArray *tempArr = [userDafaultArray copy];
            for (ZPACalendarModel *newModel in arr) {
                
                for (ZPACalendarModel *savedModel in tempArr) {
                    
                    
                    if (![newModel.calendarId.uppercaseString isEqualToString:savedModel.calendarId.uppercaseString]) {
                        [userDafaultArray addObject:newModel];
                        counter++;
                    }
                }
                
              }
            if (counter>0) {
               
                [_calendarList addObjectsFromArray:userDafaultArray];
                NSDictionary *dict = [NSDictionary dictionaryWithObject:userDafaultArray forKey:@"calendar"];
                NSData *rowData = [NSKeyedArchiver archivedDataWithRootObject:dict];
                [ZPAUserDefault storedObject:rowData withKey:kZeppaCalendarListIdKey];
            }
            
        }else{
            
            [_calendarList addObjectsFromArray:arr];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:arr forKey:@"calendar"];
            NSData *rowData = [NSKeyedArchiver archivedDataWithRootObject:dict];
            [ZPAUserDefault storedObject:rowData withKey:kZeppaCalendarListIdKey];
        }
    }
}
-(void)getEventsForTheGivenCalendar:(NSString *)calendarId{
    
    // typeof(self) __weak weakSelf = self;
    GTLQueryCalendar *calendarListQuery = [GTLQueryCalendar queryForEventsListWithCalendarId:calendarId];
    
    [[self calendarService] executeQuery:calendarListQuery completionHandler:^(GTLServiceTicket *ticket, GTLCalendarEvents * calendarEvents, NSError *error) {
        
        if (!error && calendarEvents.items.count>0) {
            
            for (GTLCalendarEvent * event in calendarEvents.items) {
                
               // [[ZPAZeppaCalendarSingleton sharedObject].calendarEventList addObject:event];
            }
            
        }
    }];
}
- (GTLServiceCalendar *)calendarService {
    static GTLServiceCalendar *service = nil;
    if (!service) {
        service = [[GTLServiceCalendar alloc] init];
        service.shouldFetchNextPages = YES;
        service.retryEnabled = YES;
    }
    return service;
}

@end
