//
//  ZPAManagePushNotifCell.h
//  Zeppa
//
//  Created by Dheeraj on 07/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPACalendarCell.h"

@interface ZPAManageCalendarSyncCell : UITableViewCell <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *calendarArray;
@end
