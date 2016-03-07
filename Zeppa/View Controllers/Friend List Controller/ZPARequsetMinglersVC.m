//
//  ZPARequsetMinglersVC.m
//  Zeppa
//
//  Created by Dheeraj on 11/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPARequsetMinglersVC.h"
#import "ZPAZeppaUserSingleton.h"
#import "MBProgressHUD.h"



#define TABLE_ROW_INDEX_COMFIRMED 0
#define TABLE_ROW_INDEX_REQUEST 1

@interface ZPARequsetMinglersVC ()<FindMinglerDelegate>

@end

@implementation ZPARequsetMinglersVC{
    
    UIAlertView *alert;
    MBProgressHUD * progress;
}
///**********************************************
#pragma mark - View Life Cycle Methods
///**********************************************
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
    
    self.title = NSLocalizedString(@"Start Mingling", nil);
    // Register the observer for this notification...
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNotification:) name:kNotifDidFinishFindFriendsTask object:nil];
    [self configure];
    [self callZeppaApi];
    
    alert = [[UIAlertView alloc]initWithTitle:@"Finding People" message:@"This takes a bit, especially if you have a lot of contacts. So sit back, relax and enjoy the day" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    // TODO: add a refresh controller
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
    
///****************************************************
#pragma mark - TableView DataSource
///****************************************************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _zeppaMinglerUser.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZPADefaultZeppaUserInfo *userInfo = [_zeppaMinglerUser objectAtIndex:indexPath.row];
    if (( userInfo.relationship == nil) || ([userInfo.relationship.creatorId longLongValue] == [[[ZPAZeppaUserSingleton sharedObject] getMyZeppaUserIdentifier] longLongValue])) {
        
        static NSString *userEventCellId = @"RequestMinglersCell";
        ZPARequestMinglersCell *cell = [tableView dequeueReusableCellWithIdentifier:userEventCellId];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [cell showDetailOnCell:userInfo];
        
        return cell;
        
    }
    else {
        static NSString *userEventCellId = @"ComfirmedMinglersCell";
        ZPAConfirmedMinglerCell *cell = [tableView dequeueReusableCellWithIdentifier:userEventCellId];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [cell showDetailOnCell:userInfo];
        
        return cell;
        
    }
    return nil;
}
//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

