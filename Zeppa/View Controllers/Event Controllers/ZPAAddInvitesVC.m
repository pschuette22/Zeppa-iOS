//
//  ZPAAddInvitesVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 10/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAAddInvitesVC.h"
#import "ZPAAddEventVC.h"

#import "UIImageView+WebCache.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaultZeppaUserInfo.h"


@interface ZPAAddInvitesVC ()
@end

@implementation ZPAAddInvitesVC{
    
    NSString *inviteeCandidate;
}

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
    // Do any additional setup after loading the view.
    
    
    [_navigataionBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    self.title = NSLocalizedString(@"Add Invites", nil);
    
    
    if (!_invitesUserIdArray) {
        _invitesUserIdArray = [[NSMutableArray alloc]init];
    }
   
    
    ///Insert Dummy Invitees candidate for now
//    self.arrInviteesCandidate = [[[ZPAZeppaUserSingleton sharedObject] getZeppaMinglerUsers] mutableCopy];
//    
//    
//    NSMutableArray * arr = [NSMutableArray arrayWithArray:_arrInviteesCandidate];
//    int i =0;
//    for (ZPADefaultZeppaUserInfo *userInfo in arr) {
//        i ++;
//        if (_zeppaEvent && [userInfo.userId isEqualToNumber:_zeppaEvent.event.hostId]) {
//            
//            [_arrInviteesCandidate removeObject:userInfo];
//        }
//        for (NSString * invitedUser in _zeppaEvent.event.invitedUserIds) {
//            
//            if ([invitedUser isEqualToString:[UserInfo.userId stringValue]]) {
//                 [_arrInviteesCandidate removeObject:UserInfo];
//                
//                if(_arrInviteesCandidate.count ==0) {
//                    
//                }
//            }
//        }
//    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [self performSegueWithIdentifier:@"unwindToEvents" sender:self];
    
    if (_delegate && [_delegate respondsToSelector:@selector(noOfInvitees)]) {
        [_delegate noOfInvitees];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    if ([segue.identifier isEqualToString:@"unwindToAddEvent"]) {
//        ZPAAddEventVC *addEvent = segue.destinationViewController;
//        addEvent.
//    }
//}
//****************************************************
#pragma mark - UITableViewDataSource
//****************************************************

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrInviteesCandidate.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *strAddInviteCellId = @"ZPAAddInviteCell";
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:strMinglerCellId];
    //    cell.textLabel.text = @"test";
    //
    //    return cell;
    
    _addInviteCell = [tableView dequeueReusableCellWithIdentifier:strAddInviteCellId];
    _addInviteCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZPADefaultZeppaUserInfo *userInfo = [self.arrInviteesCandidate objectAtIndex:indexPath.row];
    if ([_invitesUserIdArray containsObject:userInfo.userId]) {
        _addInviteCell.btnToggleCheckmark.selected = YES;
    }else{
        _addInviteCell.btnToggleCheckmark.selected = NO;
    }
    
    [_addInviteCell showDetailOnCell:userInfo];
    
    
    if (!_addInviteCell) {
        NSLog(@"Add Invite cell is empty");
    }
    
    
    
    inviteeCandidate = [self.arrInviteesCandidate objectAtIndex:indexPath.row];
//    /*
//     NSURL *minglerImageUrl = [NSURL URLWithString:mingler.endPointUser.userInfo.imageUrl];
//     [minglerCell.imageView_MinglerProfilePic setImageWithURL:minglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//     
//     ///Do anything with image
//     
//     }];
//     */
//    
//    addInviteCell.lblInviteeName.text = inviteeCandidate;
//    
    
//    if ([self.arrInvitedUsers containsObject:inviteeCandidate]) {
//        _addInviteCell.btnToggleCheckmark.selected = YES;
//    }
//    else{
//        _addInviteCell.btnToggleCheckmark.selected = NO;
//    }
//
    
  return _addInviteCell;
    
}


//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//   // NSString *inviteeCandidate = [self.arrInviteesCandidate objectAtIndex:indexPath.row];
//    if ([self.arrInvitedUsers containsObject:[self.arrInviteesCandidate objectAtIndex:indexPath.row]]) {
//        [self.arrInvitedUsers removeObject:[self.arrInviteesCandidate objectAtIndex:indexPath.row]];
//        
//    }
//    else{
//        [self.arrInvitedUsers addObject:[self.arrInviteesCandidate objectAtIndex:indexPath.row]];
//    }
//     NSLog(@"%@",self.arrInvitedUsers);
//    
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//
    static NSString *strAddInviteCellId = @"ZPAAddInviteCell";
    _addInviteCell = [tableView dequeueReusableCellWithIdentifier:strAddInviteCellId];

    
    ZPADefaultZeppaUserInfo *userInfo = [self.arrInviteesCandidate objectAtIndex:indexPath.row];
    
    
    if (![_invitesUserIdArray containsObject:userInfo.userId]) {
        
       // [_addInviteCell.btnToggleCheckmark setSelected:YES];
        [_invitesUserIdArray addObject:userInfo.userId];
    }else{
      //  [_addInviteCell.btnToggleCheckmark setSelected:NO];
        [_invitesUserIdArray removeObject:userInfo.userId];
    }
    NSLog(@"user ids %@",_invitesUserIdArray);
    
    [_tableView reloadData];

   

}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 44.0f;
    
}

- (IBAction)toggleCheckMarkBtnTapped:(UIButton *)sender {
    
   
    
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%ld",(long)indexPath.row);
    
    ZPADefaultZeppaUserInfo *userInfo = [self.arrInviteesCandidate objectAtIndex:indexPath.row];
    
    
    if (sender.selected == NO) {
        sender.selected = YES;
        [_invitesUserIdArray addObject:userInfo.userId];
    }else{
        sender.selected = NO;
        [_invitesUserIdArray removeObject:userInfo.userId];
    }
    NSLog(@"user ids %@",_invitesUserIdArray);
    
    [_tableView reloadData];
}

- (IBAction)doneBtnTapped:(UIBarButtonItem *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(noOfInvitees)]) {
        [_delegate noOfInvitees];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)cancelBtnTapped:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
   
}


@end
