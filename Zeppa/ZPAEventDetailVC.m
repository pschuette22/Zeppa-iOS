//
//  ZPAEventDetailVC.m
//  Zeppa
//
//  Created by Dheeraj on 12/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAEventDetailVC.h"
#import <MessageUI/MessageUI.h>

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

#import "GTLZeppaeventendpointZeppaEvent.h"
#import "GTLQueryZeppaeventendpoint.h"
#import "GTLServiceZeppaeventendpoint.h"

#import "GTLZeppaeventtouserrelationshipendpoint.h"
#import "GTLQueryZeppaeventtouserrelationshipendpoint.h"
#import "GTLServiceZeppaeventtouserrelationshipendpoint.h"

#import "ZPAAuthenticatonHandler.h"

#import "GTLZeppauserendpointZeppaUserInfo.h"

#import "GTLEventcommentendpoint.h"
#import "GTLEventcommentendpointCollectionResponseEventComment.h"
#import "GTLEventcommentendpointEventComment.h"

#import "GTLQueryEventcommentendpoint.h"
#import "GTLServiceEventcommentendpoint.h"


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

@interface ZPAEventDetailVC ()<MutualMinglerTagDelegate,addInvitesDelegate, MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
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
}

-(void)viewWillAppear:(BOOL)animated{
    
    addInvites = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAAddInvitesVC"];
   // _lbl_NoOfInvitedUser.text =[NSString stringWithFormat:@"%lu",(unsigned long)addInvites.invitesUserIdArray.count];
    
    
    _scollView_base.contentSize = CGSizeMake(0, _discussionPostBaseView.frame.origin.y+_discussionPostBaseView.frame.size.height+10);
    
    //[self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [_tagsArray removeAllObjects];
    [_tagsTempArray removeAllObjects];
    
    
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
    
   
    self.title = @"Event Detail";
    
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    
//    for (int i=0; i<temp.count; i++) {
//        [self updateDiscussionTableViewAndDisussionBaseViewFrame];
//    }
    
    [self.lbl_EventDuration setNumberOfLines:0];
    
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
    
    
    [self.discussionPostBaseView.layer setCornerRadius:3.0];
    [self.discussionPostBaseView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.discussionPostBaseView.layer setBorderWidth:1.0];
    [self.discussionPostBaseView.layer setMasksToBounds:YES];
    
    [self.eventDetailView.layer setBorderWidth:1.0];
    [self.eventDetailView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.eventDetailView.layer setCornerRadius:3.0];
    [self.eventDetailView.layer setMasksToBounds:YES];
    
    [self.postButton.layer setCornerRadius:3.0];
    [self.postButton.layer setMasksToBounds:YES];
}

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
    
    if ([segue.identifier isEqualToString:SEGUE_ID_JOINED_USER]) {
        
        ZPAMutualMinglerVC *minglerVC = [segue destinationViewController];
        minglerVC.isAttendingUser = YES;
        
        NSLog(@"%@",attendingUser);
        
        if ([attendingUser containsObject:currentUser.endPointUser.identifier]) {
            [attendingUser removeObject:currentUser.endPointUser.identifier];
        }
        
        minglerVC.attendingUserIdArr = attendingUser;
       // minglerVC.minglerUserInfo = _userProfileInfo;
    }
    if ([segue.identifier isEqualToString:SEGUE_ID_MAPLOCATION]) {
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



//****************************************************
#pragma mark - UITableViewDataSource Methods
//****************************************************
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//  _scollView_base.contentSize = CGSizeMake(320, _scrollViewHeight+(temp.count-1)*TABLEVIEW_ROW_HEIGHT);
//    return temp.count;
    return eventCommentArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==1) {
        
    }
    static NSString *discussionCellId = @"discussionCell";
    _discussionCell = [tableView dequeueReusableCellWithIdentifier:discussionCellId];
    [_discussionCell showEventCommentDetail:[eventCommentArray objectAtIndex:indexPath.row]];
    
    return _discussionCell;
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
#pragma mark - UIMessage Controller Delegate
//****************************************************
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    switch (result) {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            
            break;
        }
        case MessageComposeResultSent:
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//****************************************************
#pragma mark - Mail Controller Delegate
//****************************************************
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"mail cancelled");
            
            break;
        case MFMailComposeResultFailed:
            
            NSLog(@"Mail failed %@",[error localizedDescription]);
            
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail succcessfuly sent");
            
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

