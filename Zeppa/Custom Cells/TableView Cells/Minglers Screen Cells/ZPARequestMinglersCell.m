//
//  ZPARequestMinglersCell.m
//  Zeppa
//
//  Created by Faran on 04/05/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPARequestMinglersCell.h"

@implementation ZPARequestMinglersCell

- (void)awakeFromNib {
    // Initialization code
    [self.btn_requestButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
    [ZPAStaticHelper setCornarRadiusofView:self.btn_requestButton andRadius:3.0 withBordarColor:[ZPAStaticHelper zeppaThemeColor] andBordarWidth:1.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)RequestedBtnTapped:(UIButton *)sender {
    
}


-(void)showDetailOnCell:(ZPADefaultZeppaUserInfo *)userInfo{
    
    _lbl_requestUserName.text = userInfo.getDisplayName;
    
    NSURL *confrmedMinglerImageUrl = [NSURL URLWithString:userInfo.userInfo.imageUrl];
    [_imageView_requestUserImage setImageWithURL:confrmedMinglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        ///Do anything with image
        
    }];
    
    
    
    if ([userInfo isPendingRequest] && [userInfo didSendRequest]) {
        [_btn_requestButton setTitle:@"Requested" forState:UIControlStateNormal];
        [_btn_requestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_requestButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
        
    }else if (![userInfo isPendingRequest]){
        [_btn_requestButton setTitle:@"Request" forState:UIControlStateNormal];
        
        _btn_requestButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        
        [_btn_requestButton setBackgroundColor:[UIColor whiteColor]];
        [_btn_requestButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _btn_requestButton.layer.borderWidth = 1.0;
    }
}

@end
