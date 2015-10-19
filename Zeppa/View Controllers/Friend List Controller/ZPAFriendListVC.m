//
//  ZPAFriendListVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAFriendListVC.h"
#import "ZPAUserProfileVC.h"
#import "ZPAUserProfileCell.h"

#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaulZeppatUserInfo.h"
#import "ZPAMyZeppaUser.h"

#import "ZPAZeppaEventTagSingleton.h"

#import "GTLZeppaclientapiZeppaUserInfo.h"

#import "ZPAMinglerCell.h"
#import "UIImageView+WebCache.h"



#define SEGUE_ID_SHOW_USERPROFILE             @"showUserProfile"


@interface ZPAFriendListVC ()

@property (nonatomic, strong)NSMutableArray *arrMinglers;

@end

@implementation ZPAFriendListVC

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
    self.navigationController.navigationBar.topItem.title = @"";
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    self.title = NSLocalizedString(@"You Mingle With", nil);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.arrMinglers = [[[ZPAZeppaUserSingleton sharedObject] getZeppaMinglerUsers] mutableCopy];
//    
//    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"zeppaUserInfo.givenName" ascending:YES];
//    
//    [self.arrMinglers sortUsingDescriptors:@[sortDescriptor]];


}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:SEGUE_ID_SHOW_USERPROFILE]) {
        
        ZPAUserProfileVC *userProfile = segue.destinationViewController;
        
        ZPADefaulZeppatUserInfo *defaultZeppaUserInfo = [self.arrMinglers objectAtIndex:indexPath.row];
        
        NSString * str = [NSString stringWithFormat:@"%@ %@", defaultZeppaUserInfo.zeppaUserInfo.givenName,defaultZeppaUserInfo.zeppaUserInfo.familyName];
        
        NSLog(@"name %@",str);
        
        userProfile.userProfileInfo = defaultZeppaUserInfo;
        
       userProfile.userTagArray = [[[ZPAZeppaEventTagSingleton sharedObject] getZeppaTagForUser:[defaultZeppaUserInfo.userId longLongValue]]mutableCopy];
       
        NSLog(@"userTag %@",userProfile.userTagArray);
    }
    else{
        //AddViewController *avc = segue.destinationViewController;
    }
//     AddViewController *avc = segue.destinationViewController;
}


-(IBAction)unWindFromUserProfileWithUnmigleBtn:(UIStoryboardSegue *)segue{
    
    
    ZPAUserProfileVC  * userProfileVC = segue.sourceViewController;
    
    if ([userProfileVC isKindOfClass:[ZPAUserProfileVC class]]) {
        NSLog(@"unwindToEvents");
        
         self.arrMinglers = [[[ZPAZeppaUserSingleton sharedObject] getZeppaMinglerUsers] mutableCopy];
        
        [_tableView reloadData];
    }
    

}
//****************************************************
#pragma mark - UITableViewDataSource
//****************************************************

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMinglers.count;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *strMinglerCellId = @"ZPAMinglerCell";    
    ZPAMinglerCell *minglerCell = [tableView dequeueReusableCellWithIdentifier:strMinglerCellId];
    if (!minglerCell) {
        NSLog(@"Mingler cell is empty");
    }
    
    UIView *bgView = [[UIView alloc]initWithFrame:(CGRect){0,0,tableView.bounds.size.width,minglerCell.bounds.size.height}];
    bgView.backgroundColor = [ZPAStaticHelper zeppaThemeColor];
    minglerCell.selectedBackgroundView = bgView;

    
    ZPADefaulZeppatUserInfo *userInfo = [self.arrMinglers objectAtIndex:indexPath.row];
    
    [minglerCell showZeppaMinglersInfoOnCell:userInfo];
    
    return minglerCell;
   
}

//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 68.0f;
}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"Deselect %d",(int)indexPath.row);
//    ZPAMinglerCell * minglerCell = (ZPAMinglerCell *)[tableView cellForRowAtIndexPath:indexPath];
//   minglerCell.btnDisclosureIndicator.selected = NO;
//    minglerCell
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

/*
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsMake(8, 8, 8, 8)];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsMake(8, 8, 8, 8)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(8, 8, 8, 8)];
        cell.preservesSuperviewLayoutMargins = NO;
    }
}


-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
*/

@end
