//
//  ZPAUserProfileVC.h
//  Zeppa
//
//  Created by Dheeraj on 10/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GTLServiceZeppausertouserrelationshipendpoint.h"

#import "ZPAUserProfileCell.h"
#import "ZPAMinglersEventCell.h"
#import "ZPADefaulZeppatUserInfo.h"

@interface ZPAUserProfileVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)ZPAUserProfileCell *userProfileCell;
@property(nonatomic,strong)ZPAMinglersEventCell *minglerEventCell;

@property (nonatomic, strong)GTLServiceZeppausertouserrelationshipendpoint *zeppaUserToUserRelationship;



@property (nonatomic,strong)ZPADefaulZeppatUserInfo *userProfileInfo;

@property (nonatomic,strong)NSMutableArray *userTagArray;
@property (nonatomic,strong)NSMutableArray *minglersArray;

- (IBAction)commonMinglersBtnTapped:(UIButton *)sender;

- (IBAction)watchBtnTapped:(UIButton *)sender;

- (IBAction)textBtnTapped:(UIButton *)sender;

- (IBAction)joinBtnTapped:(UIButton *)sender;

@end
