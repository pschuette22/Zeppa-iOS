//
//  ZPAEventDetailVC.m
//  Zeppa
//
//  Created by Dheeraj on 12/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAEventDetailVC.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPAZeppaEventTagSingleton.h"
#import "ZPAZeppaEventSingleton.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPADefaulZeppatEventInfo.h"
#import "ZPAAddInvitesVC.h"
#import "ZPADiscussionCell.h"
#import "ZPAUserInfoBaseClass.h"
#import "ZPAMutualMinglerVC.h"
#import "ZPAEventInfoBaseClass.h"
#import "ZPAMapViewController.h"

#import "MBProgressHUD.h"

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"

#import "GTLZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"

#import "ZPAAuthenticatonHandler.h"

#import "GTLZeppaclientapiZeppaUserInfo.h"

#import "GTLZeppaclientapiCollectionResponseEventComment.h"
#import "GTLZeppaclientapiEventComment.h"
#import "GrowingTextViewHandler.h"


#define SEGUE_ID_ADD_INVITES @"addInvites"
#define SEGUE_ID_JOINED_USER @"joinedUser"
#define SEGUE_ID_MAPLOCATION @"mapLocation"


#define SCROLLVIEW_HEIGHT 505

#define TABLEVIEW_ROW_HEIGHT 55

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define PADDING 8
#define TAGS_BUTTON_TAG 100
#define HEIGHTEXTEND 33
#define WIDTHPADDING 5
#define TAGS_BASEVIEW_TAG_VALUE 100
#define TITLE_STORYBOARD_HEIGHT 25
#define DESC_STORYBOARD_HEIGHT 32
#define QUICKACTION_STORYBOARD_HEIGHT 32
#define LEFT_TITLE_STORYBOARD_OFFSET 86
#define RIGHT_TITLE_STORYBOARD_OFFSET 28


@interface ZPAEventDetailVC ()<MutualMinglerTagDelegate,addInvitesDelegate, UITextViewDelegate>
{
    NSMutableArray *temp;
    NSMutableArray *testArray;
    ZPAMyZeppaUser *currentUser;
    int counter;
    ZPAAddInvitesVC * addInvites;
    NSMutableArray * eventCommentArray;
    NSMutableArray * invitedUserIdArray;
    MBProgressHUD * progress;
    
    
}
@property (nonatomic, strong)UITextView *currentTextView;
@property (nonatomic, assign)NSInteger scrollViewHeight;
@property (nonatomic, strong)ZPADiscussionCell *discussionCell;
@property (strong, nonatomic) GrowingTextViewHandler *handler;

@end

@implementation ZPAEventDetailVC{
    NSMutableArray *_tagsTempArray;
    NSInteger discussionCellCount;
    NSMutableArray * attendingUser;
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialization];
    temp = [NSMutableArray array];
    
    eventCommentArray = [NSMutableArray array];
//    if (_tableView_discussion.hidden == YES) {
//        discussionCellCount = 0;
//    }
//    if (discussionCellCount >0) {
//        _tableView_discussion.hidden = NO;
//    }
   // [temp addObject:@"1"];
    
    [self makeDesignForAllControl];
    [self registerForNotifications];
    
    ///temp array is collection of no of discussion
    
    currentUser = [ZPAAppData sharedAppData].loggedInUser;
    
    //testArray replace with currentUser.tagArray
    //testArray for testing purpose
    
    testArray = [NSMutableArray array];
    counter = 1;
    
     attendingUser = [[[ZPAZeppaEventSingleton sharedObject] getAttendingUserIds:_eventDetail] mutableCopy];
    
    if ([attendingUser containsObject:currentUser.endPointUser.identifier]) {
        [attendingUser removeObject:currentUser.endPointUser.identifier];
    }
    
    [self executeListEventComment];
    
    [self showEventDetails];
    
    // set the description label handler
    self.handler = [[GrowingTextViewHandler alloc]initWithTextView:self.discussTextView withHeightConstraint:self.discussionTextHeight];
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:6];
}

-(void)viewWillAppear:(BOOL)animated{
    
    addInvites = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAAddInvitesVC"];
   // _lbl_NoOfInvitedUser.text =[NSString stringWithFormat:@"%lu",(unsigned long)addInvites.invitesUserIdArray.count];
    
    
//    _scollView_base.contentSize = CGSizeMake(0, _discussionPostBaseView.frame.origin.y+_discussionPostBaseView.frame.size.height+10);
    
    //[self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ZeppaNotification"
                                               object:nil];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [_tagsArray removeAllObjects];
    [_tagsTempArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [self unregisterFromNotifications];
}



///*******************************************
#pragma mark - InitialSetting Method
///*******************************************

