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
    ZPADefaulZeppatUserInfo *user;
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
    
    [self configure];
    [self callZeppaApi];
    
    alert = [[UIAlertView alloc]initWithTitle:@"Finding People" message:@"This takes a bit, especially if you have a lot of contacts. So sit back, relax and enjoy the day" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///****************************************************
#pragma mark - TableView DataSource
///****************************************************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _zeppaMinglerUser.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    user = [_zeppaMinglerUser objectAtIndex:indexPath.row];
    if (( user.relationship == nil) || ([user.relationship.creatorId longLongValue] == [[ZPAZeppaUserSingleton sharedObject].userId longLongValue])) {
        
        static NSString *userEventCellId = @"RequestMinglersCell";
        ZPARequestMinglersCell *cell = [tableView dequeueReusableCellWithIdentifier:userEventCellId];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [cell showDetailOnCell:user];
        return cell;
        
    }
    else {
        static NSString *userEventCellId = @"ComfirmedMinglersCell";
        ZPAConfirmedMinglerCell *cell = [tableView dequeueReusableCellWithIdentifier:userEventCellId];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [cell showDetailOnCell:user];
        
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
    
    user = [_zeppaMinglerUser objectAtIndex:indexPath.row];
    
    [self removeUserToUserRelationShip:user];
    
   
    [_zeppaMinglerUser removeObject:user];
    
    [self.tableView reloadData];
    
   

    
}

- (IBAction)acceptBtnTapped:(UIButton *)sender {
    
    
    [sender setImage:[UIImage imageNamed:@"check_mark_selected.png"] forState:UIControlStateNormal];
    
    NSIndexPath *indexPath =[self getIndexPathOfRowWithBtnClick:sender];
    
    user = [_zeppaMinglerUser objectAtIndex:indexPath.row];
    
    
    [self updateUserToUserRelationShip:user];
    
}

- (IBAction)requestBtnTapped:(UIButton *)sender {
    
//    CGPoint center= sender.center;
//    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
//    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
//    NSLog(@"%@",indexPath);
    
    NSIndexPath *indexPath =[self getIndexPathOfRowWithBtnClick:sender];
    
    user = [_zeppaMinglerUser objectAtIndex:indexPath.row];
    
    
    if (user.relationship == nil ) {
        [self inserZeppaUserToUserRelationship:user];
       // [sender setTitle:@"Requested" forState:UIControlStateNormal];
        
    }else{
        [sender setTitle:@"Request" forState:UIControlStateNormal];
        [self removeUserToUserRelationShip:user];
        
        [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:user.zeppaUserInfo andRelationShip:nil];
        
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
-(void)inserZeppaUserToUserRelationship:(ZPADefaulZeppatUserInfo *)userInfo{
    
    
    GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *relationship = [[GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship alloc] init];
    
    [relationship setCreatorId:[[ZPAZeppaUserSingleton sharedObject] userId]];
    [relationship setSubjectId:userInfo.userId];
    [relationship setRelationshipType:@"PENDING_REQUEST"];
    
    
    GTLQueryZeppausertouserrelationshipendpoint *insertU2URelationshipTask = [GTLQueryZeppausertouserrelationshipendpoint queryForInsertZeppaUserToUserRelationshipWithObject:relationship];
    
    [self.zeppaUserToUserRelationship executeQuery:insertU2URelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *response, NSError *error) {
        //
        
        if(error){
           
        } else if ( response.identifier){
            
           [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:userInfo.zeppaUserInfo andRelationShip:response];
            
            [self updateMingler];
            

            
        } else {
//            [resultView setText:@"Error Inserting ZeppaUserToUserRelationship"];
        }
        
    }];

    
    
}

-(void)updateUserToUserRelationShip:(ZPADefaulZeppatUserInfo *)userInfo{
    
    GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship *relationship = [[GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship alloc] init];
    
     relationship = userInfo.relationship;
    [relationship setRelationshipType:@"MINGLING"];
    
    
    GTLQueryZeppausertouserrelationshipendpoint *updateU2URelationshipTask = [GTLQueryZeppausertouserrelationshipendpoint queryForUpdateZeppaUserToUserRelationshipWithObject:relationship];
    
    [self.zeppaUserToUserRelationship executeQuery:updateU2URelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship  *response, NSError *error) {
        //
        
        if(error){
            
        } else if ( response.identifier){
            
           
            
           [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:userInfo.zeppaUserInfo andRelationShip:response];
            
            [self updateMingler];
           
            
        } else {
            //            [resultView setText:@"Error Inserting ZeppaUserToUserRelationship"];
        }
        
    }];
    

}

-(void)removeUserToUserRelationShip:(ZPADefaulZeppatUserInfo *)userInfo{
    

    GTLQueryZeppausertouserrelationshipendpoint *updateU2URelationshipTask = [GTLQueryZeppausertouserrelationshipendpoint queryForRemoveZeppaUserToUserRelationshipWithRelationshipId:[userInfo.relationship.identifier longLongValue] userId:[ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier.longLongValue];
    
    [self.zeppaUserToUserRelationship executeQuery:updateU2URelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppausertouserrelationshipendpointZeppaUserToUserRelationship  *response, NSError *error) {
        //
        
        if(error){
            // TODO: notify user there was an issue removing relationship from DB
        } else if ( response.identifier){
            
//            [[ZPAZeppaUserSingleton sharedObject] addDefaultZeppaUserMediatorWithUserInfo:userInfo.zeppaUserInfo andRelationShip:response];
////            
//            [self updateMingler];
            //
            
        } else {
            //            [resultView setText:@"Error Inserting ZeppaUserToUserRelationship"];
        }
        
    }];
    
    
}


-(GTLServiceZeppausertouserrelationshipendpoint *)zeppaUserToUserRelationship{
    
    static GTLServiceZeppausertouserrelationshipendpoint *service = nil;
    if(!service){
        service = [[GTLServiceZeppausertouserrelationshipendpoint alloc] init];
        service.retryEnabled = YES;
    }
    // Set Auth that is held in the delegate
    [service setAuthorizer: [ZPAAuthenticatonHandler sharedAuth].auth];
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


@end
