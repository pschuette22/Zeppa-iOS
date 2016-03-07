//
//  ZPAUserProfileCell.h
//  Zeppa
//
//  Created by Dheeraj on 10/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaultZeppaUserInfo.h"

#import "ZPAAppData.h"

@interface ZPAUserProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view_BaseView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_UserProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnContactNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (strong, nonatomic) IBOutlet UIView *tagBaseView;
@property (weak, nonatomic) IBOutlet UIButton *commonMinglerButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tcHeightConstraint;


-(void)showZeppaMinglersInfoOnCell:(ZPADefaultZeppaUserInfo *)zeppaUser;
@end