///@todo need to implement below methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
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
#pragma mark - Action Method
///*******************************************
- (IBAction)postButtonTapped:(UIButton *)sender
{
    
    
    [self executeInsertEventComment];
    
    [self doneButtonClicked];
    
    
   // _scollView_base.contentSize = CGSizeMake(320, _tableView_discussion.frame.origin.y+_tableView_discussion.frame.size.height+5);
    
     _whiteLabelInTextView.hidden = NO;
   // _discussTextView.text = @"";
   
   // _tableView_discussion.hidden = NO;
    
    _tableView_discussion.backgroundColor = [ZPAStaticHelper backgroundTextureColor];

}
//-(void)updateDiscussionTableViewAndDisussionBaseViewFrame{
//    CGRect frame = _tableView.frame;
//    frame.size.height += TABLEVIEW_ROW_HEIGHT;
//    _tableView.frame = frame;
//    
//    CGRect discussionBaseFrame = _discussionPostBaseView.frame;
//    discussionBaseFrame.origin.y += TABLEVIEW_ROW_HEIGHT;
//    _discussionPostBaseView.frame = discussionBaseFrame;
//}
- (IBAction)cancelBarButtonTapped:(UIBarButtonItem *)sender {
    
    progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [progress setLabelText:@"Removing Event..."];
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

- (IBAction)textBtnTapped:(UIButton *)sender {
    
    
    ZPADefaulZeppatUserInfo * eventMediatorInfo = [ZPADefaulZeppatUserInfo sharedObject];
    
    id eventHostMediator = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[_eventDetail.event.hostId longLongValue]];
    
    if ([eventHostMediator isKindOfClass:[ZPADefaulZeppatUserInfo class]]) {
        eventMediatorInfo = eventHostMediator;
    }else{
        
    }
    
    if (eventMediatorInfo.zeppaUserInfo.primaryUnformattedNumber) {
        [self showSmsWithRecepientsNumber:eventMediatorInfo.zeppaUserInfo.primaryUnformattedNumber];
    }else{
        [self sendEmailWithRecipientsMail:eventMediatorInfo.zeppaUserInfo.googleAccountEmail];
    }

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
    
    
}

-(IBAction)otherEventTagButtonAction:(UIButton *)sender{
    
    [self executeZeppaTagFollowApi:sender];
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
    
    
    
}
-(void)keyboardWillHide:(NSNotification *)notification
{

    [self.scollView_base setContentOffset:CGPointZero];
    
}

///*****************************************************
#pragma mark - TextView Delegate Method
///*****************************************************

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    _whiteLabelInTextView.hidden = (newLength == 0) ? NO : YES;
    
    //return (newLength > [ZPAStaticHelper getMaxCharacterInTextField]) ? NO : YES;
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
    return YES;
}
-(void)doneButtonClicked{
    
    [_currentTextView resignFirstResponder];
    //[self.tableView reloadData];
}

