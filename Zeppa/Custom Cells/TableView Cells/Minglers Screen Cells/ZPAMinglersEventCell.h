//
//  ZPAMinglersEventCell.h
//  Zeppa
//
//  Created by Faran on 05/05/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPADefaulZeppatUserInfo.h"
#import "ZPAMyZeppaEvent.h"

@interface ZPAMinglersEventCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view_BaseView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_eventTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_minglerImage;
@property (weak, nonatomic) IBOutlet UIButton *btn_EventDuration;
@property (weak, nonatomic) IBOutlet UIButton *btn_EventLocation;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_conflictIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lbl_minglerUserName;
@property (weak, nonatomic) IBOutlet UIButton *btn_join;
@property (weak, nonatomic) IBOutlet UIButton *btn_watch;

- (IBAction)watchButtonTapped:(UIButton *)sender;
- (IBAction)joinButtonTapped:(UIButton *)sender;

-(void)showEventDetailOnCell:(ZPADefaulZeppatUserInfo *)userInfo withZeppaEvents:(ZPAMyZeppaEvent *)zeppaEvent;

@end
