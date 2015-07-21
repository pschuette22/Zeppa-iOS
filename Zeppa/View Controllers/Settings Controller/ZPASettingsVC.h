//
//  ZPASettingsVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPARevealSplitMenuBaseVC.h"

@interface ZPASettingsVC : ZPARevealSplitMenuBaseVC<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)pushNotifBtnTapped:(UIButton *)sender;
- (IBAction)pushNotifSwitch:(UISwitch *)sender;
- (IBAction)calendarSyncSwitchTapped:(UISwitch *)sender;

- (IBAction)manageSyncCalendarPressed:(UIButton *)sender;
@end