-(void)makeDesignForAllControl
{
    
   
    // Set the appropriate view title
    if([self.eventDetail.event.privacy isEqualToString:@"PRIVATE"]){
        self.title = @"Private Activity";
    } else if ([self.eventDetail.event.privacy isEqualToString:@"CASUAL"]) {
        self.title = @"Casual Activity";
    } else {
        self.title = @"Activity Info";
    }
    
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    
//    for (int i=0; i<temp.count; i++) {
//        [self updateDiscussionTableViewAndDisussionBaseViewFrame];
//    }
    
//    [self.lbl_EventDuration setNumberOfLines:0];
    
    [self.userProfile_ImageView.layer setCornerRadius:5.0];
    [self.userProfile_ImageView.layer setBorderColor:[[ZPAStaticHelper greyBorderColor] CGColor]];
    [self.userProfile_ImageView.layer setBorderWidth:1.0];
    [self.userProfile_ImageView.layer setMasksToBounds:YES];
    
    [self.eventTime_ImageView.layer setCornerRadius:3.0];
    [self.eventTime_ImageView.layer setBorderColor:[[ZPAStaticHelper greyBorderColor] CGColor]];
    [self.eventTime_ImageView.layer setBorderWidth:1.0];
    [self.eventTime_ImageView.layer setMasksToBounds:YES];
    
    [self.location_ImageView.layer setCornerRadius:3.0];
    [self.location_ImageView.layer setBorderColor:[[ZPAStaticHelper greyBorderColor] CGColor]];
    [self.location_ImageView.layer setBorderWidth:1.0];
    [self.location_ImageView.layer setMasksToBounds:YES];
    
    
    [self.discussionBoardView.layer setCornerRadius:3.0];
    [self.discussionBoardView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.discussionBoardView.layer setBorderWidth:1.0];
    [self.discussionBoardView.layer setMasksToBounds:YES];
    
    [self.eventDetailView.layer setBorderWidth:1.0];
    [self.eventDetailView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.eventDetailView.layer setCornerRadius:3.0];
    [self.eventDetailView.layer setMasksToBounds:YES];
    
    [self.postButton.layer setCornerRadius:3.0];
    [self.postButton.layer setMasksToBounds:YES];
    
}

/*
 * Prepare to leave this view
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    if ([segue.identifier isEqualToString:SEGUE_ID_ADD_INVITES]) {
        
        addInvites = segue.destinationViewController;
        ///Initialze any property here
        if (invitedUserIdArray.count>0) {
            
            addInvites.invitesUserIdArray = invitedUserIdArray;
            
        }
        addInvites.zeppaEvent = _eventDetail;
        
        addInvites.delegate = self;
    }
    else if ([segue.identifier isEqualToString:SEGUE_ID_JOINED_USER]) {
        
        ZPAMutualMinglerVC *minglerVC = [segue destinationViewController];
        minglerVC.isAttendingUser = YES;
        
        NSLog(@"%@",attendingUser);
        
        if ([attendingUser containsObject:currentUser.endPointUser.identifier]) {
            [attendingUser removeObject:currentUser.endPointUser.identifier];
        }
        
        minglerVC.attendingUserIdArr = attendingUser;
       // minglerVC.minglerUserInfo = _userProfileInfo;
    }
    else if ([segue.identifier isEqualToString:SEGUE_ID_MAPLOCATION]) {
        ZPAMapViewController * mapViewVC = [segue destinationViewController];
        
        if (_eventDetail.event.mapsLocation) {
            mapViewVC.addressString = _eventDetail.event.mapsLocation;
        }else{
            mapViewVC.addressString = _eventDetail.event.displayLocation;
        }
        
    }
    
    
    
    
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString: @"joinedUser"]) {
        
        if (attendingUser.count == 0) {
            
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}



///**********************************************
#pragma mark - Initialization Method
///**********************************************
-(void)initialization{
    
    _tagsArray = [NSMutableArray array];
    _tagsTempArray = [NSMutableArray array];
    invitedUserIdArray = [NSMutableArray array];
}



//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

///*******************************************
#pragma mark - UITextViewDelegate Methods
///*******************************************

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Let's talk..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Let's talk...";
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}



///*******************************************
#pragma mark - Action Method
///*******************************************
- (IBAction)postButtonTapped:(UIButton *)sender
{
    
    [self executeInsertEventComment];
    
    [self doneButtonClicked];
    
    
   // _scollView_base.contentSize = CGSizeMake(320, _tableView_discussion.frame.origin.y+_tableView_discussion.frame.size.height+5);
    
   
   // _tableView_discussion.hidden = NO;
    
    _tableView_discussion.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
}


- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender {
    
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [progress setLabelText:@"Canceling Event..."];
    [progress show:YES];
    [self removeZeppaEventWithIdentifier:[_eventDetail.event.identifier longLongValue]];
    
}

- (IBAction)joinBtnTapped:(UIButton *)sender {
    
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [progress show:YES];
    
    if (![[ZPADefaulZeppatEventInfo sharedObject]isAttending ] == true) {
        [sender setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
        [_watchButton setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
        
    }
    else{
        [_watchButton setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
    }
    
    [[ZPADefaulZeppatEventInfo sharedObject]onJoinButtonClicked:_eventDetail.relationship];
    
     [self setAttendingUserButtonText:_invitedUserBtn];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_ConflictIndicator withZeppaEvent:_eventDetail];
        [progress hide:YES];
    });

}


- (IBAction)watchBtnTapped:(UIButton *)sender {
    
    if (![[ZPADefaulZeppatEventInfo sharedObject]isWatching] == true) {
        [sender setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
    }
    [[ZPADefaulZeppatEventInfo sharedObject]onWatchButtonClicked:_eventDetail.relationship];

}

-(IBAction)cancelBtnTappped:(UIBarButtonItem *)sender{

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)invitedUserBtnTapped:(UIButton *)sender {
    
    
   // [self setAttendingUserButtonText:sender];
//    [self showAttendingUserMediator:sender];
    // TODO: navigate to invite users page
    
}

-(IBAction)otherEventTagButtonAction:(UIButton *)sender{
    
    [self executeZeppaTagFollowApi:sender];
}

// User tapped the time, indicate
- (IBAction)eventTimeBtnTapped:(UIButton*)sender {
    // Identify Calendar Conflicts
}

// Tapped the location
- (IBAction)eventLocationBtnTapped:(UIButton*)sender {
    // Open
}

// Show the user who is going
- (IBAction)attendingUsersBtnTapped:(UIButton*)sender {
    
}

/*
 * User tapped description to see more, or hide it
 */
