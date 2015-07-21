//
//  ZPAEventDetailVC.h
//  Zeppa
//
//  Created by Dheeraj on 12/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPARevealSplitMenuBaseVC.h"
#import "ZPAMyZeppaEvent.h"
#import "ZPADefaulZeppatUserInfo.h"
#import "ZPAFetchDefaultTagsForUser.h"

@interface ZPAEventDetailVC : ZPARevealSplitMenuBaseVC<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scollView_base;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *userProfile_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_NoOfInvitedUser;
@property (weak, nonatomic) IBOutlet UIButton *eventTime_ImageView;
@property (weak, nonatomic) IBOutlet UIButton *location_ImageView;
@property (weak, nonatomic) IBOutlet UITextView *discussTextView;
@property (weak, nonatomic) IBOutlet UIView *discussionPostBaseView;
@property (weak, nonatomic) IBOutlet UIView *discussionBoardView;
@property (weak, nonatomic) IBOutlet UIView *tagContainerView;
@property (weak, nonatomic) IBOutlet UIView *eventDetailView;
@property (weak, nonatomic) IBOutlet UILabel *whiteLabelInTextView;
@property (weak, nonatomic) ZPAMyZeppaEvent *eventDetail;
@property (weak, nonatomic) ZPADefaulZeppatUserInfo *userInfo;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventDuration;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventDisplayLocation;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventHostName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_CommonMinglers;
@property (weak, nonatomic) IBOutlet UITextView *txtView_EventDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_ConflictIndicator;
@property (nonatomic, strong)NSMutableArray *tagsArray;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UIView *qucikActionView;
@property (weak, nonatomic) IBOutlet UIView *viewUserDisscussion;
@property (weak, nonatomic) IBOutlet UIView *view_BaseUserDetail;
@property (weak, nonatomic) IBOutlet UIView *view_DiscussionLabel;
@property (nonatomic, strong) ZPAFetchDefaultTagsForUser *defaultTagsForUser;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_discussionUser;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionUserName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbl_discussionTime;
@property (weak, nonatomic) IBOutlet UIButton *watchButton;
@property (weak, nonatomic) IBOutlet UIButton *textButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView_discussion;
@property (weak, nonatomic) IBOutlet UIButton *invitedUserBtn;
@property (weak, nonatomic) IBOutlet UILabel *lbl_invitedUserNo;
@property (weak, nonatomic) IBOutlet UIView *addInvitesView;
@property (weak, nonatomic) IBOutlet UIView *addInvitesSeperatorView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;

@property BOOL isMinglerTag;

- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)joinBtnTapped:(UIButton *)sender;
- (IBAction)textBtnTapped:(UIButton *)sender;
- (IBAction)watchBtnTapped:(UIButton *)sender;
- (IBAction)cancelBtnTappped:(UIBarButtonItem *)sender;
- (IBAction)invitedUserBtnTapped:(UIButton *)sender;

- (IBAction)postButtonTapped:(UIButton *)sender;
@end
