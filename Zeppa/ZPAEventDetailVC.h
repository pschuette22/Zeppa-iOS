//
//  ZPAEventDetailVC.h
//  Zeppa
//
//  Created by Dheeraj on 12/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPARevealSplitMenuBaseVC.h"
#import "ZPAEventInfoBase.h"
#import "ZPAUserInfoBase.h"
#import "ZPAFetchDefaultTagsForUser.h"
#import "ZPADiscussionCell.h"

@interface ZPAEventDetailVC : UIViewController<UITableViewDelegate,UITextViewDelegate>


// Hold the objects for this event and host
// event info of the event to be displayed
@property (weak, nonatomic) ZPAEventInfoBase *eventInfo;
// user info of the event host
@property (weak, nonatomic) ZPAUserInfoBase *hostInfo;
// user info of the person who invited you, or nil
@property (weak, nonatomic) ZPAUserInfoBase *inviteUserInfo;
/*
 * Views
 */
 
// Base views
@property (weak, nonatomic) IBOutlet UIScrollView *scollView_base;
@property (weak, nonatomic) IBOutlet UIView *view_contentView;

// User Details
@property (weak, nonatomic) IBOutlet UIView *view_BaseUserDetail; // should refactor to eventOverviewBase
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventOverviewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userDetailHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *userProfile_ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_ConflictIndicator;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeight;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventHostName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventDescription;
// Button over event description to intersept taps
@property (weak, nonatomic) IBOutlet UIButton *btn_eventDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeight;
@property (weak, nonatomic) IBOutlet UIView *qucikActionView;
@property (weak, nonatomic) IBOutlet UIButton *watchButton;
@property (weak, nonatomic) IBOutlet UIButton *joinButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *quickActionHeight;

// Tag Container
@property (weak, nonatomic) IBOutlet UIView *tagContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagContainerHeight;


// Event Details
@property (weak, nonatomic) IBOutlet UIView *eventDetailView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *eventDetailHeight;
@property (weak, nonatomic) IBOutlet UIButton *eventTime_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventDuration;
@property (weak, nonatomic) IBOutlet UIButton *location_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_EventDisplayLocation;
@property (weak, nonatomic) IBOutlet UIButton *btn_attendingUsers;
@property (weak, nonatomic) IBOutlet UIButton *invitedUserBtn;
@property (weak, nonatomic) IBOutlet UILabel *lbl_invitedUserNo;
@property (weak, nonatomic) IBOutlet UIView *addInvitesView;
@property (weak, nonatomic) IBOutlet UIView *addInvitesSeperatorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addInvitesBaseHeight;

// Discussion Board
@property (weak, nonatomic) IBOutlet UITextView *discussTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussionTextHeight;
@property (weak, nonatomic) IBOutlet UIView *discussionBoardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussionBoardHeight;
@property (weak, nonatomic) IBOutlet UIView *discussionContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussionContainerHeight;
@property (weak, nonatomic) IBOutlet UIView *view_discussBaseView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *discussBaseHeight;
@property (weak, nonatomic) IBOutlet UIButton *postButton;


@property (weak, nonatomic) IBOutlet UITableView *tableView_discussion;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBarButton;

@property BOOL isMinglerTag;

- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender;

- (IBAction)joinBtnTapped:(UIButton *)sender;
- (IBAction)watchBtnTapped:(UIButton *)sender;
- (IBAction)cancelBtnTappped:(UIBarButtonItem *)sender;
- (IBAction)invitedUserBtnTapped:(UIButton *)sender;
- (IBAction)eventTimeBtnTapped:(UIButton*)sender;
- (IBAction)eventLocationBtnTapped:(UIButton*)sender;
- (IBAction)attendingUsersBtnTapped:(UIButton*)sender;
- (IBAction)descriptionTapped:(UIButton*)sender;

- (IBAction)postButtonTapped:(UIButton *)sender;
- (IBAction)mapBtnTapped:(UIButton*)sender;

- (void) notificationReceived: (NSNotification*) notification;
- (void) setEventDetail:(ZPAMyZeppaEvent * _Nullable)eventDetail;
@end
