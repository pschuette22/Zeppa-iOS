//
//  ZPAConfirmedMinglerCell.m
//  Zeppa
//
//  Created by Dheeraj on 09/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAConfirmedMinglerCell.h"

@implementation ZPAConfirmedMinglerCell

-(void)awakeFromNib{
    
    [self.acceptBtn setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
    //[ZPAStaticHelper setCornarRadiusofView:self.acceptBtn andRadius:3.0 withBordarColor:[ZPAStaticHelper zeppaThemeColor] andBordarWidth:1.0];
    
    [self.deniedBtn setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
   // [ZPAStaticHelper setCornarRadiusofView:self.deniedBtn andRadius:3.0 withBordarColor:[ZPAStaticHelper zeppaThemeColor] andBordarWidth:1.0];
}

- (IBAction)acceptBtnTapped:(UIButton *)sender {
    
    // Should update the relationship in the backend and load in new data
}

- (IBAction)deniedBtnTapped:(UIButton *)sender {
    // Should remove relationship in the backend
}

-(void)showDetailOnCell:(ZPADefaultZeppaUserInfo *)userInfo{
    
    _lblUserName.text = userInfo.getDisplayName;
    
    NSURL *confrmedMinglerImageUrl = [NSURL URLWithString:userInfo.userInfo.imageUrl];
    [_imageView_userImage setImageWithURL:confrmedMinglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        ///Do anything with image
        
    }];
    
    
}
@end
