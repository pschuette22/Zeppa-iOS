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
#import "ZPADefaultZeppaEventInfo.h"
#import "ZPAAddInvitesVC.h"
#import "ZPADiscussionCell.h"
#import "ZPAUserInfoBase.h"
#import "ZPAMutualMinglerVC.h"
#import "ZPAEventInfoBase.h"
#import "ZPAEventTagBase.h"
#import "ZPADefaultEventTag.h"
#import "ZPAMapsVC.h"

#import "MBProgressHUD.h"

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"

#import "GTLZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"

#import "GTLZeppaclientapiCollectionResponseEventComment.h"
#import "GTLZeppaclientapiEventComment.h"
#import "ZPAAuthenticatonHandler.h"

#import "GrowingTextViewHandler.h"
@import GoogleMaps;


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
    ZPAAddInvitesVC * addInvites;
    MBProgressHUD * progress;

}

@property (nonatomic, strong)UITextView *currentTextView;
@property (nonatomic, assign)NSInteger scrollViewHeight;
@property (strong, nonatomic) GrowingTextViewHandler *handler;

@end

@implementation ZPAEventDetailVC {
    NSMutableArray *_tagViewArray;
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
    
//    if (_tableView_discussion.hidden == YES) {
//        discussionCellCount = 0;
//    }
//    if (discussionCellCount >0) {
//        _tableView_discussion.hidden = NO;
//    }
   // [temp addObject:@"1"];
    
    [self makeDesignForAllControl];
    [self registerForNotifications];
    [self showEventDetails];
    
    // set the description label handler
    self.handler = [[GrowingTextViewHandler alloc]initWithTextView:self.discussTextView withHeightConstraint:self.discussionTextHeight];
    [self.handler updateMinimumNumberOfLines:1 andMaximumNumberOfLine:6];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    addInvites = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAAddInvitesVC"];
   // _lbl_NoOfInvitedUser.text =[NSString stringWithFormat:@"%lu",(unsigned long)addInvites.invitesUserIdArray.count];
    
    
//    _scollView_base.contentSize = CGSizeMake(0, _discussionPostBaseView.frame.origin.y+_discussionPostBaseView.frame.size.height+10);
    
    //[self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ZeppaNotification"
                                               object:nil];

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
    if([self.eventInfo.zeppaEvent.privacy isEqualToString:@"PRIVATE"]){
        self.title = @"Private Activity";
//    } else if ([self.eventDetail.event.privacy isEqualToString:@"CASUAL"]) {
//        self.title = @"Casual Activity";
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
        
        addInvites.zeppaEvent = _eventInfo;
        
        addInvites.delegate = self;
    }
    else if ([segue.identifier isEqualToString:SEGUE_ID_JOINED_USER]) {
        
        ZPAMutualMinglerVC *minglerVC = [segue destinationViewController];
        minglerVC.isAttendingUser = YES;
        
        
        NSMutableArray *attendingUserRelationships = [[NSMutableArray alloc] init];
        for(GTLZeppaclientapiZeppaEventToUserRelationship *relationship in _eventInfo.relationships){
            if([relationship isAttending]) {
                [attendingUserRelationships addObject:relationship];
            }
        }
        
        
        minglerVC.attendingUserIdArr = attendingUserRelationships;
    }
    
}

/*
 * Should open the app in maps
 */
- (IBAction)mapBtnTapped:(UIButton*)sender {
    ZPAMapsVC *mapVC = [[ZPAMapsVC alloc] init];
    mapVC.eventDetails = _eventInfo;
    [self.navigationController pushViewController:mapVC animated:YES];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
//    if ([identifier isEqualToString: @"joinedUser"]) {
//        
//        if (attendingUser.count == 0) {
//            
//            return NO;
//        }else{
//            return YES;
//        }
//    }
    return YES;
}



