//
//  ZPAMinglersCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 04/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAMinglerCell.h"
#import "UIImageView+WebCache.h"
#import "ZPADefaultZeppaUserInfo.h"
#import "ZPAAppData.h"



@implementation ZPAMinglerCell

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
    NSLog(@"%s --> Selected = %d",__PRETTY_FUNCTION__,selected);
    
    // Configure the view for the selected state
    self.btnDisclosureIndicator.selected = selected;

    
    if (selected) {
        ///Configure subviews for selected state
        self.lblMinglerName.textColor = [UIColor whiteColor];
        self.lblCommonMinglers.textColor = [UIColor whiteColor];
        
    }
    else{
        self.lblMinglerName.textColor = [UIColor blackColor];
        self.lblCommonMinglers.textColor = [UIColor blackColor];
    }

}

-(void)layoutSubviews
{
    
    self.imageView_MinglerProfilePic.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.imageView_MinglerProfilePic.layer.borderWidth = 1.0f;
    self.imageView_MinglerProfilePic.layer.cornerRadius = 5.0f;
    self.imageView_MinglerProfilePic.layer.masksToBounds = YES;
    
    
}

-(void)showZeppaMinglersInfoOnCell:(ZPADefaultZeppaUserInfo *)zeppaUser{

    
    NSURL *minglerImageUrl = [NSURL URLWithString:zeppaUser.userInfo.imageUrl];
    [_imageView_MinglerProfilePic setImageWithURL:minglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            ///Do anything with image
            
        }];
    _lblMinglerName.text =  [zeppaUser getDisplayName];
//    _lblCommonMinglers.text = @"17 minglers";
//        NSLog(@"%@",zeppaUser.zeppaUserInfo.givenName);
//        NSLog(@"%@",zeppaUser.zeppaUserInfo.imageUrl);
//    
}

//-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
//    
//    self.textLabel.textColor = [UIColor blackColor];
//}

@end