///*************************************************
#pragma mark - Tag Private Method ..
///*************************************************
-(void)showTagButtonWithTitleString:(NSString *)title andTag:(GTLEventtagendpointEventTag *)tag{
    
    if (![title isEqualToString:@""]) {
        title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
        UIButton *newButton =[[UIButton alloc]init];
        [newButton setTitle:title.capitalizedString forState:UIControlStateNormal];
        
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
            
            if (newView.frame.origin.x+newButton.frame.size.width>300) {
                newView.frame =CGRectMake(PADDING, newView.frame.origin.y+newView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
                [self updateAllViewsFramesUsingTagButtonBaseView:newView withCounter:0];
                
            }
            
        }else{
            [newView setFrame:CGRectMake(PADDING,PADDING,textSize.width+2*PADDING,textSize.height+2*PADDING)];
           // [self updateAllViewsFramesUsingTagButtonBaseView:newView withCounter:0];
        }
        
        //newButton.tag = DELETE_BUTTON_TAG;
        [newView addSubview:newButton];
        [_tagContainerView addSubview:newView];
        [_tagsTempArray addObject:newView];
        
        if (![_eventDetail.event.hostId isEqualToNumber:currentUser.endPointUser.identifier]) {
            
            [newButton addTarget:self action:@selector(otherEventTagButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
   // [self setCrossButton];
    
}
-(void)updateAllViewsFramesUsingTagButtonBaseView:(UIView *)baseView withCounter:(NSInteger)count{
    

    
    CGRect frame = _tagContainerView.frame;
    if (count>0) {
        frame.size.height = count * baseView.frame.size.height;
        frame.origin.y = _view_BaseUserDetail.frame.size.height;
    }else{
        //frame.size.height = 2.0;
        frame.size.height = _tagContainerView.frame.size.height + baseView.frame.size.height;
        frame.origin.y = _view_BaseUserDetail.frame.size.height;
    }
    _tagContainerView.frame = frame;
   
    
    _eventDetailView.frame = CGRectMake( _eventDetailView.frame.origin.x,  _tagContainerView.frame.origin.y +_tagContainerView.frame.size.height,  _eventDetailView.frame.size.width,  _eventDetailView.frame.size.height);
    
    _view_DiscussionLabel.frame = CGRectMake(_view_DiscussionLabel.frame.origin.x, _eventDetailView.frame.origin.y+_eventDetailView.frame.size.height, _view_DiscussionLabel.frame.size.width, _view_DiscussionLabel.frame.size.height);
    
    _discussionPostBaseView.frame = CGRectMake(_discussionPostBaseView.frame.origin.x, _view_DiscussionLabel.frame.origin.y+_view_DiscussionLabel.frame.size.height, _discussionPostBaseView.frame.size.width, _discussionPostBaseView.frame.size.height);
    
    _scollView_base.contentSize = CGSizeMake(0, _discussionPostBaseView.frame.origin.y+_discussionPostBaseView.frame.size.height+10);
}

///*************************************************
#pragma mark - Show Event Detail Private Method ..
///*************************************************

-(void)showEventDetails{
    
    if(_eventDetail){
        
//        NSInteger eventDescriptionHeight = _txtView_EventDescription.frame.size.height;
//        [_txtView_EventDescription sizeToFit];
//        NSInteger eventDescriptionHeightAfter = _txtView_EventDescription.frame.size.height;
//        
//        NSInteger heightExtended =eventDescriptionHeightAfter - eventDescriptionHeight;
//        
//        _qucikActionView.frame = CGRectMake(_qucikActionView.frame.origin.x, _qucikActionView.frame.origin.y+heightExtended, _qucikActionView.frame.size.width, _qucikActionView.frame.size.height);
        
        if ([_eventDetail.event.hostId isEqualToNumber: currentUser.endPointUser.identifier]) {
            
            _qucikActionView.hidden = YES;
            
            _view_BaseUserDetail.frame = CGRectMake(_view_BaseUserDetail.frame.origin.x, _view_BaseUserDetail.frame.origin.y,_view_BaseUserDetail.frame.size.width , _txtView_EventDescription.frame.size.height+_txtView_EventDescription.frame.origin.y);
            
            [self getTagsForCurrentUser];
            
        }else{
            
            _qucikActionView.hidden = NO;
            _cancelBarButton.enabled = NO;
            _cancelBarButton.tintColor = [UIColor clearColor];
            
            _view_BaseUserDetail.frame = CGRectMake(_view_BaseUserDetail.frame.origin.x, _view_BaseUserDetail.frame.origin.y,_view_BaseUserDetail.frame.size.width , _view_BaseUserDetail.frame.size.height);
            
            if (_isMinglerTag == YES) {
                [self getTagsForMinglersScreen];
            }else{
            
            [self getTagsOtherUserEvent];
            }
        }
        
        
        
        if ([_eventDetail.event.guestsMayInvite boolValue] == false) {
            _addInvitesView.hidden = YES;
            _addInvitesSeperatorView.hidden = YES;
            
            _eventDetailView.frame = CGRectMake(_eventDetailView.frame.origin.x, _eventDetailView.frame.origin.y, _eventDetailView.frame.size.width, _eventDetailView.frame.size.height - _addInvitesView.frame.size.height);
            
            [self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];
        }
    
        
        
        _lbl_EventTitle.text = _eventDetail.event.title;
        _lbl_EventDuration.text = [[ZPADateHelper sharedHelper]getEventTimeDuration:_eventDetail.event.start withEndTime:_eventDetail.event.end];
        _lbl_EventDisplayLocation.text = _eventDetail.event.displayLocation;
        
        id zeppaUser = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[_eventDetail.event.hostId longLongValue]];
        
        if ([zeppaUser isKindOfClass:[ZPADefaulZeppatUserInfo class]]) {
            
            _userInfo = zeppaUser;
            
            NSURL *profileImageURL = [NSURL URLWithString:_userInfo.zeppaUserInfo.imageUrl];
            [_userProfile_ImageView setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
            }];
            
            [_imageView_discussionUser setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType){
                
            }];
            
            NSString * userName = [NSString stringWithFormat:@"%@ %@",_userInfo.zeppaUserInfo.givenName,_userInfo.zeppaUserInfo.familyName];
            
            _lbl_discussionUserName.text = userName;
            _lbl_EventHostName.text = userName;
            
            [[ZPAZeppaEventSingleton sharedObject]setConflictIndicator:_imageView_ConflictIndicator withZeppaEvent:_eventDetail];
            
            [self setAttendingUserButtonText:_invitedUserBtn];
            
        }else{
            
            ZPAMyZeppaUser * user = zeppaUser;
            
            NSURL *profileImageURL = [NSURL URLWithString:user.endPointUser.userInfo.imageUrl];
            [_userProfile_ImageView setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
            }];
            
            [_imageView_discussionUser setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType){
                
            }];
            
            NSString *userName = [NSString stringWithFormat:@"%@ %@",user.endPointUser.userInfo.givenName,user.endPointUser.userInfo.familyName];
            
            _lbl_discussionUserName.text = userName;
            _lbl_EventHostName.text = userName;
            
            _imageView_ConflictIndicator.image = [UIImage imageNamed:@"small_circle_blue.png"];
            
            [self setAttendingUserButtonForOwnEvent:_invitedUserBtn];
        }
        
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
        
        
        
        _txtView_EventDescription.text = _eventDetail.event.descriptionProperty;
        
        
        
    }

    
}


