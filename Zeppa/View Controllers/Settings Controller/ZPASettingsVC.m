//
//  ZPASettingsVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPASettingsVC.h"
#import "ZPAPushNotifCell.h"
#import "ZPAManageCalendarSyncCell.h"
#import "ZPAUserDefault.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAZeppaCalendarSingleton.h"
#import "ZPACalendarModel.h"

#import "MBProgressHUD.h"

#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"


#define TOTAL_SECTIONS 1
#define TOTAL_ROWS     4

#define HEADER_HEIGHT 0.0f

#define TABLE_ROW_INDEX_PUSH_NOTIFICATION 0
#define TABLE_ROW_INDEX_MANAGE_SYNCED_CALENDARS 1
#define TABLE_ROW_INDEX_LOGOUT 2
#define TABLE_ROW_INDEX_DELETE_ACCOUNT 3

#define LOGOUT_ALERTVIEW 0
#define DELETEACCOUNT_ALERTVIEW 1

@interface ZPASettingsVC ()<UIAlertViewDelegate>

@end

@implementation ZPASettingsVC{
    
    UISwitch *pushSwitch;
    NSIndexPath *currentIndexPath;
    NSIndexPath *preSelectedIndex;
    
    BOOL isPushManageBtnActive;
    BOOL isPushNotifBtnActive;
    BOOL isManageCalendarSyncBtnActive;
    NSMutableDictionary *savedNotificationDic;
    ZPAPushNotifCell *notifCell;
    NSArray *calendarArray;
    MBProgressHUD * progressHUD;
    ZPACalendarCell * calendarCell;
    ZPAManageCalendarSyncCell *syncCalendar;

}
///****************************************************
#pragma mark - LifeCycle Methods
///****************************************************
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    savedNotificationDic = [NSMutableDictionary dictionary];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    currentIndexPath = nil;
    isPushNotifBtnActive = NO;
    isPushManageBtnActive = NO;
    isManageCalendarSyncBtnActive = NO;
    self.title = @"Setting";
    calendarArray  = [[ZPAZeppaCalendarSingleton sharedObject] getAllGoogleCalendar];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    
        savedNotificationDic = [ZPAUserDefault getValueFromUserDefaultUsingKey:kZeppaSettingNotificationKey];
        
        for (NSString *key in savedNotificationDic.allKeys) {
            NSNumber *num = [savedNotificationDic objectForKey:key];
            if ([num boolValue]) {
                [pushSwitch setOn:YES animated:YES];
                isPushNotifBtnActive = YES;
                //isManageCalendarSyncBtnActive = YES;
                return;
            }
            
        }
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    
    [dic setObject:[NSNumber numberWithBool:notifCell.vibrateSwitch.isOn] forKey:kZeppaSettingVibrateKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.RingSwitch.isOn] forKey:kZeppaSettingRingKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.mingleRequestSwitch.isOn] forKey:kZeppaSettingMingleKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.startedMinglingSwitch.isOn] forKey:kZeppaSettingStartedMingleKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.eventRecommendSwitch.isOn] forKey:kZeppaSettingEventRecommendationsKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.eventInviteSwitch.isOn] forKey:kZeppaSettingEventInvitesKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.commentSwitch.isOn] forKey:kZeppaSettingCommentsKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.eventCancelSwitch.isOn] forKey:kZeppaSettingEventCanceledKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.peopleJoinSwitch.isOn] forKey:kZeppaSettingPeopleJoinKey];
    [dic setObject:[NSNumber numberWithBool:notifCell.peopleLeaveSwitch.isOn] forKey:kZeppaSettingPeopleLeaveKey];
    
    [ZPAUserDefault storedObject:dic withKey:kZeppaSettingNotificationKey];
    
    [[ZPAZeppaCalendarSingleton sharedObject] saveCalendarInUserDefault];
    [[NSNotificationCenter defaultCenter]postNotificationName:kzeppacalendarSync object:nil];
    
}
///****************************************************
#pragma mark - TableView DataSource
///****************************************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return TOTAL_SECTIONS;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return TOTAL_ROWS;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger indexRow = indexPath.row;
    
    if (indexRow == TABLE_ROW_INDEX_PUSH_NOTIFICATION) {
        static NSString *userEventCellId = @"PuchNotifCell";
        notifCell = [tableView dequeueReusableCellWithIdentifier:userEventCellId];
        notifCell.selectionStyle  = UITableViewCellSelectionStyleNone;
        pushSwitch = notifCell.pushNotifSwitch;
        [notifCell.pushNotifSwitch setOn:isPushNotifBtnActive animated:NO];
        [self setTrueOrFalseOnSwitch:notifCell.vibrateSwitch withkey:kZeppaSettingVibrateKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.RingSwitch withkey:kZeppaSettingRingKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.mingleRequestSwitch withkey:kZeppaSettingMingleKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.startedMinglingSwitch withkey:kZeppaSettingStartedMingleKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.eventRecommendSwitch withkey:kZeppaSettingEventRecommendationsKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.eventInviteSwitch withkey:kZeppaSettingEventInvitesKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.commentSwitch withkey:kZeppaSettingCommentsKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.eventCancelSwitch withkey:kZeppaSettingEventCanceledKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.peopleJoinSwitch withkey:kZeppaSettingPeopleJoinKey];
        
        [self setTrueOrFalseOnSwitch:notifCell.peopleLeaveSwitch withkey:kZeppaSettingPeopleLeaveKey];
        
        return notifCell;
        
    }else if(indexRow == TABLE_ROW_INDEX_MANAGE_SYNCED_CALENDARS){
        
        static NSString *userProfileCellId = @"ManageSyncCell";
        syncCalendar = [tableView dequeueReusableCellWithIdentifier:userProfileCellId];
        syncCalendar.selectionStyle  = UITableViewCellSelectionStyleNone;
        syncCalendar.calendarArray = [calendarArray mutableCopy] ;
//
//        syncCalendar.calendarArray = [calendarArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//           
//            ZPACalendarModel *event1 = (ZPACalendarModel *)obj1 ;
//            ZPACalendarModel *event2 = (ZPACalendarModel *)obj2;
//            
//            return [event1.calendarTitle  compare:event2.calendarTitle];
//            
//        }];
       [ZPAStaticHelper sortArrayAlphabatically:syncCalendar.calendarArray  withKey:@"calendarTitle"];
        
        CGRect rect = syncCalendar.tableView.frame;
        rect.size.height = 60*calendarArray.count;
        syncCalendar.tableView.frame = rect;
    
        return syncCalendar;

    }else if (indexRow == TABLE_ROW_INDEX_LOGOUT){
        
        static NSString *userProfileCellId = @"LogoutCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userProfileCellId];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (indexRow == TABLE_ROW_INDEX_DELETE_ACCOUNT){
        
        static NSString *userProfileCellId = @"DeleteAccCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userProfileCellId];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    return nil;
}
//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

