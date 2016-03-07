//
//  ZPAOtherEventFeedCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 07/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAOtherEventFeedCell.h"

#import "ZPADefaultZeppaUserInfo.h"
#import "ZPADefaultZeppaEventInfo.h"
#import "ZPAZeppaEventSingleton.h"

@implementation ZPAOtherEventFeedCell

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
    self.view_BaseEvent.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.view_BaseEvent.layer.borderWidth = 1.0f;
    self.view_BaseEvent.layer.cornerRadius = 3.0f;
    self.view_BaseEvent.layer.masksToBounds = YES;
    
    self.imageView_EventHostProfilePic.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imageView_EventHostProfilePic.layer.borderWidth = 1.0f;
    self.imageView_EventHostProfilePic.layer.cornerRadius = 5.0;
    self.imageView_EventHostProfilePic.layer.masksToBounds = YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    self.view_BaseEvent.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.view_BaseEvent.layer.borderWidth = 1.0f;
    
    self.imageView_EventHostProfilePic.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.imageView_EventHostProfilePic.layer.borderWidth = 1.0f;
    self.imageView_EventHostProfilePic.layer.cornerRadius = 5.0f;
    self.imageView_EventHostProfilePic.layer.masksToBounds = YES;
    
}
-(void)showDetailOnCell:(ZPADefaultZeppaEventInfo *)zeppaEvent{
    
    ZPADefaultZeppaUserInfo* zeppaUser = zeppaEvent.getHostInfo;
    
    
        
    NSURL *profileImageURL = [NSURL URLWithString:zeppaUser.userInfo.imageUrl];
    [_imageView_EventHostProfilePic setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    
    _lblEventHostName.text = zeppaUser.getDisplayName;
    _lblEventTitle.text = zeppaEvent.zeppaEvent.title;
    _imageView_ConflictIndicator.image = [UIImage imageNamed:@"small_circle_blue.png"];
        
//    [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_ConflictIndicator withZeppaEvent:zeppaEvent];
    
    NSString * durationString = [[ZPADateHelper sharedHelper]getEventTimeDuration:zeppaEvent.zeppaEvent.start withEndTime:zeppaEvent.zeppaEvent.end];
    

    [_btnEventDuration.titleLabel setNumberOfLines:0];
    [_btnEventDuration setTitle:durationString forState:UIControlStateNormal];
    
    [_btnEventLocation setTitle:zeppaEvent.zeppaEvent.displayLocation forState:UIControlStateNormal];
        
   
   // Set quick action bar based on relationship info
    if ([zeppaEvent.relationship.isWatching boolValue] == true) {
        [_watchBtn setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [_watchBtn setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
    }
    if ([zeppaEvent.relationship.isAttending boolValue] == true) {
        [_joinBtn setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [_joinBtn setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
    }

   
}


@end