- (IBAction)descriptionTapped:(UIButton*)sender {
    
    
    CGSize desiredSize = [_lbl_EventDescription sizeThatFits:CGSizeMake(_lbl_EventDescription.frame.size.width, CGFLOAT_MAX)];
    CGFloat desiredHeight = desiredSize.height;

    if(_lbl_EventDescription.frame.size.height < desiredHeight){
        // If the current height is not the desired height, make it the desired height
        self.eventOverviewHeightConstraint.constant += (desiredHeight - self.descHeight.constant);
        self.descHeight.constant = desiredHeight;
        
    } else {
        CGFloat resize = _lbl_EventDescription.font.lineHeight * 3;
        self.eventOverviewHeightConstraint.constant -= (self.descHeight.constant-resize);
        // Was already desired height, make it 3 lines
        self.descHeight.constant = resize;
    }

    // Animate the layout changes
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
 
    [self resizeScrollViewContent];

}


///*************************************************
#pragma mark - Keyboard Notification Private Method
///*************************************************

-(void)registerForNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification*)notification {
    
    // TODO: handle this appropriately
    
}
-(void)keyboardWillHide:(NSNotification *)notification
{

    // TODO: handle this appropriately
    [self.scollView_base setContentOffset:CGPointZero];
    
}

///*****************************************************
#pragma mark - TextView Delegate Method
///*****************************************************

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    NSUInteger newLength = [textView.text length] + [text length] - range.length;
//    
//    _whiteLabelInTextView.hidden = (newLength == 0) ? NO : YES;
//    
    //return (newLength > [ZPAStaticHelper getMaxCharacterInTextField]) ? NO : YES;
    
    if(textView == self.discussTextView && textView.contentSize.height != self.discussionBoardHeight.constant) {
        
        // Should resize
        
        
    }
//    CGRect frame = textView.frame;
//    frame.size.height = textView.contentSize.height;
//    textView.frame = frame;
    
    return YES;

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _currentTextView = textView;
    
    [ZPAStaticHelper setContentOffSetof:textView insideInView:_scollView_base];
    
    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    keyboardToolBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked)];
    
    [keyboardToolBar setItems: [NSArray arrayWithObjects:flexibleSpace,doneButton,nil]];
    
    textView.inputAccessoryView = keyboardToolBar;
    
    // Resize the height of the text view if needed
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat heightBeforeResize = self.discussionTextHeight.constant;
    [self.handler resizeTextViewWithAnimation:YES];
    CGFloat heightAfterResize = self.discussionTextHeight.constant;
    
    // Resize views if needed
    if((textView == self.discussTextView) && (heightBeforeResize != heightAfterResize)){
        CGFloat heightChange = heightAfterResize - heightBeforeResize;

        self.discussBaseHeight.constant+=heightChange;
        self.discussionBoardHeight.constant += heightChange;

        [self resizeScrollViewContent];
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
}

-(void)doneButtonClicked{
    
    [_currentTextView resignFirstResponder];
    //[self.tableView reloadData];
}

