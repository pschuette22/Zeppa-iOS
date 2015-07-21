//
//  ZPALeftMenuVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 26/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABLE_ROW_INDEX_PROFILE         0
#define TABLE_ROW_INDEX_HOME            1
#define TABLE_ROW_INDEX_MINGLERS        2
//#define TABLE_ROW_INDEX_EXTEND_BID      3
#define TABLE_ROW_INDEX_FEEDBACK        3
#define TABLE_ROW_INDEX_SETTINGS        4

#define TOTAL_ROWS                      5

@protocol ZPALeftMenuSelctionDelegate <NSObject>
@required
-(void)didSelectMenuItemAtIndex:(NSInteger)menuIndex;

@end

@interface ZPALeftMenuVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id<ZPALeftMenuSelctionDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSInteger currentSelectedIndex;

@end
