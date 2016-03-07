//
//  ZPAInvitedUserVC.h
//  Zeppa
//
//  Created by Faran on 10/06/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPADefaultZeppaUserInfo.h"
#import "ZPACommonMinglersCell.h"

@interface ZPAInvitedUserVC : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,strong)ZPADefaultZeppaUserInfo *invitedUserInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isAttendingUser;
@property (nonatomic,strong) NSArray * attendingUserIdArr;

@end
