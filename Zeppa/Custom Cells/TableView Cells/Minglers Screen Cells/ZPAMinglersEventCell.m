//
//  ZPAMinglersEventCell.m
//  Zeppa
//
//  Created by Faran on 05/05/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAMinglersEventCell.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPADefaulZeppatEventInfo.h"

@implementation ZPAMinglersEventCell

- (void)awakeFromNib {
    self.view_BaseView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.view_BaseView.layer.borderWidth = 1.0f;
    self.view_BaseView.layer.cornerRadius = 3.0f;
    self.view_BaseView.layer.masksToBounds = YES;
    
    self.imageView_minglerImage.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.imageView_minglerImage.layer.borderWidth = 1.0f;
    self.imageView_minglerImage.layer.cornerRadius = 5.0;
    self.imageView_minglerImage.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)watchButtonTapped:(UIButton *)sender {
}

- (IBAction)textButtonTapped:(UIButton *)sender {
}

- (IBAction)joinButtonTapped:(UIButton *)sender {
}

-(void)showEventDetailOnCell:(ZPADefaulZeppatUserInfo *)userInfo withZeppaEvents:(ZPAMyZeppaEvent *)zeppaEvent{
    
    
    NSURL *profileImageURL = [NSURL URLWithString:userInfo.zeppaUserInfo.imageUrl];
    [_imageView_minglerImage setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    _lbl_minglerUserName.text = [NSString stringWithFormat:@"%@ %@",userInfo.zeppaUserInfo.givenName,userInfo.zeppaUserInfo.familyName];
    _lbl_eventTitle.text = zeppaEvent.event.title;
    
    
    _imageView_conflictIndicator.image = [UIImage imageNamed:@"small_circle_blue.png"];
    
    [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_conflictIndicator withZeppaEvent:zeppaEvent];
    
    
    
    NSString * durationString = [[ZPADateHelper sharedHelper]getEventTimeDuration:zeppaEvent.event.start withEndTime:zeppaEvent.event.end];
    
    _lbl_EventDescription.text = zeppaEvent.event.descriptionProperty;
    [_btn_EventDuration setTitle:durationString forState:UIControlStateNormal];
    
    [_btn_EventLocation setTitle:zeppaEvent.event.displayLocation forState:UIControlStateNormal];
    
    
    if ([zeppaEvent.relationship.isWatching boolValue] == true) {
        [_btn_watch setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [_btn_watch setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
    }
    if ([zeppaEvent.relationship.isAttending boolValue] == true) {
        [_btn_join setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [_btn_join setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
    }


}

@end
