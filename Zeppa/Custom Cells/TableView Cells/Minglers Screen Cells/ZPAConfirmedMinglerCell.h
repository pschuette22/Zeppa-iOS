//
//  ZPAConfirmedMinglerCell.h
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPADefaultZeppaUserInfo.h"
#import "UIImageView+WebCache.h"

@interface ZPAConfirmedMinglerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UIButton *deniedBtn;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_userImage;

- (IBAction)acceptBtnTapped:(UIButton *)sender;
- (IBAction)deniedBtnTapped:(UIButton *)sender;
-(void)showDetailOnCell:(ZPADefaultZeppaUserInfo *)userInfo;

@end
