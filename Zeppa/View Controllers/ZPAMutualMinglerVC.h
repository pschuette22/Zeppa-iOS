//
//  ZPAMutualMinglerVC.h
//  Zeppa
//
//  Created by Faran on 02/05/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPADefaulZeppatUserInfo.h"
#import "ZPACommonMinglersCell.h"

@interface ZPAMutualMinglerVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)ZPADefaulZeppatUserInfo *minglerUserInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property BOOL isAttendingUser;
@property (nonatomic,strong) NSArray * attendingUserIdArr;
@end
