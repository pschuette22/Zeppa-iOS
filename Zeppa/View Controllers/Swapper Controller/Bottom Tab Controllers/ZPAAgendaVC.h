//
//  ZPAAgendaVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 27/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPARevealSplitMenuBaseVC.h"
#import "ZPAOtherEventAgendaCell.h"

@interface ZPAAgendaVC : ZPARevealSplitMenuBaseVC<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) ZPAMyZeppaUser *currentUser;
@property(nonatomic,strong)  ZPAOtherEventAgendaCell *otherEventAgendaCell;
- (IBAction)joinBtnTapped:(UIButton *)sender;
- (IBAction)watchBtnTapped:(UIButton *)sender;
@end
