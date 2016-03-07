//
//  ZPAMyEventFeedCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 07/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAMyEventFeedCell.h"
#import "ZPAZeppaEventSingleton.h"

@implementation ZPAMyEventFeedCell

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
-(void)showDetailOnCell:(ZPAEventInfoBase *)zeppaEvent{
    
    ZPAUserInfoBase *userInfo = [zeppaEvent getHostInfo];
    
    NSURL *profileImageURL = [NSURL URLWithString:userInfo.userInfo.imageUrl];
    [_imageView_EventHostProfilePic setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    _lblEventHostName.text = [userInfo getDisplayName];
    _lblEventTitle.text = zeppaEvent.zeppaEvent.title;
    
    
//    _imageView_ConflictIndicator.image = [UIImage imageNamed:@"small_circle_blue.png"];
    
  //  [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_ConflictIndicator];
    
    
    [_btnEventDuration.titleLabel setNumberOfLines:0];
    NSString * durationString = [[ZPADateHelper sharedHelper]getEventTimeDuration:zeppaEvent.zeppaEvent.start withEndTime:zeppaEvent.zeppaEvent.end];
    
    [_btnEventDuration setTitle:durationString forState:UIControlStateNormal];
    
    [_btnEventLocation setTitle:zeppaEvent.zeppaEvent.displayLocation forState:UIControlStateNormal];

}

@end
