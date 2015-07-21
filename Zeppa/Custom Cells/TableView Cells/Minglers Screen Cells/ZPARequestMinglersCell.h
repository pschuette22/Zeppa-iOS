//
//  ZPARequestMinglersCell.h
//  Zeppa
//
//  Created by Faran on 04/05/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPADefaulZeppatUserInfo.h"
#import "UIImageView+WebCache.h"

@interface ZPARequestMinglersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_requestUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_requestUserImage;
@property (weak, nonatomic) IBOutlet UIButton *btn_requestButton;

- (IBAction)RequestedBtnTapped:(UIButton *)sender;

-(void)showDetailOnCell:(ZPADefaulZeppatUserInfo *)userInfo;

@end
