//
//  ZPAMutualMinglerVC.m
//  Zeppa
//
//  Created by Faran on 02/05/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAMutualMinglerVC.h"
#import "ZPAZeppaUserSingleton.h"
#import "UIImageView+WebCache.h"
#import "ZPAUserProfileVC.h"
#import "ZPAZeppaEventTagSingleton.h"



#define SEGUE_ID_SHOW_USERPROFILE             @"showminglersProfile"



@implementation ZPAMutualMinglerVC

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
    
    NSLog(@"%@",_minglerUserInfo.minglersIds);
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    
    if ([segue.identifier isEqualToString:SEGUE_ID_SHOW_USERPROFILE]) {
        
        ZPAUserProfileVC *userProfile = segue.destinationViewController;
        
        ZPADefaulZeppatUserInfo * defaultZeppaUserInfo=[[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[[_minglerUserInfo.minglersIds objectAtIndex:indexPath.row] longLongValue]];
        
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


///****************************************************
#pragma mark - TableView DataSource
///****************************************************

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _minglerUserInfo.minglersIds.count ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *mingelerCell = @"MinglerCell";
    ZPACommonMinglersCell *cell = [tableView dequeueReusableCellWithIdentifier:mingelerCell];
        
    ZPADefaulZeppatUserInfo * user=[[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[[_minglerUserInfo.minglersIds objectAtIndex:indexPath.row] longLongValue]];
        
        cell.lbl_commonMinglersName.text =[NSString stringWithFormat:@"%@ %@",user.zeppaUserInfo.givenName,user.zeppaUserInfo.familyName];
        
        NSURL *minglerImageUrl = [NSURL URLWithString:user.zeppaUserInfo.imageUrl];
        [cell.imageView_CommonMinglersImage setImageWithURL:minglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            ///Do anything with image
            
        }];
    
   
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    return [[UIView alloc]initWithFrame:CGRectZero];
}

@end
