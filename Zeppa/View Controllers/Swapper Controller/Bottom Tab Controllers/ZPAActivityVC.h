//
//  ZPAActivityVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 27/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPARevealSplitMenuBaseVC.h"

@interface ZPAActivityVC : ZPARevealSplitMenuBaseVC<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *arrNotifications;
@end
