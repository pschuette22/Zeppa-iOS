//
//  ZPAOtherEventFeedCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 07/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAOtherEventFeedCell.h"

#import "ZPADefaulZeppatUserInfo.h"
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
-(void)showDetailOnCell:(ZPAMyZeppaEvent *)zeppaEvent{
    
    id zeppaUser = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[zeppaEvent.event.hostId longLongValue]];
    
    if ([zeppaUser isKindOfClass:[ZPADefaulZeppatUserInfo class]]) {
        
        ZPADefaulZeppatUserInfo * user = zeppaUser;
        
        NSURL *profileImageURL = [NSURL URLWithString:user.zeppaUserInfo.imageUrl];
        [_imageView_EventHostProfilePic setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        _lblEventHostName.text = [NSString stringWithFormat:@"%@ %@",user.zeppaUserInfo.givenName,user.zeppaUserInfo.familyName];
        
    }else{
        
        ZPAMyZeppaUser * user = zeppaUser;
        
        NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
        [_imageView_EventHostProfilePic setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        _lblEventHostName.text = [NSString stringWithFormat:@"%@ %@",user.endPointUser.userInfo.givenName,user.endPointUser.userInfo.familyName];
    }
    
    
    
    
    
        _lblEventTitle.text = zeppaEvent.event.title;
        
        
        _imageView_ConflictIndicator.image = [UIImage imageNamed:@"small_circle_blue.png"];
        
    [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_ConflictIndicator withZeppaEvent:zeppaEvent];
    
        
        
        NSString * durationString = [[ZPADateHelper sharedHelper]getEventTimeDuration:zeppaEvent.event.start withEndTime:zeppaEvent.event.end];
        
        _lblEventDescription.text = zeppaEvent.event.descriptionProperty;
    
        [_btnEventDuration.titleLabel setNumberOfLines:0];
        [_btnEventDuration setTitle:durationString forState:UIControlStateNormal];
        
        [_btnEventLocation setTitle:zeppaEvent.event.displayLocation forState:UIControlStateNormal];
        
   
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