//
//  ZPAAddInvitesVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 10/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPAAddInviteCell.h"
#import "ZPAMyZeppaEvent.h"

@protocol addInvitesDelegate <NSObject>

@required
-(void)noOfInvitees;

@end


@interface ZPAAddInvitesVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign)id<addInvitesDelegate>delegate;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigataionBar;
@property (nonatomic, weak)NSMutableArray *arrInvitedUsers;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic ,strong)ZPAAddInviteCell *addInviteCell;
@property (nonatomic ,strong)ZPAMyZeppaEvent *zeppaEvent;
@property  NSMutableArray *invitesUserIdArray;
@property  NSMutableArray *selectedInvitesUserIdArray;
@property (nonatomic, strong)NSMutableArray *arrInviteesCandidate;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBtnTapped;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtnTapped;
- (IBAction)toggleCheckMarkBtnTapped:(UIButton *)sender;
- (IBAction)doneBtnTapped:(UIBarButtonItem *)sender;
- (IBAction)cancelBtnTapped:(UIBarButtonItem *)sender;



@end
