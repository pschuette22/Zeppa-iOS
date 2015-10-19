//
//  ZPADiscussionCell.m
//  Zeppa
//
//  Created by Faran on 09/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADiscussionCell.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaulZeppatUserInfo.h"
#import "ZPAMyZeppaUser.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"

@implementation ZPADiscussionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self.viewUserDisscussion.layer setCornerRadius:2.0];
    [self.viewUserDisscussion.layer setBorderColor:[[ZPAStaticHelper greyBorderColor] CGColor]];
    [self.viewUserDisscussion.layer setBorderWidth:1.0];
    [self.viewUserDisscussion.layer setMasksToBounds:YES];
}

-(void)showEventCommentDetail:(GTLZeppaclientapiEventComment *)eventComment{
    
    id zeppaUser = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[eventComment.commenterId longLongValue]];
    
    if ([zeppaUser isKindOfClass:[ZPADefaulZeppatUserInfo class]]) {
        ZPADefaulZeppatUserInfo * user = zeppaUser;
        NSURL *profileImageURL = [NSURL URLWithString:user.zeppaUserInfo.imageUrl];
        [_imageView_discussionUser setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        NSString * userName = [NSString stringWithFormat:@"%@ %@",user.zeppaUserInfo.givenName,user.zeppaUserInfo.familyName];
        
        _lbl_discussionUserName.text = userName;
        
    }else{
        
        ZPAMyZeppaUser * user = zeppaUser;
        
        NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
        
        [_imageView_discussionUser setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        
        NSString *userName = [NSString stringWithFormat:@"%@ %@",user.endPointUser.userInfo.givenName,user.endPointUser.userInfo.familyName];
        
        _lbl_discussionUserName.text = userName;
        
    }
    
    _lbl_discussionDetail.text = eventComment.text;
    
    
//    NSString * discussionTime =  [[ZPADateHelper sharedHelper]getEventTimeDuration:[NSNumber numberWithLongLong:[ZPADateHelper currentTimeMillis]]  withEndTime:nil];
//    
//    NSArray * arr = [discussionTime componentsSeparatedByString:@"-"];
    
    
     NSArray * arr = [[[ZPADateHelper sharedHelper]getEventTimeDuration:eventComment.created withEndTime:nil] componentsSeparatedByString:@"-"];
    _lbl_discussionTime.text = [arr firstObject];
    
}


@end