///**********************************************
#pragma mark - Initialization Method
///**********************************************
-(void)initialization{
    _tagViewArray = [NSMutableArray array];
//    _tagsTempArray = [NSMutableArray array];
//    invitedUserIdArray = [NSMutableArray array];
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
    
//    [self executeInsertEventComment];
    
    [self doneButtonClicked];
    
    
   // _scollView_base.contentSize = CGSizeMake(320, _tableView_discussion.frame.origin.y+_tableView_discussion.frame.size.height+5);
    
   
   // _tableView_discussion.hidden = NO;
    
    _tableView_discussion.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
}


- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender {
    
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [progress setLabelText:@"Canceling Event..."];
    [progress show:YES];
//    [self removeZeppaEventWithIdentifier:[_eventInfo.zeppaEvent.identifier longLongValue]];
    
}

- (IBAction)joinBtnTapped:(UIButton *)sender {
    
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [progress show:YES];
    
    if (![_eventInfo isAttending]) {
        [sender setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
        [_watchButton setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
        
    }
    else{
        [_watchButton setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
    }
    
    
    if([_eventInfo respondsToSelector:@selector(onJoinButtonClicked)]) {
        ZPADefaultZeppaEventInfo *defaultEventInfo = (ZPADefaultZeppaEventInfo*) _eventInfo;
        [defaultEventInfo onJoinButtonClicked];
    
        // TODO: update the UI as necessary
    }

}


- (IBAction)watchBtnTapped:(UIButton *)sender {
    
    if (![_eventInfo isWatching]) {
        [sender setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
    }
    
    if([_eventInfo respondsToSelector:@selector(onWatchButtonClicked)]) {
        ZPADefaultZeppaEventInfo *defaultEventInfo = (ZPADefaultZeppaEventInfo*) _eventInfo;
        [defaultEventInfo onWatchButtonClicked];
        
        // TODO: update the UI as necessary
    }

}

-(IBAction)cancelBtnTappped:(UIBarButtonItem *)sender{
    
    // TODO: raise a confirm dialog

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)invitedUserBtnTapped:(UIButton *)sender {
    
    // TODO: navigate to the invite people view controller
    
   // [self setAttendingUserButtonText:sender];
//    [self showAttendingUserMediator:sender];
    // TODO: navigate to invite users page
    
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
 // Navigate to the attending people screen
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
    // Listen for notifications sent to the device
}

-(void)unregisterFromNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
-(void)showButtonWithTag:(ZPAEventTagBase *)tag{
    NSString *title = tag.tag.tagText;
    
    UIButton *newButton =[[UIButton alloc]init];
    [newButton setTitle:title forState:UIControlStateNormal];
    
    
    if([tag isMyTag]){
        // This tag is the current users, initialize it accordingly
        [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
        
    } else {
        ZPADefaultEventTag *defaultTag = (ZPADefaultEventTag*)tag;
        
        if([defaultTag isFriendTag]){
            
            if([defaultTag isFollowing]) {
                [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [newButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
            } else {
                [newButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
                [newButton setBackgroundColor:[UIColor whiteColor]];
            }
            
            [newButton addTarget:defaultTag action:@selector(onTagTapped:) forControlEvents:UIControlEventTouchUpInside];
            
        } else {
            // This is a tag that cannot be interacted with, make that very apparent
            [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [newButton setBackgroundColor:[UIColor grayColor]];
        }
        
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
    
    if (_tagViewArray.count!=0) {
        UIView *lastView =(UIView *)[_tagViewArray lastObject];
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
    [_tagViewArray addObject:newView];

    
    // If this is a followable tag, add the selector
    
    // Update the layout if needed
    [self.view layoutIfNeeded];
    
    
}


///*************************************************
#pragma mark - Show Event Detail Private Method ..
///*************************************************

-(void)showEventDetails{
    
        //************************************
        // STEP 1. Set the host name and image
        //************************************
        _lbl_EventHostName.text = _hostInfo.getDisplayName;
        
        NSURL *profileImageURL = [NSURL URLWithString:_hostInfo.userInfo.imageUrl];
        [_userProfile_ImageView setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
        }];
        
        //******************************************************************
        // STEP 2. Set the basic event stuff that is the same no matter what
        //******************************************************************
        // Make sure you can see the whole title
        _lbl_EventTitle.text = _eventInfo.zeppaEvent.title;
        // Set the height of the title as needed
        CGFloat titleWidth = self.view.frame.size.width - (RIGHT_TITLE_STORYBOARD_OFFSET + LEFT_TITLE_STORYBOARD_OFFSET);
        CGSize titleSize = [self.lbl_EventTitle sizeThatFits:CGSizeMake(titleWidth, MAXFLOAT)];
        CGFloat titleResize = titleSize.height - self.titleHeight.constant;
        if(titleResize> 0) {
            self.eventOverviewHeightConstraint.constant+=titleResize;
            self.userDetailHeightConstraint.constant +=titleResize;
            self.titleHeight.constant = titleSize.height;
        }
        
        /**
         * Adjust the description height
         */
        NSString * description = _eventInfo.zeppaEvent.description;
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
        // Set the duration of the activity
        _lbl_EventDuration.text = [[ZPADateHelper sharedHelper]getEventTimeDuration:_eventInfo.zeppaEvent.start withEndTime:_eventInfo.zeppaEvent.end];
        
        // set the display location of the activity
        _lbl_EventDisplayLocation.text = _eventInfo.zeppaEvent.displayLocation;
        
        
        
        //**********************************************************************************
        // STEP 3. Set display stuff that varies depending on if this is current users event
        //**********************************************************************************
        if ([_eventInfo isMyEvent]) {
            
            
            // Adjust relevant view constraints
            self.eventOverviewHeightConstraint.constant-=self.quickActionHeight.constant;
            self.quickActionHeight.constant=0;
            _qucikActionView.hidden = YES;
            
            
//            [self getTagsForCurrentUser];
            
            // Hosts must attend activities
            _imageView_ConflictIndicator.image = [UIImage imageNamed:@"small_circle_blue.png"];
            
            // Update title to reflect that current user hosts it
            self.title = [NSString stringWithFormat:@"My %@",self.title];
            
//            [self setAttendingUserButtonForOwnEvent:_invitedUserBtn];

        }else{
            ZPADefaultZeppaEventInfo *defaultEventInfo = (ZPADefaultZeppaEventInfo*) _eventInfo;
            // Make sure the cancel option is hidden
            _cancelBarButton.enabled = NO;
            _cancelBarButton.tintColor = [UIColor clearColor];
            
//            if (_isMinglerTag == YES) {
//                [self getTagsForMinglersScreen];
//            }else{
//            
//                [self getTagsOtherUserEvent];
//            }
            
            // If guests may not send invites and this is a guest...
            if ([_eventInfo.zeppaEvent.guestsMayInvite boolValue] == false) {
                
                // Remove the Invites option from the details view
                self.eventDetailHeight.constant-=self.addInvitesBaseHeight.constant;
                self.addInvitesBaseHeight.constant = 0;
                [self.addInvitesSeperatorView setHidden:YES];
                
            }
            
            // Set attending/ watching button indication
            if ([defaultEventInfo.relationship.isWatching boolValue] == true) {
                [_watchButton setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
            }
            else{
                [_watchButton setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
            }
            if ([defaultEventInfo.relationship.isAttending boolValue] == true) {
                [_joinButton setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
            }
            else{
                [_joinButton setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
            }
            
//            [self setAttendingUserButtonText:_invitedUserBtn];

        }
        
        //**********************************
        // Step 4. size and lay the view out
        //**********************************
        // Layout the view if it's needed
        [self.view layoutIfNeeded];
//        [self resizeScrollViewContent];
    

    
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
    
////    attendingUser = [[[ZPAZeppaEventSingleton sharedObject] getAttendingUserIds:_eventDetail] mutableCopy];
//    if (attendingUser.count == 0 && [_eventDetail.relationship.isAttending boolValue] == false) {
//        
//        [sender setTitle:@"Be the first to join" forState:UIControlStateNormal];
//    }else{
//        NSMutableArray * attendingMinglerArr = [NSMutableArray arrayWithArray:[[ZPAZeppaUserSingleton sharedObject] getMinglersFrom:attendingUser]];
//        
//        if (_eventDetail.relationship.isAttending) {
//            if (attendingUser.count == 0 || (attendingUser.count ==1 && ! [attendingUser containsObject:currentUser.endPointUser.identifier])) {
//                
//                [sender setTitle:@"You joined first" forState:UIControlStateNormal];
//            }else{
//                NSInteger attendingSize = attendingUser.count;
//                if ([attendingUser containsObject:currentUser.endPointUser.identifier]) {
//                    attendingSize -=1;
//                }
//                [sender setTitle:[NSString stringWithFormat:@"Friends with %ldl / %ldl people going",(unsigned long)attendingMinglerArr.count,(long)attendingSize] forState:UIControlStateNormal];
//            }
//        }else{
//            
//            if (attendingUser.count == 0 || (attendingUser.count ==1 && [attendingUser containsObject:currentUser.endPointUser.identifier])) {
//                
//                [sender setTitle:@"Be the first to join" forState:UIControlStateNormal];
//            }else{
//                NSInteger attendingSize = attendingUser.count;
//                if ([attendingUser containsObject:currentUser.endPointUser.identifier]) {
//                    attendingSize -=1;
//                }
//                [sender setTitle:[NSString stringWithFormat:@"Friends with %ldl / %ldl people going",(unsigned long)attendingMinglerArr.count,(long)attendingSize] forState:UIControlStateNormal];
//            }
//            
//        }
//    }

    
    
}

-(void)setAttendingUserButtonForOwnEvent:(UIButton *)sender{
    
    //attendingUser = [[[ZPAZeppaEventSingleton sharedObject] getAttendingUserIds:_eventDetail] mutableCopy];


//    if (attendingUser.count == 0 && [_eventDetail.relationship.isAttending boolValue] == false) {
//        
//        [sender setTitle:@"Nobody joined yet" forState:UIControlStateNormal];
//    }else{
//        
//        NSString * btnTitle = [NSString stringWithFormat:@"%lu People Going",(unsigned long)attendingUser.count];
//        [sender setTitle:btnTitle forState:UIControlStateNormal];
//        
//    }
    
}
    

-(void)showAttendingUserMediator:(UIButton *)sender{
    
//    //ZPAMyZeppaEvent *myZeppaEvent = [[ZPAMyZeppaEvent alloc]init];
//  //  attendingUser = [[[ZPAZeppaEventSingleton sharedObject] getAttendingUserIds:_eventDetail] mutableCopy];
//    
//    NSMutableArray * userInfoArray =[NSMutableArray arrayWithArray: [[ZPAZeppaUserSingleton sharedObject]getMinglersFrom:attendingUser]];
//    
//    if (userInfoArray.count == 0) {
//        [ZPAStaticHelper showAlertWithTitle:nil andMessage:@"Nobody joined yet"];
//    }else{
//        
//        NSString * btnTitle = [NSString stringWithFormat:@"%lu People Going",(unsigned long)userInfoArray.count];
//        [sender setTitle:btnTitle forState:UIControlStateNormal];
//        
//        
//        
//    }
    
    
}

-(void)insertOrUpdateEventRelationship:(GTLZeppaclientapiZeppaEventToUserRelationship *)zeppaEventRelationShip withUserId:(NSNumber *)userId{
    
    if (zeppaEventRelationShip) {
        [self executeUpdateEventRelationship:zeppaEventRelationShip withUserId:userId];
    }else{
        
        [self executeInsertZeppaEventRelationshipWithUserId:userId];
        
    }
    
}

//-(void )executeZeppaTagFollowApi:(UIButton *)tagButton{
//    
//    
//    GTLZeppaclientapiEventTagFollow * tagFollow = [[GTLZeppaclientapiEventTagFollow alloc]init];
//    
//    
//    
//    for (GTLZeppaclientapiEventTag * tag in _tagsArray) {
//        if ([tag.tagText.uppercaseString isEqualToString:tagButton.titleLabel.text.uppercaseString]) {
//            
//            if ([_defaultTagsForUser isFollowing:tag ] == NO ){
//                
//                [tagButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
//                [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                
//                tagFollow.tagOwnerId = _userInfo.userId;
//                tagFollow.followerId = currentUser.endPointUser.identifier;
//                tagFollow.tagId = tag.identifier;
//                [_defaultTagsForUser insertZeppaTagFollow:tagFollow];
//                
//            }else{
//                
//                [_defaultTagsForUser removeZeppaTagFollow:tag];
//                [tagButton setBackgroundColor:[ UIColor whiteColor]];
//                [tagButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
//            }
//        }
//    }
//    
//}



//****************************************************
#pragma mark - Add Invites Delegate methods
//****************************************************


-(void)noOfInvitees{
    
//    invitedUserIdArray = addInvites.invitesUserIdArray;
//    
//    if (invitedUserIdArray.count == 0 ) {
//        _lbl_invitedUserNo.text = @"";
//    }else{
//    _lbl_invitedUserNo.text = [NSString stringWithFormat:@"%zd",invitedUserIdArray.count];
//   }
//    for (NSNumber * userId in invitedUserIdArray) {
//        [self insertOrUpdateEventRelationship:_eventDetail.relationship withUserId:userId];
//    }
}

//****************************************************
#pragma mark - Zeppa Event Comment methods
//****************************************************

-(void)executeListEventComment{
    
//    NSString * filterStr = [NSString stringWithFormat:@"eventId == %@",_eventDetail.event.identifier];
//    
//    GTLQueryZeppaclientapi * commentListQuery = [GTLQueryZeppaclientapi queryForListEventCommentWithIdToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
//    
//    [commentListQuery setFilter:filterStr];
//    [commentListQuery setOrdering:@"created desc"];
//    
//    [[self eventCommentService] executeQuery:commentListQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiCollectionResponseEventComment * response, NSError *error) {
//        
//        if (error) {
//            NSLog(@"Error while executing event comment List Query %@",error.description);
//            
//        }else if (response && response.items &&response.items.count > 0){
//            
//            eventCommentArray = [response.items mutableCopy];
//            
//            
//            for (GTLZeppaclientapiEventComment *eventComment in response.items) {
//                
//                
//                [eventCommentArray addObject:eventComment];
//                [self addDiscussionCellWithComment:eventComment];
//                
//            }
//            
//            
//        }
//        
//    }];
//    
    
}


-(void)executeInsertEventComment{
    
//    GTLZeppaclientapiEventComment * eventComment = [[GTLZeppaclientapiEventComment alloc]init];
//    
//    [eventComment setCommenterId:[NSNumber numberWithLongLong:[self getUserID]]];
//    [eventComment setText:_discussTextView.text];
//    [eventComment setEventId:_eventDetail.event.identifier];
//    
//    // Set the text color to indicate posting
//    _discussTextView.textColor = [UIColor grayColor];
//    
//    GTLQueryZeppaclientapi *inserComment = [GTLQueryZeppaclientapi queryForInsertEventCommentWithObject:eventComment idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
//    [[self eventCommentService] executeQuery:inserComment completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiEventComment * object, NSError *error) {
//
//        if (error) {
//            NSLog(@"Error inserting Comment %@",error.description);
//            [ZPAStaticHelper showAlertWithTitle:@"Error" andMessage:@"Error posting comment"];
//            _discussTextView.textColor = [UIColor blackColor];
//
//            // TODO: alert the user that there was an error posting the comment
//        }else if (object.identifier){
//            
//            [eventCommentArray addObject:object];
//            [self addDiscussionCellWithComment:object];
//            [_discussTextView setText:@""];
//            [self textViewDidChange:_discussTextView];
//            [_discussTextView resignFirstResponder];
//            [self textViewDidEndEditing:_discussTextView];
//        }
//        
//
//        
//    }];
    
    
}

-(void)executeUpdateEventRelationship:(GTLZeppaclientapiZeppaEventToUserRelationship *)eventRelationShip withUserId:(NSNumber *)userId{
    

    
//    GTLZeppaclientapiZeppaEventToUserRelationship * eventRelationship = [[GTLZeppaclientapiZeppaEventToUserRelationship alloc]init];
//    
////    eventRelationship = eventRelationShip;
//    
//    [eventRelationship setUserId:userId];
//    
//    [eventRelationship setInvitedByUserId:currentUser.endPointUser.identifier];
//    
//    [eventRelationship setIsRecommended:[NSNumber numberWithInt:1]];
//    
//    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
//    
//    
//    GTLQueryZeppaclientapi * updateRelationship = [GTLQueryZeppaclientapi queryForUpdateZeppaEventToUserRelationshipWithObject:eventRelationship idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
//    
//    [[self zeppaEventToUserRelationshipService] executeQuery:updateRelationship completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEventToUserRelationship * result , NSError *error) {
//        
//        if (error) {
//            NSLog(@"update event relationship unsuccessful %@",error.description);
//
//        }else if(result.identifier){
//            
//            NSLog(@"Update Successfull");
//            _eventDetail.relationship = result;
//            
//        }
//        
//        
//        
//    }];
    
}



-(void)executeInsertZeppaEventRelationshipWithUserId:(NSNumber *)userId{
    
//    GTLZeppaclientapiZeppaEventToUserRelationship * eventRelationship = [[GTLZeppaclientapiZeppaEventToUserRelationship alloc]init];
//    
//    [eventRelationship setEventId:_eventDetail.event.identifier];
//    [eventRelationship setUserId:userId];
//    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
//    [eventRelationship setInvitedByUserId:currentUser.endPointUser.identifier];
//    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
//    [eventRelationship setIsRecommended:[NSNumber numberWithInt:0]];
//    
//    GTLQueryZeppaclientapi *inserQuery = [GTLQueryZeppaclientapi queryForInsertZeppaEventToUserRelationshipWithObject:eventRelationship idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
//    
//    [[self zeppaEventToUserRelationshipService] executeQuery:inserQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEventToUserRelationship * result, NSError *error) {
//        
//        if (error) {
//            NSLog(@"error updating event relatioship %@",error.description);
//            
//            
//        }else if (result.identifier){
//            
//            NSLog(@"Update Successfull");
//            _eventDetail.relationship = result;
//
//        }
//        
//        
//    }];
    
    
    
}

-(void)removeZeppaEventWithIdentifier:(long long) identifier{
//    GTLQueryZeppaclientapi *removeZeppaEvent = [GTLQueryZeppaclientapi queryForRemoveZeppaEventWithIdentifier:identifier idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
//    [self.zeppaEventService executeQuery:removeZeppaEvent completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
//        //
//        if(error){
//            [ZPAStaticHelper showAlertWithTitle:@"Error" andMessage:@"Error removing event"];
//        } else {
//            
//            [[ZPAZeppaEventSingleton sharedObject]removeEventById:identifier];
//            
//            [progress hide:YES];
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//        }
//        
//    }];
}

- (void) notificationReceived: (NSNotification*) notification {
    
    if([notification.name isEqualToString:@"ZeppaNotification"]){
        GTLZeppaclientapiZeppaNotification *notif = notification.object;
        
        if(notif.eventId && [self.eventInfo.zeppaEvent.identifier isEqualToNumber: notif.eventId]){
        
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

-(GTLServiceZeppaclientapi *)service{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
}



@end
