//
//  ZPAActivityNotificationCell.h
//  Zeppa
//
//  Created by Milan Agarwal on 08/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPANotificationSingleton.h"
#import "ZPADefaulZeppatUserInfo.h"
#import "ZPADefaulZeppatEventInfo.h"
#import "ZPAZeppaUserSingleton.h"
#import "GTLZeppaclientapiZeppaNotification.h"

@interface ZPAActivityNotificationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView_ActivityOwner;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificatonTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationSubtitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNotificationTime;
@property (weak, nonatomic) IBOutlet UIButton *btnDisclosureIndicator;

-(void)showDetailOncell:(GTLZeppaclientapiZeppaNotification *)notification;

@end