///@todo need to implement below methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
///**********************************************
#pragma mark - Configure
///**********************************************
-(void)configure{
    _zeppaMinglerUser = [NSMutableArray array];
    _refreshControl = [[UIRefreshControl alloc]init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data..."];
    
    [self.tableView addSubview:_refreshControl];
    [_refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

///**********************************************
#pragma mark - Actions Methods
///**********************************************

- (IBAction)deniedBtnTapped:(UIButton *)sender {
//    
//    CGPoint center= sender.center;
//    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
//    NSLog(@"%@",indexPath);
    [sender setImage:[UIImage imageNamed:@"cross_unselected.png"] forState:UIControlStateNormal];

    NSIndexPath *indexPath =[self getIndexPathOfRowWithBtnClick:sender];
    
    ZPADefaultZeppaUserInfo *userInfo = [_zeppaMinglerUser objectAtIndex:indexPath.row];
    
    [self removeUserToUserRelationShip:userInfo];
    
   
    [_zeppaMinglerUser removeObject:userInfo];
    
    [self.tableView reloadData];
    
   

    
}

- (IBAction)acceptBtnTapped:(UIButton *)sender {
    
    
    [sender setImage:[UIImage imageNamed:@"check_mark_selected.png"] forState:UIControlStateNormal];
    
    NSIndexPath *indexPath =[self getIndexPathOfRowWithBtnClick:sender];
    
    ZPADefaultZeppaUserInfo *userInfo = [_zeppaMinglerUser objectAtIndex:indexPath.row];
    
    
    [self updateUserToUserRelationShip:userInfo];
    
}

- (IBAction)requestBtnTapped:(UIButton *)sender {
    
//    CGPoint center= sender.center;
//    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
//    NSLog(@"%@",indexPath);
    
    NSIndexPath *indexPath =[self getIndexPathOfRowWithBtnClick:sender];
    
    ZPADefaultZeppaUserInfo *userInfo = [_zeppaMinglerUser objectAtIndex:indexPath.row];
    
    
    if (userInfo.relationship == nil ) {
        [self inserZeppaUserToUserRelationship:userInfo];
       // [sender setTitle:@"Requested" forState:UIControlStateNormal];
        
    }else{
        [sender setTitle:@"Request" forState:UIControlStateNormal];
        [self removeUserToUserRelationShip:userInfo];
        
        [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:userInfo.userInfo andRelationShip:nil];
        
        [self updateMingler];
        
    }
    
  
    
    
    
}

-(NSIndexPath *)getIndexPathOfRowWithBtnClick:(UIButton *)sender{
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%@",indexPath);
    
    return indexPath;

}

//****************************************************
#pragma mark - UIRefresh Control
//****************************************************
- (void)refreshTable:(UIRefreshControl *)refresh {
    
    [_refreshControl endRefreshing];
    [self.tableView reloadData];
}
///**********************************************
#pragma mark - Zeppa Api Call
///**********************************************
-(void)callZeppaApi{
    
    _findMingler = [[ZPAFindMinglers alloc]init];
    _findMingler.delegate = self;
    [_findMingler executeZeppaApi];
    
}
-(void)inserZeppaUserToUserRelationship:(ZPADefaultZeppaUserInfo *)userInfo{
    
    
    GTLZeppaclientapiZeppaUserToUserRelationship *relationship = [[GTLZeppaclientapiZeppaUserToUserRelationship alloc] init];
    
    [relationship setCreatorId:[[ZPAZeppaUserSingleton sharedObject] getMyZeppaUserIdentifier]];
    [relationship setSubjectId:userInfo.userId];
    [relationship setRelationshipType:@"PENDING_REQUEST"];
    
    
    GTLQueryZeppaclientapi *insertU2URelationshipTask = [GTLQueryZeppaclientapi queryForInsertZeppaUserToUserRelationshipWithObject:relationship idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaUserToUserRelationship executeQuery:insertU2URelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUserToUserRelationship *response, NSError *error) {
        //
        
        if(error){
           
        } else if ( response.identifier){
            
            [userInfo setRelationship:response];
            
            [self updateMingler];

            
        } else {
//            [resultView setText:@"Error Inserting ZeppaUserToUserRelationship"];
        }
        
    }];

    
    
}

-(void)updateUserToUserRelationShip:(ZPADefaultZeppaUserInfo *)userInfo{
    
    GTLZeppaclientapiZeppaUserToUserRelationship *relationship = [[GTLZeppaclientapiZeppaUserToUserRelationship alloc] init];
    
     relationship = userInfo.relationship;
    [relationship setRelationshipType:@"MINGLING"];
    
    
    GTLQueryZeppaclientapi *updateU2URelationshipTask = [GTLQueryZeppaclientapi queryForUpdateZeppaUserToUserRelationshipWithObject:relationship idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaUserToUserRelationship executeQuery:updateU2URelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUserToUserRelationship  *response, NSError *error) {
        //
        
        if(error){
            
        } else if ( response.identifier){
            
           
            
           [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:userInfo.userInfo andRelationShip:response];
            
            [self updateMingler];
           
            
        } else {
            //            [resultView setText:@"Error Inserting ZeppaUserToUserRelationship"];
        }
        
    }];
    

}

-(void)removeUserToUserRelationShip:(ZPADefaultZeppaUserInfo *)userInfo{
    

    GTLQueryZeppaclientapi *updateU2URelationshipTask = [GTLQueryZeppaclientapi queryForRemoveZeppaUserToUserRelationshipWithIdentifier:[userInfo.relationship.identifier longLongValue] idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaUserToUserRelationship executeQuery:updateU2URelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUserToUserRelationship  *response, NSError *error) {
        //
        
        if(error){
            // TODO: notify user there was an issue removing relationship from DB
        } else {
            
            [userInfo setRelationship:nil];

            
        }
        
    }];
    
    
}


-(GTLServiceZeppaclientapi *)zeppaUserToUserRelationship{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}


///**********************************************
#pragma mark - FindingMingler Delegate
///**********************************************
-(void)finishLoadingMingler{
    
    if (_zeppaMinglerUser.count>0) {
        [_zeppaMinglerUser removeAllObjects];
    }
    
    _possibleConnectionZeppaUser = [NSArray arrayWithArray:[[ZPAZeppaUserSingleton sharedObject] getPossibleFriendInfoMediators]];
    
    _pendingRequestZeppaUser = [NSArray arrayWithArray:[[ZPAZeppaUserSingleton sharedObject] getPendingFriendRequests]];
    
    
    [_zeppaMinglerUser addObjectsFromArray:_possibleConnectionZeppaUser];
    [_zeppaMinglerUser addObjectsFromArray:_pendingRequestZeppaUser];
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
        [progress hide:YES];
});
    
}
-(void)updateMingler{
    
    if (_zeppaMinglerUser.count>0) {
        [_zeppaMinglerUser removeAllObjects];
    }
    
    _possibleConnectionZeppaUser = [NSArray arrayWithArray:[[ZPAZeppaUserSingleton sharedObject] getPossibleFriendInfoMediators]];
    
    _pendingRequestZeppaUser = [NSArray arrayWithArray:[[ZPAZeppaUserSingleton sharedObject] getPendingFriendRequests]];
    
    
    [_zeppaMinglerUser addObjectsFromArray:_possibleConnectionZeppaUser];
    [_zeppaMinglerUser addObjectsFromArray:_pendingRequestZeppaUser];
    
    
    
    [self.tableView reloadData];
}

- (void) didReceiveNotification:(NSNotification*) notification {
    
    
    if([notification.name isEqualToString:kNotifDidFinishFindFriendsTask]) {
        
        // If the alert is being displayed, dismiss it
        if(alert) {
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        }
        
        // If progress is being displayed, hide it
        if(progress) {
            [progress hide:YES];
        }
        
    }
    
}


@end