-(void)getTagsOtherUserEvent{
    
    _defaultTagsForUser = [[ZPAFetchDefaultTagsForUser alloc]init];
    _defaultTagsForUser.delgate = self;
    [_defaultTagsForUser executeZeppaApiWithUserId:[self getUserID] andMinglerId:[_eventDetail.event.hostId longLongValue]];
}

-(void)getMutualMinglerTags{
    
   
    
    
    if (_eventDetail.getTagIds.count == 0 ) {
        
        _tagsArray = [[[ZPAZeppaEventTagSingleton sharedObject]getZeppaTagForUser:[_userInfo.zeppaUserInfo.key.parent.identifier longLongValue]]mutableCopy];
    }else{
        _tagsArray = [[[ZPAZeppaEventTagSingleton sharedObject]getTagsFromTagIdsArray:_eventDetail.getTagIds]mutableCopy];
    }
    
    _tagContainerView.hidden = (_tagsArray.count>0)?NO:YES;
    
    if (_tagContainerView.hidden == YES) {
        [self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];
    }
    
    
    for (GTLEventtagendpointEventTag *tag in _tagsArray) {
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
            [self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];
        }

    
    for (GTLEventtagendpointEventTag *tag in _tagsArray) {
        
        [self showTagButtonWithTitleString:tag.tagText andTag:tag];
        [self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];
        
    }

}

-(void)getTagsForMinglersScreen{
    
    _tagsArray =  [[[ZPAZeppaEventTagSingleton sharedObject]getTagsFromTagIdsArray:_eventDetail.event.tagIds]mutableCopy];
    
    _tagContainerView.hidden = (_tagsArray.count>0)?NO:YES;
    
    if (_tagContainerView.hidden == YES) {
        [self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];
    }
    
    
    for (GTLEventtagendpointEventTag *tag in _tagsArray) {
        
      [self showTagButtonWithTitleString:tag.tagText andTag:tag];
        
    }

}

//****************************************************
#pragma mark - Private methods
//****************************************************

