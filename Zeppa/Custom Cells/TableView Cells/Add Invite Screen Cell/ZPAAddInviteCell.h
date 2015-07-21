//
//  ZPAAddInviteCell.h
//  Zeppa
//
//  Created by Milan Agarwal on 10/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaulZeppatUserInfo.h"


@interface ZPAAddInviteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Invitee;
@property (weak, nonatomic) IBOutlet UILabel *lblInviteeName;
@property (weak, nonatomic) IBOutlet UIButton *btnToggleCheckmark;
- (IBAction)btnSelectUserTapped:(id)sender;


-(void)showDetailOnCell:(ZPADefaulZeppatUserInfo *)user;
@end
