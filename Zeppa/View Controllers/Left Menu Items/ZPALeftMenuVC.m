//
//  ZPALeftMenuVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPALeftMenuVC.h"
#import "ZPALeftMenuProfileCell.h"
#import "ZPALeftMenuItemCell.h"
#import "ZPAAppData.h"
#import "GTLZeppauserendpoint.h"
#import "UIImageView+WebCache.h"


@interface ZPALeftMenuVC ()

@end

@implementation ZPALeftMenuVC{
    BOOL isSelectedRow ;
    NSIndexPath * previousIndex;
}

//****************************************************
#pragma mark - Life Cycle
//****************************************************

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
    self.tableView.scrollEnabled = NO;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}

//****************************************************
#pragma mark - UITableViewDataSource Methods
//****************************************************

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TOTAL_ROWS;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == TABLE_ROW_INDEX_PROFILE) {
        return 88.0f;
    }
    return 56.0f;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld",(long)_currentSelectedIndex);
    NSInteger indexRow = indexPath.row;
    
    if(indexRow == TABLE_ROW_INDEX_PROFILE)
    {
        ZPAMyZeppaUser *user = [ZPAAppData sharedAppData].loggedInUser;
        ZPALeftMenuProfileCell *leftMenuProfileCell = [tableView dequeueReusableCellWithIdentifier:@"ZPALeftMenuProfileCell"];
        if (user.profileImage) {
            leftMenuProfileCell.imageView_Profile.image = user.profileImage;
        }
        else{
            NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
            
            if(profileImageURL){
                [leftMenuProfileCell.imageView_Profile setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                }];
            }else{
                [leftMenuProfileCell.imageView_Profile setImage:[UIImage imageNamed:@"default_user_image.png"]];
            }
        }
        leftMenuProfileCell.lblZeppaUserName.text = [NSString stringWithFormat:@"%@ %@",user.endPointUser.userInfo.givenName,user.endPointUser.userInfo.familyName];
        
        
        return leftMenuProfileCell;
        
    }
    else if (indexRow == TABLE_ROW_INDEX_HOME)
    {
        ZPALeftMenuItemCell *leftMenuItemHomeCell = [tableView dequeueReusableCellWithIdentifier:@"ZPALeftMenuItemCell"];
        leftMenuItemHomeCell.imageView_Item.image = [UIImage imageNamed:@"ic_home"];
        leftMenuItemHomeCell.lblMenuItem.text = @"Home";
        
        if (_currentSelectedIndex == indexRow) {
            leftMenuItemHomeCell.lblMenuItem.textColor = [UIColor whiteColor];
        }
        UIView *bgView = [[UIView alloc]initWithFrame:(CGRect){0,0,tableView.bounds.size.width,leftMenuItemHomeCell.bounds.size.height}];
        bgView.backgroundColor = [ZPAStaticHelper zeppaThemeColor];
        leftMenuItemHomeCell.selectedBackgroundView = bgView;
        
        return leftMenuItemHomeCell;
        
    }
    else if (indexRow == TABLE_ROW_INDEX_MINGLERS)
    {
        ZPALeftMenuItemCell *leftMenuItemMinglersCell = [tableView dequeueReusableCellWithIdentifier:@"ZPALeftMenuItemCell"];
        leftMenuItemMinglersCell.imageView_Item.image = [UIImage imageNamed:@"ic_minglers"];
        leftMenuItemMinglersCell.lblMenuItem.text = @"Minglers";
        
        if (_currentSelectedIndex == indexRow) {
            leftMenuItemMinglersCell.lblMenuItem.textColor = [UIColor whiteColor];
        }

        UIView *bgView = [[UIView alloc]initWithFrame:(CGRect){0,0,tableView.bounds.size.width,leftMenuItemMinglersCell.bounds.size.height}];
        bgView.backgroundColor = [ZPAStaticHelper zeppaThemeColor];
        leftMenuItemMinglersCell.selectedBackgroundView = bgView;

        
        return leftMenuItemMinglersCell;
        
    }
//    else if (indexRow == TABLE_ROW_INDEX_EXTEND_BID)
//    {
//        ZPALeftMenuItemCell *leftMenuItemExtendABidCell = [tableView dequeueReusableCellWithIdentifier:@"ZPALeftMenuItemCell"];
//        leftMenuItemExtendABidCell.imageView_Item.image = [UIImage imageNamed:@"ic_extend_bid"];
//        leftMenuItemExtendABidCell.lblMenuItem.text = @"Extend A Bid";
//        return leftMenuItemExtendABidCell;
//    }
    else if (indexRow == TABLE_ROW_INDEX_FEEDBACK)
    {
        ZPALeftMenuItemCell *leftMenuItemFeedbackCell = [tableView dequeueReusableCellWithIdentifier:@"ZPALeftMenuItemCell"];
        leftMenuItemFeedbackCell.imageView_Item.image = [UIImage imageNamed:@"ic_feedback"];
        leftMenuItemFeedbackCell.lblMenuItem.text = @"Feedback";
       
        if (_currentSelectedIndex == indexRow) {
            leftMenuItemFeedbackCell.lblMenuItem.textColor = [UIColor whiteColor];
        }
        UIView *bgView = [[UIView alloc]initWithFrame:(CGRect){0,0,tableView.bounds.size.width,leftMenuItemFeedbackCell.bounds.size.height}];
        bgView.backgroundColor = [ZPAStaticHelper zeppaThemeColor];
        leftMenuItemFeedbackCell.selectedBackgroundView = bgView;

        
        return leftMenuItemFeedbackCell;
    }
    else
    {
        ZPALeftMenuItemCell *leftMenuItemSettingsCell = [tableView dequeueReusableCellWithIdentifier:@"ZPALeftMenuItemCell"];
        leftMenuItemSettingsCell.imageView_Item.image = [UIImage imageNamed:@"ic_settings"];
        leftMenuItemSettingsCell.lblMenuItem.text = @"Settings";
        if (_currentSelectedIndex == indexRow) {
            leftMenuItemSettingsCell.lblMenuItem.textColor = [UIColor whiteColor];
        }
        
        UIView *bgView = [[UIView alloc]initWithFrame:(CGRect){0,0,tableView.bounds.size.width,leftMenuItemSettingsCell.bounds.size.height}];
        bgView.backgroundColor = [ZPAStaticHelper zeppaThemeColor];
        leftMenuItemSettingsCell.selectedBackgroundView = bgView;

          return leftMenuItemSettingsCell;
    }
    

}


//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZPALeftMenuItemCell * cell =(ZPALeftMenuItemCell *) [_tableView cellForRowAtIndexPath:previousIndex];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.lblMenuItem setTextColor:[UIColor blackColor]];

    isSelectedRow = YES;
    [_delegate didSelectMenuItemAtIndex:indexPath.row];
    
    
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_currentSelectedIndex == indexPath.row && _currentSelectedIndex!=0) {
        previousIndex = indexPath;
         [cell setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
        
    }else{
         [cell setBackgroundColor:[UIColor whiteColor]];
    }
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

@end