-(void)showSmsWithRecepientsNumber:(NSString *)phoneNumber{
    
    
    if(![MFMessageComposeViewController canSendText]){
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    NSArray * reciepients =[NSArray arrayWithObject:phoneNumber];
    MFMessageComposeViewController * messageController = [[MFMessageComposeViewController alloc]init];
    
    messageController.messageComposeDelegate = self;
    [messageController setRecipients:reciepients];
    
    [self presentViewController:messageController animated:YES completion:nil];
}

-(void)sendEmailWithRecipientsMail:(NSString *)emailId{
    
    NSString * mailSubject = @"";
    NSString * mailBody = @"";
    NSArray * mailRecepients = [NSArray arrayWithObject:emailId];
    
    MFMailComposeViewController * mailController = [[MFMailComposeViewController alloc]init];
    
    mailController.mailComposeDelegate = self;
    
    [mailController setSubject:mailSubject];
    [mailController setMessageBody:mailBody isHTML:NO];
    [mailController setToRecipients:mailRecepients];
    
    [self presentViewController:mailController animated:YES completion:nil];
}


-(void)insertNewDiscussionCell{
    
   
    [_tableView_discussion beginUpdates];
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [_tableView_discussion insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [_tableView_discussion endUpdates];
    
}

-(void)setTableViewHeightAccordingToCells{
    
    CGFloat height = _tableView_discussion.rowHeight;
    height *= eventCommentArray.count;
    
    CGRect tableFrame = _tableView_discussion.frame;
    
    tableFrame.size.height = height;
    
    _tableView_discussion.frame = tableFrame;
    
    _discussionPostBaseView.frame = CGRectMake(_discussionPostBaseView.frame.origin.x, _discussionPostBaseView.frame.origin.y, _discussionPostBaseView.frame.size.width, _tableView_discussion.frame.origin.y+_tableView_discussion.frame.size.height);
    
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
                [sender setTitle:[NSString stringWithFormat:@"You mingle with %d / %d other people going",attendingMinglerArr.count,attendingSize] forState:UIControlStateNormal];
            }
        }else{
            
            if (attendingUser.count == 0 || (attendingUser.count ==1 && [attendingUser containsObject:currentUser.endPointUser.identifier])) {
                
                [sender setTitle:@"Be the first to join" forState:UIControlStateNormal];
            }else{
                NSInteger attendingSize = attendingUser.count;
                if ([attendingUser containsObject:currentUser.endPointUser.identifier]) {
                    attendingSize -=1;
                }
                [sender setTitle:[NSString stringWithFormat:@"You mingle with %d / %d other people going",attendingMinglerArr.count,attendingSize] forState:UIControlStateNormal];
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

-(void)insertOrUpdateEventRelationship:(GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *)zeppaEventRelationShip withUserId:(NSNumber *)userId{
    
    if (zeppaEventRelationShip) {
        [self executeUpdateEventRelationship:zeppaEventRelationShip withUserId:userId];
    }else{
        
        [self executeInsertZeppaEventRelationshipWithUserId:userId];
        
    }
    
}

-(void )executeZeppaTagFollowApi:(UIButton *)tagButton{
    
    
    GTLEventtagfollowendpointEventTagFollow * tagFollow = [[GTLEventtagfollowendpointEventTagFollow alloc]init];
    
    
    
    for (GTLEventtagendpointEventTag * tag in _tagsArray) {
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
    
    GTLQueryEventcommentendpoint * commentListQuery = [GTLQueryEventcommentendpoint queryForListEventComment];
    
    [commentListQuery setFilter:filterStr];
    [commentListQuery setOrdering:@"created desc"];
    
    [[self eventCommentService] executeQuery:commentListQuery completionHandler:^(GTLServiceTicket *ticket, GTLEventcommentendpointCollectionResponseEventComment * response, NSError *error) {
        
        if (error) {
            NSLog(@"Error while executing event comment List Query %@",error.description);
            
        }else if (response && response.items &&response.items.count > 0){
            
            eventCommentArray = [response.items mutableCopy];
            
            [_tableView_discussion reloadData];
            [self setTableViewHeightAccordingToCells];
            [self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];
            
#warning  to be done after
            
//            for (GTLEventcommentendpointEventComment *eventComment in response.items) {
//                
//                if ([[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[eventComment.commenterId longLongValue]] == nil) {
//                    ZPADefaulZeppatUserInfo * userInfo = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[eventComment.commenterId longLongValue ]];
//                    
//                     
//                }
//            }
            
        
            
            
            
            
//            while (iterator.hasNext()) {
//                EventComment comment = iterator.next();
//                
//                try {
//                    
//                    if (ZeppaUserSingleton.getInstance()
//                        .getAbstractUserMediatorById(
//                                                     comment.getCommenterId()) == null) {
//                            ZeppaUserInfo info = buildUserInfoEndpoint()
//                            .getZeppaUserInfo(
//                                              comment.getCommenterId()
//                                              .longValue()).execute();
//                            ZeppaUserSingleton
//                            .getInstance()
//                            .addDefaultZeppaUserMediator(info, null);
//                        }
//                    
//                    result.add(comment);
//                    
//
//            
//            
            
            
            
        }
        
    }];
    
    
}


-(void)executeInsertEventComment{
    
    GTLEventcommentendpointEventComment * eventComment = [[GTLEventcommentendpointEventComment alloc]init];
    
    [eventComment setCommenterId:[NSNumber numberWithLongLong:[self getUserID]]];
    [eventComment setText:_discussTextView.text];
    [eventComment setEventId:_eventDetail.event.identifier];
    
    GTLQueryEventcommentendpoint *inserComment = [GTLQueryEventcommentendpoint queryForInsertEventCommentWithObject:eventComment];
    [[self eventCommentService] executeQuery:inserComment completionHandler:^(GTLServiceTicket *ticket, GTLEventcommentendpointEventComment * object, NSError *error) {

        if (error) {
            NSLog(@"Error inserting Comment %@",error.description);
        }else if (object.identifier){
            
            [eventCommentArray insertObject:object atIndex:0];
           // [eventCommentArray addObject:object];
            
            //[self insertNewDiscussionCell];
            _discussTextView.text = @"";
            [_tableView_discussion reloadData];
            [self setTableViewHeightAccordingToCells];
            [self updateAllViewsFramesUsingTagButtonBaseView:nil withCounter:0];

        }
        
    }];
    
    
}

-(void)executeUpdateEventRelationship:(GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *)eventRelationShip withUserId:(NSNumber *)userId{
    

    
    GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship * eventRelationship = [[GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship alloc]init];
    
    eventRelationship =eventRelationShip;
    
    [eventRelationship setUserId:userId];
    
    [eventRelationship setInvitedByUserId:currentUser.endPointUser.identifier];
    
    [eventRelationship setIsRecommended:[NSNumber numberWithInt:1]];
    
    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
    
    
    GTLQueryZeppaeventtouserrelationshipendpoint * updateRelationship = [GTLQueryZeppaeventtouserrelationshipendpoint queryForUpdateZeppaEventToUserRelationshipWithObject:eventRelationship];
    
    [[self zeppaEventToUserRelationshipService] executeQuery:updateRelationship completionHandler:^(GTLServiceTicket *ticket, GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship * result , NSError *error) {
        
        if (error) {
            NSLog(@"update event relationship unsuccessful %@",error.description);
        }else if(result.identifier){
            
            NSLog(@"Update Successfull");
            _eventDetail.relationship = result;
            
        }
        
        
        
    }];
    
}



-(void)executeInsertZeppaEventRelationshipWithUserId:(NSNumber *)userId{
    
    GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship * eventRelationship = [[GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship alloc]init];
    
    [eventRelationship setEventId:_eventDetail.event.identifier];
    [eventRelationship setUserId:userId];
    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
    [eventRelationship setInvitedByUserId:currentUser.endPointUser.identifier];
    [eventRelationship setWasInvited:[NSNumber numberWithInt:1]];
    [eventRelationship setIsRecommended:[NSNumber numberWithInt:0]];
    
    GTLQueryZeppaeventtouserrelationshipendpoint *inserQuery = [GTLQueryZeppaeventtouserrelationshipendpoint queryForInsertZeppaEventToUserRelationshipWithObject:eventRelationship];
    
    [[self zeppaEventToUserRelationshipService] executeQuery:inserQuery completionHandler:^(GTLServiceTicket *ticket, GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship * result, NSError *error) {
        
        if (error) {
            NSLog(@"error updating event relatioship %@",error.description);
            
            
        }else if (result.identifier){
            
            NSLog(@"Update Successfull");
            _eventDetail.relationship = result;

        }
        
        
    }];
    
    
    
}

-(void)removeZeppaEventWithIdentifier:(long long) identifier{
    GTLQueryZeppaeventendpoint *removeZeppaEvent = [GTLQueryZeppaeventendpoint queryForRemoveZeppaEventWithIdentifier:identifier];
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

-(GTLServiceZeppaeventendpoint *)zeppaEventService{
    
    static GTLServiceZeppaeventendpoint *service = nil;
    if(!service){
        service = [[GTLServiceZeppaeventendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer: [ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}



-(GTLServiceZeppaeventtouserrelationshipendpoint *)zeppaEventToUserRelationshipService{
    
    static GTLServiceZeppaeventtouserrelationshipendpoint *service = nil;
    if(!service){
        service = [[GTLServiceZeppaeventtouserrelationshipendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
    
}


-(GTLServiceEventcommentendpoint *)eventCommentService{
    
    static GTLServiceEventcommentendpoint *service = nil;
    if (!service) {
        service = [[GTLServiceEventcommentendpoint alloc]init];
        service.retryEnabled = YES;
    }
    
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    
    return service;
}



@end
