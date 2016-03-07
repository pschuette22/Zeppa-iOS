//
//  ZPASettingsVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPASettingsVC.h"
#import "ZPAPushNotifCell.h"
#import "ZPAUserDefault.h"
#import "ZPAConstants.h"
#import "ZPAAuthenticatonHandler.h"

#import "MBProgressHUD.h"

#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"


#define TOTAL_SECTIONS 1
#define TOTAL_ROWS     5

#define HEADER_HEIGHT 0.0f

#define TABLE_ROW_INDEX_PUSH_NOTIFICATION 0
#define TABLE_ROW_INDEX_PRIVACY 1
#define TABLE_ROW_INDEX_CONDITIONS 2
#define TABLE_ROW_INDEX_LOGOUT 3
#define TABLE_ROW_INDEX_DELETE_ACCOUNT 4

#define LOGOUT_ALERTVIEW 0
#define DELETEACCOUNT_ALERTVIEW 1

@interface ZPASettingsVC ()<UIAlertViewDelegate>

@end

@implementation ZPASettingsVC{
    
    UISwitch *pushSwitch;
    NSIndexPath *currentIndexPath;
    NSIndexPath *preSelectedIndex;
    ZPAPushNotifCell *notifCell;
    NSArray *calendarArray;
    MBProgressHUD * progressHUD;
    
    BOOL isNotifEnabled;
    BOOL isManagePushNotifsActive;

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
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    currentIndexPath = nil;
    self.title = @"Settings";
    isManagePushNotifsActive=NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated{
    
    
}
-(void)viewDidDisappear:(BOOL)animated{
    
    
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
        static NSString *userEventCellId = @"PushNotifCell";
        notifCell = [tableView dequeueReusableCellWithIdentifier:userEventCellId];
        notifCell.selectionStyle  = UITableViewCellSelectionStyleNone;
        pushSwitch = notifCell.pushNotifSwitch;
        
        isNotifEnabled = [ZPAUserDefault getBoolWithKey:kZeppaSettingNotificationKey withDefault:YES];
        [pushSwitch setOn:isNotifEnabled animated:NO];
        
        [notifCell.vibrateSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingVibrateKey withDefault:YES]];
        
        [notifCell.RingSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingRingKey withDefault:YES]];
        
        [notifCell.mingleRequestSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingMingleKey withDefault:YES]];
        
        [notifCell.startedMinglingSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingStartedMingleKey withDefault:YES]];
        
        [notifCell.eventRecommendSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingEventRecommendationsKey withDefault:YES]];
        
        [notifCell.eventInviteSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingEventInvitesKey withDefault:YES]];
        
        [notifCell.commentSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingCommentsKey withDefault:YES]];
        
        [notifCell.eventCancelSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingEventCanceledKey withDefault:YES]];
        
        [notifCell.peopleJoinSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingPeopleJoinKey withDefault:YES]];
        
        [notifCell.peopleLeaveSwitch setOn:[ZPAUserDefault getBoolWithKey:kZeppaSettingPeopleLeaveKey withDefault:YES]];
        
        return notifCell;
        
    }else if(indexRow == TABLE_ROW_INDEX_PRIVACY){
        
        static NSString *userProfileCellId = @"PrivacyPolicyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userProfileCellId];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if(indexRow == TABLE_ROW_INDEX_CONDITIONS){
        
        static NSString *userProfileCellId = @"TermsOfUseCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userProfileCellId];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        return cell;

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (indexPath.row == TABLE_ROW_INDEX_PUSH_NOTIFICATION && isNotifEnabled) {
        if (isManagePushNotifsActive) {
            return 487;
        }
        return 172;
    }

    return 44.0;
    
}


///**************************
#pragma mark - Action Methods
///**************************

- (IBAction)pushNotifBtnTapped:(UIButton *)sender {
    
    isNotifEnabled = !pushSwitch.on;
    [pushSwitch setOn:isNotifEnabled animated:YES];
    [ZPAUserDefault storedObject:[NSNumber numberWithBool:isNotifEnabled] withKey:kZeppaSettingNotificationKey];
    
    [self.tableView reloadData];
}
- (IBAction)pushNotifSwitch:(UISwitch *)sender {
    
    [self pushNotifBtnTapped:nil];
}


- (IBAction)managePushBtnPressed:(UIButton *)sender {
    
    isManagePushNotifsActive = !sender.selected;
    sender.selected = isManagePushNotifsActive;
    [self.tableView reloadData];
}


- (IBAction)seePrivacyTapped:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:urlPrivacyPolicy];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)seeTermsTapped:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:urlTermsOfUse];
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)logoutTapped:(UIButton *)sender {

    // TODO: raise prompt to logout
    
//    [[ZPAAuthenticatonHandler sharedAuth] logout];
    
}
- (IBAction)deleteAccountTapped:(UIButton *)sender {
    
    // TODO: raise prompt to delete account
    
//    [self showActivityIndicator];
//    
//    NSNumber *num = [ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier;
//    GTLQueryZeppaclientapi *removeZeppaUser = [GTLQueryZeppaclientapi queryForRemoveCurrentZeppaUserWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken] ];
//    
//    [[self zeppaUserService] executeQuery:removeZeppaUser completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
//        if(error){
//            // error
//        } else {
//            [self hideActivityIndicator];
//            [[ZPAAuthenticatonHandler sharedAuth] logout];
//        }
//    }];
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


-(void)setTrueOrFalseOnSwitch:(UISwitch *)currentSwitch withkey:(NSString *)key{
    
    BOOL value = !currentSwitch.isOn;
   
    [ZPAUserDefault storedObject:[NSNumber numberWithBool:currentSwitch.isOn] withKey:key];
    [currentSwitch setOn:value animated:YES];
    
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
