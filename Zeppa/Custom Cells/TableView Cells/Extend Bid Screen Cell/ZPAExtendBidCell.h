//
//  ZPAExtendBidCell.h
//  Zeppa
//
//  Created by Milan Agarwal on 05/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPAExtendBidCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_UserPic;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UIButton *btnDisclosureIndicator;
@property (assign ,nonatomic) BOOL selectedRow;
@property (weak, nonatomic) IBOutlet UIView *separtersView;
@property (weak, nonatomic) IBOutlet UIButton *btnTextMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnEmail;

@end
