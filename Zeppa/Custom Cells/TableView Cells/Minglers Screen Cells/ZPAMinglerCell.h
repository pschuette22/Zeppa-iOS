//
//  ZPAMinglersCell.h
//  Zeppa
//
//  Created by Milan Agarwal on 04/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPAMyZeppaUser.h"

#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaultZeppaUserInfo.h"

@interface ZPAMinglerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_MinglerProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblMinglerName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommonMinglers;
@property (weak, nonatomic) IBOutlet UIButton *btnDisclosureIndicator;

-(void)showZeppaMinglersInfoOnCell:(ZPADefaultZeppaUserInfo *)zeppaUser;
@end
