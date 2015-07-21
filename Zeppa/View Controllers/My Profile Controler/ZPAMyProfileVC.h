//
//  ZPAMyProfileVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPARevealSplitMenuBaseVC.h"

@interface ZPAMyProfileVC : ZPARevealSplitMenuBaseVC<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)editBtnTapped:(UIBarButtonItem *)sender;

@end
