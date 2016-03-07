//
//  ZPAActivityNotificationCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 08/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAActivityNotificationCell.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"

@implementation ZPAActivityNotificationCell

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
//    self.btnDisclosureIndicator.selected = selected;
//    
//    
//    if (selected) {
//        ///Configure subviews for selected state
//        self.lblNotificatonTitle.textColor = [UIColor whiteColor];
//        self.lblNotificationSubtitle.textColor = [UIColor whiteColor];
//        self.lblNotificationTime.textColor = [UIColor whiteColor];
//
//    }
//    else{
//        self.lblNotificatonTitle.textColor = [UIColor blackColor];
//        self.lblNotificationSubtitle.textColor = [UIColor blackColor];
//        self.lblNotificationTime.textColor = [UIColor colorWithRed:144.0f/255 green:144.0f/255 blue:144.0f/255 alpha:1.0f];
//    }

}

-(void)layoutSubviews
{
    
    self.imageView_ActivityOwner.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.imageView_ActivityOwner.layer.borderWidth = 1.0f;
    self.imageView_ActivityOwner.layer.cornerRadius = 5.0f;
    self.imageView_ActivityOwner.layer.masksToBounds = YES;
    
    
}


-(void)showDetailOncell:(GTLZeppaclientapiZeppaNotification *)notification{
    
    
   // id zeppaUser = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[notification.senderId longLongValue]];
    
    //if ([zeppaUser isKindOfClass:[ZPADefaulZeppatUserInfo class]]) {
//         * user = [ZPADefaulZeppatUserInfo sharedObject];
    
        ZPADefaultZeppaUserInfo* user = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[notification.senderId longLongValue]];;
        
        NSURL *profileImageURL = [NSURL URLWithString:user.userInfo.imageUrl];
        [_imageView_ActivityOwner setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
       // _lblNotificatonTitle.text = [NSString stringWithFormat:@"%@ %@",user.zeppaUserInfo.givenName,user.zeppaUserInfo.familyName];
        
//    }else{
//        
//        ZPAMyZeppaUser * user = zeppaUser;
//        
//        NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
//        [_imageView_ActivityOwner setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            
//        }];
//      //  _lblEventHostName.text = [NSString stringWithFormat:@"%@ %@",user.endPointUser.userInfo.givenName,user.endPointUser.userInfo.familyName];
//    }
    
    _lblNotificatonTitle.text = notification.title;
    
    _lblNotificationSubtitle.text = notification.message;
    
    NSString *activtyTimeStr = [[ZPADateHelper sharedHelper]getEventTimeDuration:notification.created withEndTime:nil];
    
   _lblNotificationTime.text= [[activtyTimeStr componentsSeparatedByString:@"-"] firstObject];

    
    
}

@end
