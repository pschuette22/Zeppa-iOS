//
//  ZPAManagePushNotifCell.m
//  Zeppa
//
//  Created by Dheeraj on 07/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAManageCalendarSyncCell.h"
#import "ZPAZeppaCalendarSingleton.h"
#import "ZPACalendarCell.h"
#import "ZPACalendarModel.h"
#import "ZPAUserDefault.h"


@implementation ZPAManageCalendarSyncCell{
    NSIndexPath * selectedIndex;
    NSString * summary;
    NSMutableArray * syncEventArray;
    NSMutableDictionary * savedNotificationDic;
    ZPACalendarModel *lastCalModel;
    ZPACalendarCell *calendarCell;
}
-(void)awakeFromNib{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    syncEventArray = [NSMutableArray arrayWithArray:[ZPAAppData sharedAppData].arrSyncedCalendarsEvents];
    savedNotificationDic = [NSMutableDictionary dictionary];
}
///****************************************************
#pragma mark - TableView DataSource
///****************************************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _calendarArray.count;
   
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    ZPACalendarModel *calendar = [_calendarArray objectAtIndex:indexPath.row];
    
    static NSString *userProfileCellId = @"CalendarCell";
    calendarCell = [tableView dequeueReusableCellWithIdentifier:userProfileCellId];
    calendarCell.selectionStyle  = UITableViewCellSelectionStyleNone;
    calendarCell.lblCalendarSummary.text = calendar.calendarTitle;
    calendarCell.view_CalendarColor.backgroundColor = [self colorFromHexString:calendar.calendarHexaColor];
    [calendarCell.synEvents setOn:calendar.calendarSync animated:YES];
        return calendarCell;
        
}
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
- (IBAction)switchStateChanged:(UISwitch *)sender {
    
        CGPoint point = [sender convertPoint:CGPointZero toView:self.tableView];
        NSIndexPath *index = [self.tableView indexPathForRowAtPoint:point];

       ZPACalendarModel *calModel  =  [_calendarArray objectAtIndex:index.row];
        summary = calModel.calendarId;
    
        if ([calModel.calendarTitle isEqualToString:@"Zeppa"] && sender.on == NO) {
            
            lastCalModel = calModel;
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"Unsyncing the Zeppa Calendar will cause Zeppa to not work properly. Are you sure you want to do this? " delegate:self cancelButtonTitle:@"Unsync" otherButtonTitles:@"Sync Calendar",nil];
            
            [alert show];
        }else  if ([calModel.calendarTitle isEqualToString:@"Zeppa"] && sender.on == YES){
            
            [[ZPAAuthenticatonHandler sharedAuth]getEventsForTheGivenCalendarWithCalendarId:calModel.calendarId];

            
        }else if(sender.on == NO){
            calModel.calendarSync = NO;
            [self removeUnSyncCalendar:calModel.calendarId];
            
        }else if (sender.on == YES){
            calModel.calendarSync = YES;
            [[ZPAAuthenticatonHandler sharedAuth]getEventsForTheGivenCalendarWithCalendarId:calModel.calendarId];
            
        }

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedIndex = indexPath;
    
    
//    ZPACalendarModel *calModel  =  [_calendarArray objectAtIndex:indexPath.row];
//    summary = calModel.calendarId;
//    
//    if ([calModel.calendarTitle isEqualToString:@"Zeppa"] && calendarCell.synEvents.on == NO) {
//        
//        lastCalModel = calModel;
//        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"Unsyncing the Zeppa Calendar will cause Zeppa to not work properly. Are you sure you want to do this? " delegate:self cancelButtonTitle:@"Unsync" otherButtonTitles:@"Sync Calendar",nil];
//        
//        [alert show];
//    }else  if ([calModel.calendarTitle isEqualToString:@"Zeppa"] && calendarCell.synEvents.on == YES){
//        
//        [[ZPAAuthenticatonHandler sharedAuth]getEventsForTheGivenCalendarWithCalendarId:calModel.calendarId];
//        [calendarCell.synEvents setOn:YES animated:YES];
//        
//        
//    }else if(calendarCell.synEvents.on == NO){
//        calModel.calendarSync = NO;
//        [self removeUnSyncCalendar:calModel.calendarId];
//        [calendarCell.synEvents setOn:NO animated:YES];
//        
//    }else if (calendarCell.synEvents.on == YES){
//        calModel.calendarSync = YES;
//        [[ZPAAuthenticatonHandler sharedAuth]getEventsForTheGivenCalendarWithCalendarId:calModel.calendarId];
//        [calendarCell.synEvents setOn:YES animated:YES];
//        
//    }

    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0 ) {
        lastCalModel.calendarSync = NO;
        [self removeUnSyncCalendar:summary];
        //[calendarCell.synEvents setOn:NO animated:YES];
    }else if (buttonIndex == 1 ){
        
        lastCalModel.calendarSync = YES;
        

        [[ZPAAuthenticatonHandler sharedAuth]getEventsForTheGivenCalendarWithCalendarId:summary];
        

       // [calendarCell.synEvents setOn:YES animated:YES];
    }
}

///****************************************************
#pragma mark - Private Methods
///****************************************************

//-(void)syncCalendarEvent:(ZPACalendarModel *)selectedCal{
//    
//    
////    for (ZPAEvent *event in syncEventArray) {
////        
////        //  GTLCalendarEvent * calendarEvent = event.event;
////        if ([event.calendarSummary isEqualToString:eventTitle]) {
////            [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents addObject:event];
////        }
////    }
//// 
////    [ZPAAppData sharedAppData].arrSyncedCalendarsEvents = [[[NSOrderedSet orderedSetWithArray:[ZPAAppData sharedAppData].arrSyncedCalendarsEvents] array]mutableCopy];
//    
//    
//}

// method to set Switch On or Off

-(void)setTrueOrFalseOnSwitch:(UISwitch *)currentSwitch withkey:(NSString *)key{
    
    BOOL value;
    
    if ([savedNotificationDic objectForKey:key]) {
        NSNumber *num = [savedNotificationDic objectForKey:key];
        value = [num boolValue];
    }else{
        value = NO;
    }
    [currentSwitch setOn:value animated:NO];
    
}
//
//-(void)syncCalendarEvent:(ZPACalendarModel *)calModel{
//    
//    for (ZPAEvent * events in [ZPAZeppaCalendarSingleton sharedObject].allEventList) {
//        
//        if ([calModel.calendarId isEqualToString:events.parentCalendarId] && [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents containsObject:events]) {
//            
//            [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents removeObject:events];
//        }else{
//            
//            [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents addObject:events];
//        }
//    }
//}
//
-(void)removeUnSyncCalendar:(NSString *)calendarId{
    
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[ZPAAppData sharedAppData].arrSyncedCalendarsEvents];
    
    for (ZPAEvent * event in arr) {
        if ([event.parentCalendarId isEqualToString:calendarId]) {
            if ([[ZPAAppData sharedAppData].arrSyncedCalendarsEvents containsObject:event]) {
                [[ZPAAppData sharedAppData].arrSyncedCalendarsEvents removeObject:event];
            }
            
        }
    }
}

-(void)changeSwitchActionSyncOrUnsync:(UISwitch *)sender{
    
}

@end
