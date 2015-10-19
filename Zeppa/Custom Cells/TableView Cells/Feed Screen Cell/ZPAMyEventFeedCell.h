//
//  ZPAMyEventFeedCell.h
//  Zeppa
//
//  Created by Milan Agarwal on 07/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZPAMyZeppaEvent.h"
#import "ZPAZeppaUserSingleton.h"

#import "GTLZeppaclientapiZeppaUserInfo.h"


@interface ZPAMyEventFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView_EventHostProfilePic;
@property (weak, nonatomic) IBOutlet UILabel *lblEventHostName;
@property (weak, nonatomic) IBOutlet UILabel *lblEventTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_ConflictIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lblEventDescription;
@property (weak, nonatomic) IBOutlet UIButton *btnEventDuration;
@property (weak, nonatomic) IBOutlet UIButton *btnEventLocation;
@property (weak, nonatomic) IBOutlet UIView *view_BaseEvent;


-(void)showDetailOnCell:(ZPAMyZeppaEvent *)zeppaEvent;
@end