///*************************************************
#pragma mark - Tag Private Method ..
///*************************************************
-(void)showTagButtonWithTitleString:(NSString *)title andTag:(GTLZeppaclientapiEventTag *)tag{
    
    if (![title isEqualToString:@""]) {
        title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
        UIButton *newButton =[[UIButton alloc]init];
        [newButton setTitle:title forState:UIControlStateNormal];
        
        if ([_eventDetail.event.hostId isEqualToNumber:currentUser.endPointUser.identifier] || (![_eventDetail.event.hostId isEqualToNumber:currentUser.endPointUser.identifier] && [_defaultTagsForUser isFollowing:tag])) {
            
            [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [newButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];

        }else {
            [newButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
            [newButton setBackgroundColor:[UIColor whiteColor]];
        }
        
        [newButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [newButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [newButton.layer setBorderWidth:1.0];
        [newButton.layer setBorderColor:[[ZPAStaticHelper zeppaThemeColor]CGColor]];
        [newButton.layer setCornerRadius:3.0];
        [newButton.layer setMasksToBounds:YES];
        
        CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        
        [newButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [newButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [newButton setFrame:CGRectMake(PADDING,PADDING,textSize.width+PADDING,textSize.height+PADDING)];
        [newButton setTag:TAGS_BUTTON_TAG];
    
        
        UIView *newView =[[UIView alloc]init];
        
        if (_tagsTempArray.count!=0) {
            UIView *lastView =(UIView *)[_tagsTempArray lastObject];
            [newView setFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width,lastView.frame.origin.y,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            
            if (newView.frame.origin.x+newButton.frame.size.width>self.view.frame.size.width) {
                newView.frame =CGRectMake(0, newView.frame.origin.y+newView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
                self.tagContainerHeight.constant += newView.frame.size.height;
//                [self updateAllViewsFramesUsingTagButtonBaseView:newView withCounter:0];
            }
            
        }else{
            [newView setFrame:CGRectMake(0,0,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            self.tagContainerHeight.constant = newView.frame.size.height;
           // [self updateAllViewsFramesUsingTagButtonBaseView:newView withCounter:0];
        }
        
        //newButton.tag = DELETE_BUTTON_TAG;
        [newView addSubview:newButton];
        [_tagContainerView addSubview:newView];
        [_tagsTempArray addObject:newView];
        
        if (![_eventDetail.event.hostId isEqualToNumber:currentUser.endPointUser.identifier]) {
            
            [newButton addTarget:self action:@selector(otherEventTagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        // Update the layout if needed
        [self.view layoutIfNeeded];
    }
   // [self setCrossButton];
    
}


///*************************************************
#pragma mark - Show Event Detail Private Method ..
///*************************************************

-(void)showEventDetails{
    
    if(_eventDetail){
        
        if ([_eventDetail.event.hostId isEqualToNumber: currentUser.endPointUser.identifier]) {
            
            
            // Adjust relevant view constraints
            self.eventOverviewHeightConstraint.constant-=self.quickActionHeight.constant;
            self.quickActionHeight.constant=0;
            _qucikActionView.hidden = YES;
            
            
            [self getTagsForCurrentUser];
            
            // Hosts must attend activities
            _imageView_ConflictIndicator.image = [UIImage imageNamed:@"small_circle_blue.png"];
            
            // Update title to reflect that current user hosts
            self.title = [NSString stringWithFormat:@"My %@",self.title];
            
        }else{
            
            // Make sure the cancel option is hidden
            _cancelBarButton.enabled = NO;
            _cancelBarButton.tintColor = [UIColor clearColor];
            
            if (_isMinglerTag == YES) {
                [self getTagsForMinglersScreen];
            }else{
            
            [self getTagsOtherUserEvent];
            }
            
            // If guests may not send invites and this is a guest...
            if ([_eventDetail.event.guestsMayInvite boolValue] == false) {
                
                // Remove the Invites option from the details view
                self.eventDetailHeight.constant-=self.addInvitesBaseHeight.constant;
                self.addInvitesBaseHeight.constant = 0;
                [self.addInvitesSeperatorView setHidden:YES];
                
            }
            
            // Set attending/ watching button indication
            if ([_eventDetail.relationship.isWatching boolValue] == true) {
                [_watchButton setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
            }
            else{
                [_watchButton setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
            }
            if ([_eventDetail.relationship.isAttending boolValue] == true) {
                [_joinButton setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
            }
            else{
                [_joinButton setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
            }
        }
        
        
        // Make sure you can see the whole title
        _lbl_EventTitle.text = _eventDetail.event.title;
        // Set the height of the title as needed
        CGFloat titleWidth = self.view.frame.size.width - (RIGHT_TITLE_STORYBOARD_OFFSET + LEFT_TITLE_STORYBOARD_OFFSET);
        CGSize titleSize = [self.lbl_EventTitle sizeThatFits:CGSizeMake(titleWidth, MAXFLOAT)];
        CGFloat titleResize = titleSize.height - self.titleHeight.constant;
        if(titleResize> 0) {
            self.eventOverviewHeightConstraint.constant+=titleResize;
            self.userDetailHeightConstraint.constant +=titleResize;
            self.titleHeight.constant = titleSize.height;
        }
        
        
        
        // Set the duration of the activity
        _lbl_EventDuration.text = [[ZPADateHelper sharedHelper]getEventTimeDuration:_eventDetail.event.start withEndTime:_eventDetail.event.end];
        
        // set the display location of the activity
        _lbl_EventDisplayLocation.text = _eventDetail.event.displayLocation;
        
        id zeppaUser = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[_eventDetail.event.hostId longLongValue]];
        
        if ([zeppaUser isKindOfClass:[ZPADefaulZeppatUserInfo class]]) {
            
            _userInfo = zeppaUser;
            
            NSURL *profileImageURL = [NSURL URLWithString:_userInfo.zeppaUserInfo.imageUrl];
            [_userProfile_ImageView setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
            }];
            
//            [_imageView_discussionUser setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType){
//                
//            }];
            
            NSString * userName = [NSString stringWithFormat:@"%@ %@",_userInfo.zeppaUserInfo.givenName,_userInfo.zeppaUserInfo.familyName];
            
//            _lbl_discussionUserName.text = userName;
            _lbl_EventHostName.text = userName;
            
            [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_ConflictIndicator withZeppaEvent:_eventDetail];
            
            [self setAttendingUserButtonText:_invitedUserBtn];
            
        }else{
            
            ZPAMyZeppaUser * user = zeppaUser;
            
            NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
            [_userProfile_ImageView setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
            }];
            
//            [_imageView_discussionUser setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType){
//                
//            }];
            
            NSString *userName = [NSString stringWithFormat:@"%@ %@",user.endPointUser.userInfo.givenName,user.endPointUser.userInfo.familyName];
            
//            _lbl_discussionUserName.text = userName;
            _lbl_EventHostName.text = userName;
            
            
            
            [self setAttendingUserButtonForOwnEvent:_invitedUserBtn];
        }
        
        
        /**
         * Adjust the description height
         */
        NSString * description = self.eventDetail.event.descriptionProperty;
        CGFloat descriptionHeight = 0;
        if(description.length>0) {
        
            // Set the appropriate height of the description
            self.lbl_EventDescription.text = description;
            CGSize desiredSize = [self.lbl_EventDescription sizeThatFits:CGSizeMake(_lbl_EventDescription.frame.size.width, CGFLOAT_MAX)];
            CGFloat desiredHeight = desiredSize.height;
            CGFloat lineHeight = self.lbl_EventDescription.font.lineHeight;
            
            descriptionHeight = 3 * lineHeight;
            
            if(desiredHeight<descriptionHeight) {
                descriptionHeight = desiredHeight;
                // Will not need to expand
                [self.btn_eventDescription setEnabled:NO];
            }

        }
        self.eventOverviewHeightConstraint.constant+=(descriptionHeight-self.descHeight.constant);
        self.descHeight.constant = descriptionHeight;
        
        // Layout the view if it's needed
        [self.view layoutIfNeeded];
        [self resizeScrollViewContent];
    }

    
}


-(void)getTagsOtherUserEvent{
    
    _defaultTagsForUser = [[ZPAFetchDefaultTagsForUser alloc]init];
    _defaultTagsForUser.delgate = self;
    [_defaultTagsForUser executeZeppaApiWithUserId:[self getUserID] andMinglerId:[_eventDetail.event.hostId longLongValue]];
}

-(void)getMutualMinglerTags{
    
    if (_eventDetail.getTagIds.count == 0 ) {
        // Should never happen
        _tagsArray = [[NSMutableArray alloc] init];
    }else{
        _tagsArray = [[[ZPAZeppaEventTagSingleton sharedObject]getTagsFromTagIdsArray:_eventDetail.getTagIds]mutableCopy];
    }
    
    // There is a slight possibility the host attached tags to the event then deleted them before event ended.
    // Must account for this
    _tagContainerView.hidden = (_tagsArray.count>0)?NO:YES;
    
    if (_tagContainerView.hidden == YES) {
        self.tagContainerHeight.constant = 0;
        return;
    }
    
    
    for (GTLZeppaclientapiEventTag *tag in _tagsArray) {
        [self showTagButtonWithTitleString:tag.tagText andTag:tag];
    }
    
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}


-(long long)getUserID{
    
    return [[[ZPAZeppaUserSingleton sharedObject] userId] longLongValue];
}

-(void)getTagsForCurrentUser{
    
    _tagsArray =  [[[ZPAZeppaEventTagSingleton sharedObject]getTagsFromTagIdsArray:_eventDetail.event.tagIds]mutableCopy];
    
    _tagContainerView.hidden = (_tagsArray.count>0)?NO:YES;
    
    if (_tagContainerView.hidden == YES) {
        self.tagContainerHeight.constant = 0;
        return;
    }

    
    for (GTLZeppaclientapiEventTag *tag in _tagsArray) {
        
        [self showTagButtonWithTitleString:tag.tagText andTag:tag];
        
    }

}

-(void)getTagsForMinglersScreen{
    
    _tagsArray =  [[[ZPAZeppaEventTagSingleton sharedObject]getTagsFromTagIdsArray:_eventDetail.event.tagIds]mutableCopy];
    
    _tagContainerView.hidden = (_tagsArray.count>0)?NO:YES;
    
    if (_tagContainerView.hidden == YES) {
        self.tagContainerHeight.constant = 0;
    }
    
    
    for (GTLZeppaclientapiEventTag *tag in _tagsArray) {
        
      [self showTagButtonWithTitleString:tag.tagText andTag:tag];
        
    }

}

//****************************************************
#pragma mark - Private methods
//****************************************************

- (void) resizeScrollViewContent {
    
    self.scollView_base.contentSize = CGSizeMake(self.view.frame.size.width, (self.userDetailHeightConstraint.constant + self.tagContainerHeight.constant + self.eventDetailHeight.constant + self.discussionBoardHeight.constant + PADDING));
}

/*
 * Add a discussion view to a event view controller
 */
-(void)addDiscussionCellWithComment: (GTLZeppaclientapiEventComment *) comment {
    
    // Draw the discussion view cell
    ZPADiscussionCell *discussionCell = [[[NSBundle mainBundle] loadNibNamed:@"Discussion_View" owner:self options:nil]firstObject];
    CGRect frame = discussionCell.frame;
    frame.size.width = _discussionContainerView.frame.size.width;
    discussionCell.frame = frame;
    
    [discussionCell defineCellWidth:_discussionContainerView.frame.size.width];
    [discussionCell showEventCommentDetail:comment];

    // Add view to the discussion container
    [_discussionContainerView addSubview:discussionCell];

    // Reframe the cell
    discussionCell.frame = CGRectMake(0, _discussionContainerHeight.constant, discussionCell.frame.size.width, discussionCell.frame.size.height);
    
    
    // extend container cells
    _discussionBoardHeight.constant+=discussionCell.frame.size.height;
    _discussionContainerHeight.constant+=discussionCell.frame.size.height;
    
    [self resizeScrollViewContent];
    [self.view layoutIfNeeded];
}


-(void)setAttendingUserButtonText:(UIButton *)sender{
    
//    attendingUser = [[[ZPAZeppaEventSingleton sharedObject] getAttendingUserIds:_eventDetail] mutableCopy];
    if (attendingUser.count == 0 && [_eventDetail.relationship.isAttending boolValue] == false) {
        
        [sender setTitle:@"Be the first to join" forState:UIControlStateNormal];
    }else{
        NSMutableArray * attendingMinglerArr = [NSMutableArray arrayWithArray:[[ZPAZeppaUserSingleton sharedObject] getMinglersFrom:attendingUser]];
        
        if (_eventDetail.relationship.isAttending) {
            if (attendingUser.count == 0 || (attendingUser.count ==1 && ! [attendingUser containsObject:currentUser.endPointUser.identifier])) {
                
                [sender setTitle:@"You joined first" forState:UIControlStateNormal];
            }else{
                NSInteger attendingSize = attendingUser.count;
                if ([attendingUser containsObject:currentUser.endPointUser.identifier]) {
                    attendingSize -=1;
                }
                [sender setTitle:[NSString stringWithFormat:@"Friends with %ldl / %ldl people going",(unsigned long)attendingMinglerArr.count,(long)attendingSize] forState:UIControlStateNormal];
            }
        }else{
            
            if (attendingUser.count == 0 || (attendingUser.count ==1 && [attendingUser containsObject:currentUser.endPointUser.identifier])) {
                
                [sender setTitle:@"Be the first to join" forState:UIControlStateNormal];
            }else{
                NSInteger attendingSize = attendingUser.count;
                if ([attendingUser containsObject:currentUser.endPointUser.identifier]) {
                    attendingSize -=1;
                }
                [sender setTitle:[NSString stringWithFormat:@"Friends with %ldl / %ldl people going",(unsigned long)attendingMinglerArr.count,(long)attendingSize] forState:UIControlStateNormal];
            }
            
        }
    }

    
    
}

-(void)setAttendingUserButtonForOwnEvent:(UIButton *)sender{
    
    //attendingUser = [[[ZPAZeppaEventSingleton sharedObject] getAttendingUserIds:_eventDetail] mutableCopy];


    if (attendingUser.count == 0 && [_eventDetail.relationship.isAttending boolValue] == false) {
        
        [sender setTitle:@"Nobody joined yet" forState:UIControlStateNormal];
    }else{
        
        NSString * btnTitle = [NSString stringWithFormat:@"%lu People Going",(unsigned long)attendingUser.count];
        [sender setTitle:btnTitle forState:UIControlStateNormal];
        
    }
    
}
    

-(void)showAttendingUserMediator:(UIButton *)sender{
    
    //ZPAMyZeppaEvent *myZeppaEvent = [[ZPAMyZeppaEvent alloc]init];
  //  attendingUser = [[[ZPAZeppaEventSingleton sharedObject] getAttendingUserIds:_eventDetail] mutableCopy];
    
    NSMutableArray * userInfoArray =[NSMutableArray arrayWithArray: [[ZPAZeppaUserSingleton sharedObject]getMinglersFrom:attendingUser]];
    
    if (userInfoArray.count == 0) {
        [ZPAStaticHelper showAlertWithTitle:nil andMessage:@"Nobody joined yet"];
    }else{
        
        NSString * btnTitle = [NSString stringWithFormat:@"%lu People Going",(unsigned long)userInfoArray.count];
        [sender setTitle:btnTitle forState:UIControlStateNormal];
        
        
        
    }
    
    
}

-(void)insertOrUpdateEventRelationship:(GTLZeppaclientapiZeppaEventToUserRelationship *)zeppaEventRelationShip withUserId:(NSNumber *)userId{
    
    if (zeppaEventRelationShip) {
        [self executeUpdateEventRelationship:zeppaEventRelationShip withUserId:userId];
    }else{
        
        [self executeInsertZeppaEventRelationshipWithUserId:userId];
        
    }
    
}

-(void )executeZeppaTagFollowApi:(UIButton *)tagButton{
    
    
    GTLZeppaclientapiEventTagFollow * tagFollow = [[GTLZeppaclientapiEventTagFollow alloc]init];
    
    
    
    for (GTLZeppaclientapiEventTag * tag in _tagsArray) {
        if ([tag.tagText.uppercaseString isEqualToString:tagButton.titleLabel.text.uppercaseString]) {
            
            if ([_defaultTagsForUser isFollowing:tag ] == NO ){
                
                [tagButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
                [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                tagFollow.tagOwnerId = _userInfo.userId;
                tagFollow.followerId = currentUser.endPointUser.identifier;
                tagFollow.tagId = tag.identifier;
                [_defaultTagsForUser insertZeppaTagFollow:tagFollow];
                
            }else{
                
                [_defaultTagsForUser removeZeppaTagFollow:tag];
                [tagButton setBackgroundColor:[ UIColor whiteColor]];
                [tagButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
            }
        }
    }
    
}



//****************************************************
#pragma mark - Add Invites Delegate methods
//****************************************************


-(void)noOfInvitees{
    
    invitedUserIdArray = addInvites.invitesUserIdArray;
    
    if (invitedUserIdArray.count == 0 ) {
        _lbl_invitedUserNo.text = @"";
    }else{
    _lbl_invitedUserNo.text = [NSString stringWithFormat:@"%zd",invitedUserIdArray.count];
   }
    for (NSNumber * userId in invitedUserIdArray) {
        [self insertOrUpdateEventRelationship:_eventDetail.relationship withUserId:userId];
    }
}

//****************************************************
#pragma mark - Zeppa Event Comment methods
//****************************************************

-(void)executeListEventComment{
    
    NSString * filterStr = [NSString stringWithFormat:@"eventId == %@",_eventDetail.event.identifier];
    
    GTLQueryZeppaclientapi * commentListQuery = [GTLQueryZeppaclientapi queryForListEventCommentWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [commentListQuery setFilter:filterStr];
    [commentListQuery setOrdering:@"created desc"];
    
    [[self eventCommentService] executeQuery:commentListQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseEventComment * response, NSError *error) {
        
        if (error) {
            NSLog(@"Error while executing event comment List Query %@",error.description);
            
        }else if (response && response.items &&response.items.count > 0){
            
            eventCommentArray = [response.items mutableCopy];
            
            
            for (GTLZeppaclientapiEventComment *eventComment in response.items) {
                
                
                [eventCommentArray addObject:eventComment];
                [self addDiscussionCellWithComment:eventComment];
                
            }
            
            
        }
        
    }];
    
    
}


-(void)executeInsertEventComment{
    
    GTLZeppaclientapiEventComment * eventComment = [[GTLZeppaclientapiEventComment alloc]init];
    
    [eventComment setCommenterId:[NSNumber numberWithLongLong:[self getUserID]]];
    [eventComment setText:_discussTextView.text];
    [eventComment setEventId:_eventDetail.event.identifier];
    
    // Set the text color to indicate posting
    _discussTextView.textColor = [UIColor grayColor];
    
    GTLQueryZeppaclientapi *inserComment = [GTLQueryZeppaclientapi queryForInsertEventCommentWithObject:eventComment idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    [[self eventCommentService] executeQuery:inserComment completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiEventComment * object, NSError *error) {

        if (error) {
            NSLog(@"Error inserting Comment %@",error.description);
            _discussTextView.textColor = [UIColor blackColor];
        }else if (object.identifier){
            
            [eventCommentArray addObject:object];
            [self addDiscussionCellWithComment:object];

        }
        
    }];
    
    
}

-(void)executeUpdateEventRelationship:(GTLZeppaclientapiZeppaEventToUserRelationship *)eventRelationShip withUserId:(NSNumber *)userId{
    

    
    GTLZeppaclientapiZeppaEventToUserRelationship * eventRelationship = [[GTLZeppaclientapiZeppaEventToUserRelationship alloc]init];
    
    eventRelationship =eventRelationShip;
    
    [eventRelationship setUserId:userId];
    
    [eventRelationship setInvitedByUserId:currentUser.endPointUser.identifier];
    
    [eventRelationship setIsRecommended:[NSNumber numberWithInt:1]];
    
    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
    
    
    GTLQueryZeppaclientapi * updateRelationship = [GTLQueryZeppaclientapi queryForUpdateZeppaEventToUserRelationshipWithObject:eventRelationship idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [[self zeppaEventToUserRelationshipService] executeQuery:updateRelationship completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEventToUserRelationship * result , NSError *error) {
        
        if (error) {
            NSLog(@"update event relationship unsuccessful %@",error.description);
        }else if(result.identifier){
            
            NSLog(@"Update Successfull");
            _eventDetail.relationship = result;
            
        }
        
        
        
    }];
    
}



-(void)executeInsertZeppaEventRelationshipWithUserId:(NSNumber *)userId{
    
    GTLZeppaclientapiZeppaEventToUserRelationship * eventRelationship = [[GTLZeppaclientapiZeppaEventToUserRelationship alloc]init];
    
    [eventRelationship setEventId:_eventDetail.event.identifier];
    [eventRelationship setUserId:userId];
    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
    [eventRelationship setInvitedByUserId:currentUser.endPointUser.identifier];
    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
    [eventRelationship setIsRecommended:[NSNumber numberWithInt:0]];
    
    GTLQueryZeppaclientapi *inserQuery = [GTLQueryZeppaclientapi queryForInsertZeppaEventToUserRelationshipWithObject:eventRelationship idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [[self zeppaEventToUserRelationshipService] executeQuery:inserQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEventToUserRelationship * result, NSError *error) {
        
        if (error) {
            NSLog(@"error updating event relatioship %@",error.description);
            
            
        }else if (result.identifier){
            
            NSLog(@"Update Successfull");
            _eventDetail.relationship = result;

        }
        
        
    }];
    
    
    
}

-(void)removeZeppaEventWithIdentifier:(long long) identifier{
    GTLQueryZeppaclientapi *removeZeppaEvent = [GTLQueryZeppaclientapi queryForRemoveZeppaEventWithIdentifier:identifier idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    [self.zeppaEventService executeQuery:removeZeppaEvent completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        //
        if(error){
            [ZPAStaticHelper showAlertWithTitle:@"Error" andMessage:@"Error removing event"];
        } else {
            
            [[ZPAZeppaEventSingleton sharedObject]removeEventById:identifier];
            
            [progress hide:YES];
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

- (void) notificationReceived: (NSNotification*) notification {
    
    if([notification.name isEqualToString:@"ZeppaNotification"]){
        GTLZeppaclientapiZeppaNotification *notif = notification.object;
        
        if(notif.eventId && [self.eventDetail doesMatchEventId:notif.eventId.longLongValue]){
        
            switch ([[ZPANotificationSingleton sharedObject] getNotificationTypeOrder:notif.type]){
                
                case 4: // Someone commented on this event
                    [self executeListEventComment];
                    break;
                    
                case 6: // Someone joined
                case 7: // Or someone left
                    // TODO: update event to user relationships
                    break;
            }
            
        }
    }
    
}

-(GTLServiceZeppaclientapi *)zeppaEventService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
}



-(GTLServiceZeppaclientapi *)zeppaEventToUserRelationshipService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}


-(GTLServiceZeppaclientapi *)eventCommentService{
    
    static GTLServiceZeppaclientapi *service = nil;
    if (!service) {
        service = [[GTLServiceZeppaclientapi alloc]init];
        service.retryEnabled = YES;
    }
    
    return service;
}



@end
