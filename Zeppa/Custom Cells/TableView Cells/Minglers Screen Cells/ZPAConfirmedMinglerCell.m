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
    
    
}

- (IBAction)deniedBtnTapped:(UIButton *)sender {
    
}

-(void)showDetailOnCell:(ZPADefaulZeppatUserInfo *)userInfo{
    
    _lblUserName.text = [NSString stringWithFormat:@"%@ %@",userInfo.zeppaUserInfo.givenName,userInfo.zeppaUserInfo.familyName];
    
    NSURL *confrmedMinglerImageUrl = [NSURL URLWithString:userInfo.zeppaUserInfo.imageUrl];
    [_imageView_userImage setImageWithURL:confrmedMinglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        ///Do anything with image
        
    }];
    
    
}
@end
