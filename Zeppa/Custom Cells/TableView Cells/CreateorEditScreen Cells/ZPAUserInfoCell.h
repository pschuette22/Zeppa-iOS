//
//  ZPAUserInfoCell.h
//  Zeppa
//
//  Created by Milan Agarwal on 07/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPAUserInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnProfilePic;
@property (weak, nonatomic) IBOutlet UIView *view_ProfilePicContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_ProfilePic;
@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;
@property (weak, nonatomic) IBOutlet UITextField *txtLastname;
@property (weak, nonatomic) IBOutlet UIButton *btnContactNumber;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;

- (IBAction)btnEditProfilePicTapped:(UIButton *)sender;
@end
