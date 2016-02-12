//
//  ZPAViewController.h
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPARevealSplitMenuBaseVC.h"
#import "ZPAOtherEventFeedCell.h"

@interface ZPAFeedVC : ZPARevealSplitMenuBaseVC<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak,nonatomic) ZPAOtherEventFeedCell *otherEventFeedCell;
@property BOOL toCalendar;
//@property (nonatomic, strong)NSMutableArray *arrFeeds;
- (IBAction)joinBtnTapped:(UIButton *)sender;
- (IBAction)watchBtnTapped:(UIButton *)sender;

@end
