//
//  ZPAUserProfileCell.m
//  Zeppa
//
//  Created by Dheeraj on 10/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAUserProfileCell.h"
#import "UIImageView+WebCache.h"
#import "ZPAMyZeppaUser.h"

@implementation ZPAUserProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(void)layoutSubviews
{
    self.imageView_UserProfile.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.imageView_UserProfile.layer.borderWidth = 1.0f;
    self.imageView_UserProfile.layer.cornerRadius = 10.0f;
    self.imageView_UserProfile.layer.masksToBounds = YES;
    
}
- (IBAction)commonMinglerBtn:(UIButton *)sender {
}

-(void)showZeppaMinglersInfoOnCell:(ZPADefaultZeppaUserInfo *)zeppaUser{
    
//    if(zeppaUser.zeppaUserInfo.primaryUnformattedNumber.length >0){
//        _btnContactNumber.hidden = NO;
//    }else{
//        _btnContactNumber.hidden = YES;
//    }
    
    NSURL *minglerImageUrl = [NSURL URLWithString:zeppaUser.userInfo.imageUrl];
    [_imageView_UserProfile setImageWithURL:minglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        ///Do anything with image
        
    }];
    _lblUserName.text = zeppaUser.getDisplayName;
    
//    //[_btnContactNumber setTitle:zeppaUser.zeppaUserInfo.primaryUnformattedNumber forState:UIControlStateNormal];
//    [_btnEmail setTitle:zeppaUser.zeppaUserInfo.googleAccountEmail forState:UIControlStateNormal];
//    [_btnContactNumber setTitle:[self getFormattedNumber:zeppaUser.zeppaUserInfo.primaryUnformattedNumber] forState:UIControlStateNormal];
   
}

-(NSString *)getFormattedNumber:(NSString *)number{
    
   
    
    if (number.length>0) {
        
        NSMutableString *str = [NSMutableString stringWithString:number];
        
        [str insertString:@"(" atIndex:0];
        [str insertString:@")" atIndex:4];
        [str insertString:@" " atIndex:5];
        [str insertString:@"-" atIndex:9];
        
        number = [str copy];
        return number;
    }
    
    
    
    return number;
}

@end