///@todo need to implement below methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == TABLE_ROW_INDEX_PUSH_NOTIFICATION && isPushNotifBtnActive) {
        if (isPushManageBtnActive) {
            return 487;
        }
        return 172;
    }
    if (indexPath.row == TABLE_ROW_INDEX_MANAGE_SYNCED_CALENDARS && isManageCalendarSyncBtnActive) {
        
        return 60*calendarArray.count;
    }
    return 44.0;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == TABLE_ROW_INDEX_LOGOUT) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Logout?" message:@"You may miss a bunch of fun activities" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Logout", nil];
        alert.tag = LOGOUT_ALERTVIEW;
        [alert show];
        
    }else if (indexPath.row == TABLE_ROW_INDEX_DELETE_ACCOUNT) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete Account?" message:@"You can't undo this! Be really really sure you want to delete your account on Zeppa and all information associated with it. Operation may take several moments, please do not close application mid deletion" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Delete Account", nil];
        alert.tag = DELETEACCOUNT_ALERTVIEW;
        [alert show];
        
    }else{
    }
    
    
}

///**************************
#pragma mark - Action Methods
///**************************
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == LOGOUT_ALERTVIEW) {
        if (buttonIndex == 1) {
            [self logOutBtnTapped:nil];
        }
        
    }
    if (alertView.tag == DELETEACCOUNT_ALERTVIEW) {
        if (buttonIndex == 1) {
            [self deleteAcountBtnTapped:nil];
        }
        
    }
}

///**************************
#pragma mark - Action Methods
///**************************
- (IBAction)logOutBtnTapped:(UIButton *)sender {
    
    [[ZPAAuthenticatonHandler sharedAuth] logout];
    
}
- (IBAction)deleteAcountBtnTapped:(UIButton *)sender {
    
    [self showActivityIndicator];
    
    NSNumber *num = [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
    GTLQueryZeppaclientapi *removeZeppaUser = [GTLQueryZeppaclientapi queryForRemoveCurrentZeppaUserWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken] ];
    
    [[self zeppaUserService] executeQuery:removeZeppaUser completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        if(error){
            // error
        } else {
            [self hideActivityIndicator];
            [[ZPAAuthenticatonHandler sharedAuth] logout];
        }
    }];
}
-(GTLServiceZeppaclientapi *)zeppaUserService
{
    ///Create ZeppaUserEndPoint Service
    static GTLServiceZeppaclientapi *zeppaUserService = nil;
    if (!zeppaUserService) {
        
        zeppaUserService = [[GTLServiceZeppaclientapi alloc]init];
        zeppaUserService.retryEnabled = YES;        
    }
    return zeppaUserService;
}

- (IBAction)pushNotifBtnTapped:(UIButton *)sender {
    
    if (pushSwitch.on) {
        //code here
        [pushSwitch setOn:NO animated:NO];
        isPushNotifBtnActive = NO;
    }
    else{
        //code here
        [pushSwitch setOn:YES animated:NO];
        isPushNotifBtnActive = YES;
    }
    [self.tableView reloadData];
}
- (IBAction)pushNotifSwitch:(UISwitch *)sender {
    
    isPushNotifBtnActive = sender.isOn;
    [self.tableView reloadData];
}

- (IBAction)calendarSyncSwitchTapped:(UISwitch *)sender {
    

    
}

- (IBAction)managePushBtnPressed:(UIButton *)sender {
    
    //first time sender.selected is No
    if (sender.selected) {
        //code here
        isPushManageBtnActive = NO;
        sender.selected=NO;
    }
    else{
        //code here
        isPushManageBtnActive = YES;
        sender.selected=YES;
    }
    [self.tableView reloadData];
}

- (IBAction)manageSyncCalendarPressed:(UIButton *)sender{
    
    
    if (sender.selected) {
        //code here
        isManageCalendarSyncBtnActive = NO;
        sender.selected=NO;
    }
    else{
        //code here
        isManageCalendarSyncBtnActive = YES;
        sender.selected=YES;
    }
    [self.tableView reloadData];
    
    
}
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

-(void)showActivityIndicator{
    
    progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.labelText = @"Deleting User Account...";
    progressHUD.backgroundColor = [UIColor colorWithRed:10 green:210 blue:255 alpha:0.5];
    [progressHUD show:YES];
    
}

-(void)hideActivityIndicator{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
