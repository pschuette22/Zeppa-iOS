//
//  ZPAMyEventAgendaCell.m
//  Zeppa
//
//  Created by Milan Agarwal on 07/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAMyEventAgendaCell.h"
#import "ZPAZeppaEventSingleton.h"
@implementation ZPAMyEventAgendaCell

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

-(void)showEventDetailsOnAgendaCell:(ZPAMyZeppaEvent * )zeppaEvents{
    
    ZPAMyZeppaUser *user = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[zeppaEvents.event.hostId longLongValue]];
    
    NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
    [_imageView_EventHostProfilePic setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    _lblEventHostName.text = [NSString stringWithFormat:@"%@ %@",user.endPointUser.userInfo.givenName,user.endPointUser.userInfo.familyName];
    _lblEventTitle.text = zeppaEvents.event.title;
    // _imageView_ConflictIndicator = zeppaEvent.;
    NSString * durationString = [[ZPADateHelper sharedHelper]getEventTimeDuration:zeppaEvents.event.start withEndTime:zeppaEvents.event.end];
    
    [_btnEventDuration.titleLabel setNumberOfLines:0];
    [_btnEventDuration setTitle:durationString forState:UIControlStateNormal];
    
    [_btnEventLocation setTitle:zeppaEvents.event.displayLocation forState:UIControlStateNormal];
    
   // [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_ConflictIndicator];
    
    _imageView_ConflictIndicator.image  = [UIImage imageNamed:@"small_circle_blue.png"];
    
}

@end
