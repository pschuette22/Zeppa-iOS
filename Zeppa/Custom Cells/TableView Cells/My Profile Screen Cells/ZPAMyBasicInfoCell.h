//
//  ZPAMyBasicInfoCell.h
//  Zeppa
//
//  Created by Milan Agarwal on 28/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPAMyBasicInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_MyProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UIButton *btnContactNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtNewTag;
@property (weak, nonatomic) IBOutlet UIView *view_NewTag;
@property (weak, nonatomic) IBOutlet UIButton *btnAddNewTag;
@property (weak, nonatomic) IBOutlet UIView *view_TagContainer;

@end
