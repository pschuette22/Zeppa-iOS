//
//  ZPAAddInviteCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 10/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAAddInviteCell.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "UIImageView+WebCache.h"


@implementation ZPAAddInviteCell

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

- (IBAction)btnSelectUserTapped:(id)sender {
}

-(void)showDetailOnCell:(ZPADefaulZeppatUserInfo *)user{
    
    _lblInviteeName.text =[NSString stringWithFormat:@"%@ %@",user.zeppaUserInfo.givenName,user.zeppaUserInfo.familyName];
    
    NSURL *minglerImageUrl = [NSURL URLWithString:user.zeppaUserInfo.imageUrl];
    [_imageView_Invitee setImageWithURL:minglerImageUrl placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
        ///Do anything with image
        
    }];

}
@end
