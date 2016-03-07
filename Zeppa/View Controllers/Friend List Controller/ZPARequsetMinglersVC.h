//
//  ZPARequsetMinglersVC.h
//  Zeppa
//
//  Created by Dheeraj on 11/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "ZPAConfirmedMinglerCell.h"
#import "ZPARequestMinglersCell.h"

#import "ZPADefaultZeppaUserInfo.h"
#import "ZPAZeppaUserSingleton.h"

#import "ZPAFindMinglers.h"


#import "ZPAPhoneContact.h"

#import "GTLZeppaclientapiCollectionResponseZeppaUserToUserRelationship.h"
#import "GTLZeppaclientapiZeppaEventToUserRelationship.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"


#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface ZPARequsetMinglersVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)GTLServiceZeppaclientapi *zeppaUserToUserRelationship;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic, strong)NSMutableArray *zeppaMinglerUser;
@property (nonatomic, strong)NSArray *possibleConnectionZeppaUser;
@property (nonatomic, strong)NSArray *pendingRequestZeppaUser;

@property (nonatomic, strong)ZPAFindMinglers *findMingler;
- (IBAction)deniedBtnTapped:(UIButton *)sender;
- (IBAction)acceptBtnTapped:(UIButton *)sender;
- (IBAction)requestBtnTapped:(UIButton *)sender;
@end
