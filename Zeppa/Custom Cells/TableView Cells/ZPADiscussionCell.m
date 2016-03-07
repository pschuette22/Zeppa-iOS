//
//  ZPADiscussionCell.m
//  Zeppa
//
//  Created by Faran on 09/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPADiscussionCell.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaultZeppaUserInfo.h"
#import "ZPAMyZeppaUser.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"

#define PADDING 8

@implementation ZPADiscussionCell

/**
 * Define the width of this cell and resize frames accordingly
 */
-(void) defineCellWidth: (CGFloat) width {
    CGFloat lblWidth = width - (PADDING + _imageView_discussionUser.frame.size.width + PADDING + PADDING);
    
    // Reframe username
    CGRect nameFrame = _lbl_discussionUserName.frame;
    nameFrame.size.width = lblWidth;
    _lbl_discussionUserName.frame = nameFrame;
    
    // Reframe discussion
    CGRect discFrame = _lbl_discussionDetail.frame;
    discFrame.size.width = lblWidth;
    _lbl_discussionDetail.frame = discFrame;
    
    // Reframe the date
    CGRect dateFrame = _lbl_discussionTime.frame;
    dateFrame.size.width = lblWidth;
    _lbl_discussionTime.frame = dateFrame;
    
}

/**
 * Show the details of this comment along with accompanying objects
 */
-(void)showEventCommentDetail:(GTLZeppaclientapiEventComment *)eventComment{
    
    id zeppaUser = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[eventComment.commenterId longLongValue]];
    
    if (!zeppaUser) {
        // TODO: load user and set info when ready
        _lbl_discussionUserName.text = @"Loading...";
    } else if ([zeppaUser isKindOfClass:[ZPADefaultZeppaUserInfo class]]) {
        ZPADefaultZeppaUserInfo * user = zeppaUser;
        NSURL *profileImageURL = [NSURL URLWithString:user.userInfo.imageUrl];
        [_imageView_discussionUser setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        NSString * userName = user.getDisplayName;
        
        _lbl_discussionUserName.text = userName;
        
    } else {
        
        ZPAMyZeppaUser * user = zeppaUser;
        
        NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
        
        [_imageView_discussionUser setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        
        NSString *userName = user.getDisplayName;
        _lbl_discussionUserName.text = userName;
        
    }
    
    // Determine the line count for the label
    
    CGFloat presetSize =_detailHeightConstraint.constant;
    _lbl_discussionDetail.text = eventComment.text;
    
    CGSize textSize = [_lbl_discussionDetail sizeThatFits:CGSizeMake(_lbl_discussionDetail.frame.size.width, CGFLOAT_MAX)];
    CGFloat sizeDiff = textSize.height - presetSize;
    NSInteger lineCount = @(textSize.height/_lbl_discussionDetail.font.lineHeight).integerValue;
    // Set the line count
    _lbl_discussionDetail.numberOfLines = lineCount;
    // Update the height constraints to match this
    _detailHeightConstraint.constant = textSize.height;
    _cellHeightConstraint.constant += sizeDiff;
    
    
     NSArray * arr = [[[ZPADateHelper sharedHelper]getEventTimeDuration:eventComment.created withEndTime:nil] componentsSeparatedByString:@"-"];
    _lbl_discussionTime.text = [arr firstObject];
    
    // Reframe this view
    CGRect viewFrame = self.frame;
    viewFrame.size.height = _cellHeightConstraint.constant;
    self.frame = viewFrame;
    
    
}


@end
