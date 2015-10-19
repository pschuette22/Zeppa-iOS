//
//  ZPAUserProfileVC.m
//  Zeppa
//
//  Created by Dheeraj on 10/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAUserProfileVC.h"

#import <MessageUI/MessageUI.h>

#import "ZPAZeppaEventTagSingleton.h"
#import "ZPADefaulZeppatEventInfo.h"
#import "ZPADefaultZeppaEventTagInfo.h"
#import "ZPAFetchMutualMingers.h"
#import "ZPAFetchEventsForMingler.h"
#import "ZPAFetchDefaultTagsForUser.h"
#import "ZPAEventDetailVC.h"
#import "ZPAMutualMinglerVC.h"
#import "MBProgressHUD.h"

#import "GTLZeppaclientapiEventTagFollow.h"


#define TAGS_BASEVIEW_TAGVALUE 100

#define TOTAL_SECTIONS 2

#define TABLE_SEC_INDEX_USERPROFILE 0
#define TABLE_SEC_INDEX_USEREVENT 1

#define HEADER_HEIGHT 32.0f

#define USER_PROFILE_CELL_HEIGHT 210
#define MINGELS_CELL_HEIGHT 36
#define USER_EVENT_CELL_HEIGHT 135

#define TABLE_ROW_INDEX_MINGLERS 0

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define PADDING 8
#define TAGS_BUTTON_TAG 100
#define HEIGHTEXTEND 33
#define WIDTHPADDING 5
#define TAGS_BASEVIEW_TAG_VALUE 100

@interface ZPAUserProfileVC ()<MutualMinglerDelegate,MutualMinglerTagDelegate,MutualMinglerEventDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) ZPAFetchMutualMingers *muturalMingler;
@property (nonatomic, strong) ZPAFetchDefaultTagsForUser *defaultTagsForUser;
@property (nonatomic, strong) ZPAFetchEventsForMingler *eventForMingler;
@property (nonatomic, strong)UINavigationController *eventDetailNavigation;
@property (nonatomic, strong) MBProgressHUD *progressHud;


@end
NSArray *minglersEventArray;
NSArray *minglerTagsArray;
@implementation ZPAUserProfileVC
{
    
    NSMutableArray *tempArray;
    NSMutableArray *selectedTagBtn;
    
    ZPAMyZeppaUser *currentUser;
    ZPAMyZeppaEvent *zeppaEvent;
    ZPADefaultZeppaEventTagInfo *tagInfo;
    
    int counter;
    NSString *_mutualMinglerStr;
    
    NSMutableArray *_tempArray;
    NSInteger _counter;
    NSInteger _heightExtend;
    
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

    tagInfo = [[ZPADefaultZeppaEventTagInfo alloc]init];
    selectedTagBtn = [NSMutableArray array];
    
    [self showProgressHUD];
    
    _eventDetailNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
    
    [self callZeppaApi];
    
    //Replace with current user name.
    self.title = [NSString stringWithFormat:@"%@'s Profile",_userProfileInfo.zeppaUserInfo.givenName];
    currentUser = [ZPAAppData sharedAppData].loggedInUser;
    currentUser.tagsArray = [[NSMutableArray alloc]init];
    currentUser.tagsArray = _userTagArray;
    
    _mutualMinglerStr = @"Loading Minglers...";
    
    
    NSLog(@"%@",_userProfileInfo.userId);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_progressHud.hidden == NO) {
            
            [self hideProressHUD];

        }
    });
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    _tempArray  = [NSMutableArray array];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
   
   if ([segue.identifier isEqualToString: @"mutualMinglers"]) {
        
        ZPAMutualMinglerVC *minglerVC = [segue destinationViewController];
        
        minglerVC.minglerUserInfo = _userProfileInfo;
    }else if ([segue.identifier  isEqualToString:@"unwindFromUserProfile"]){
        
    }
        
    
    
       
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    
    if (![_mutualMinglerStr isEqualToString:@"No Mutual Minglers"]  && ![_mutualMinglerStr isEqualToString:@"Loading Minglers..."]) {
        return YES;
    }
    return NO;
}

///****************************************************
#pragma mark - TableView DataSource
///****************************************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return TOTAL_SECTIONS;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section==TABLE_SEC_INDEX_USERPROFILE) {
        return 1;
    }else if (section == TABLE_SEC_INDEX_USEREVENT){
        return minglersEventArray.count;
    }else{
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == TABLE_SEC_INDEX_USERPROFILE) {
        static NSString *userProfileCellId = @"userProfileCell";
        _userProfileCell = [tableView dequeueReusableCellWithIdentifier:userProfileCellId];
        _userProfileCell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
         [_userProfileCell showZeppaMinglersInfoOnCell:_userProfileInfo];
        
        ///This is For Tag Framing
        CGRect frame = _userProfileCell.contentView.frame;
        frame.size.height = USER_PROFILE_CELL_HEIGHT + (_counter * _heightExtend);
        _userProfileCell.contentView.frame = frame;
        [_userProfileCell.commonMinglerButton setTitle:_mutualMinglerStr forState:UIControlStateNormal];
        
        CGRect viewFrame = _userProfileCell.tagBaseView.frame;
        viewFrame.size.height = _counter * _heightExtend+15;
        _userProfileCell.tagBaseView.frame = viewFrame;
       
        [self arrangeButtonWhenCallCellForRowAtIndex];
        
        
        return _userProfileCell;
    }
       if (indexPath.section == TABLE_SEC_INDEX_USEREVENT) {
        static NSString *userEventCellId = @"userEventCell";
        _minglerEventCell = [tableView dequeueReusableCellWithIdentifier:userEventCellId];
        _minglerEventCell.selectionStyle  = UITableViewCellSelectionStyleNone;
        if (minglersEventArray.count>0) {
            [_minglerEventCell showEventDetailOnCell:_userProfileInfo withZeppaEvents:[minglersEventArray objectAtIndex:indexPath.row]];
        }
        
        return _minglerEventCell;
    }
    return nil;
}
//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

///@todo need to implement below methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexSex = indexPath.section;
    // NSInteger indexRow = indexPath.row;
    
    if (indexSex == TABLE_SEC_INDEX_USERPROFILE) {
        
       
        return USER_PROFILE_CELL_HEIGHT + ((_counter-1) * _heightExtend);
        //return 350;
        
    }
    if (indexSex == TABLE_SEC_INDEX_USEREVENT) {
        return USER_EVENT_CELL_HEIGHT;
    }
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (section == TABLE_SEC_INDEX_USERPROFILE) {
//        return 0;
//    }
    
    return 0;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ///Create My Planned Events Header View
//    CGRect headerViewFrame = tableView.bounds;
//    headerViewFrame.origin = (CGPoint){0,0};
//    headerViewFrame.size.height = HEADER_HEIGHT;
//    UIView *headerView = [[UIView alloc]initWithFrame:headerViewFrame];
//    headerView.backgroundColor = [ZPAStaticHelper backgroundColorForSectionHeader];
//    
//    UILabel *lblMyPlannedEvents = [[UILabel alloc]initWithFrame:headerViewFrame];
//    lblMyPlannedEvents.textAlignment = NSTextAlignmentCenter;
//    lblMyPlannedEvents.text = NSLocalizedString(@"My Planned Events:", nil);
//    lblMyPlannedEvents.textColor = [ZPAStaticHelper titleColorForHeaders];
//    
//    lblMyPlannedEvents.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:lblMyPlannedEvents];
//    
//    if (section == TABLE_SEC_INDEX_USEREVENT) {
//        lblMyPlannedEvents.text = [NSString stringWithFormat:@"%@'s Event",_userProfileInfo.zeppaUserInfo.givenName];
//    }
//    return headerView;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == TABLE_SEC_INDEX_USEREVENT) {
      
    ZPAEventDetailVC *eventDetail= [[_eventDetailNavigation viewControllers] objectAtIndex:0];
        
    eventDetail.eventDetail= [minglersEventArray objectAtIndex:indexPath.row];
    eventDetail.tagsArray = [minglerTagsArray mutableCopy];
    eventDetail.userInfo = _userProfileInfo;
    eventDetail.isMinglerTag = YES;
        
    [self presentViewController:_eventDetailNavigation animated:YES completion:NULL];
    
    
    
    }
    
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


///*************************************************
#pragma mark - UIAction Methods
///*************************************************
- (IBAction)unMingleBtnTapped:(id)sender {
    
    
    
    
    [self removeUserToUserRelationShip:_userProfileInfo];
    
    [[ZPAZeppaEventSingleton sharedObject]removeMediatorsForUser:[_userProfileInfo.userId longLongValue]];
    
    [[ZPAZeppaEventTagSingleton sharedObject]removeZeppaEventTagsUsingUserId:[_userProfileInfo.userId longLongValue]];
    
    
    [self performSegueWithIdentifier:@"unwindFromUserProfile" sender:self];
    
    
}
- (IBAction)commonMinglersBtnTapped:(UIButton *)sender {
    
    
}

- (IBAction)watchBtnTapped:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
    zeppaEvent = [minglersEventArray objectAtIndex:indexPath.row];
    
    if (![[ZPADefaulZeppatEventInfo sharedObject]isWatching] == true) {
        [sender setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [sender setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
    }
    [[ZPADefaulZeppatEventInfo sharedObject]onWatchButtonClicked:zeppaEvent.relationship];
    
    [_tableView reloadData];
    

    
}

- (IBAction)textBtnTapped:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
    zeppaEvent = [minglersEventArray objectAtIndex:indexPath.row];
    
    ZPADefaulZeppatUserInfo * eventMediatorInfo = [ZPADefaulZeppatUserInfo sharedObject];
    
    id eventHostMediator = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[zeppaEvent.event.hostId longLongValue]];
    
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

- (IBAction)joinBtnTapped:(UIButton *)sender {
    
    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
    zeppaEvent = [minglersEventArray objectAtIndex:indexPath.row];
    
    zeppaEvent.isAgenda = YES;
    
    if (![[ZPADefaulZeppatEventInfo sharedObject]isAttending ] == true) {
        [sender setImage:[UIImage imageNamed:@"ic_join_filled.png"] forState:UIControlStateNormal];
        [_minglerEventCell.btn_watch setImage:[UIImage imageNamed:@"ic_watch_filled.png"] forState:UIControlStateNormal];
    }
    else{
        [_minglerEventCell.btn_watch setImage:[UIImage imageNamed:@"ic_watch_empty.png"] forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"ic_join_empty.png"] forState:UIControlStateNormal];
    }
    
    [[ZPADefaulZeppatEventInfo sharedObject]onJoinButtonClicked:zeppaEvent.relationship];
    
    [_tableView reloadData];

    
}


///**********************************************
#pragma mark - Zeppa Api Call
///**********************************************
-(void)callZeppaApi{
    
    _muturalMingler = [[ZPAFetchMutualMingers alloc]init];
    _muturalMingler.delegate = self;
    [_muturalMingler executeZeppaMinglerApiWithZeppaUser:_userProfileInfo withUserIndetifier:[self getUserID]];
    
    
    _defaultTagsForUser = [[ZPAFetchDefaultTagsForUser alloc]init];
    _defaultTagsForUser.delgate = self;
    [_defaultTagsForUser executeZeppaApiWithUserId:[self getUserID] andMinglerId:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
    
    _eventForMingler  =  [[ZPAFetchEventsForMingler alloc]init];
    _eventForMingler.delegate = self;
//    [_eventForMingler executeZeppaApiWithMinglerId:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
    [_eventForMingler executeZeppaApiWithMinglerId:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
    
}
-(long long)getUserID{
    
    return [[[ZPAZeppaUserSingleton sharedObject] userId] longLongValue];
}
-(void)getMutualMinglerList{
    
    
    if(_userProfileInfo.minglersIds.count==0){
        
        _mutualMinglerStr = @"No Mutual Minglers";
        
    }else if (_userProfileInfo.minglersIds.count == 1){
        
       ZPADefaulZeppatUserInfo *user = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[[_userProfileInfo.minglersIds objectAtIndex:0] longLongValue]];
        _mutualMinglerStr = [NSString stringWithFormat:@"You both mingle with %@ %@",user.zeppaUserInfo.givenName,user.zeppaUserInfo.familyName];
        
    }else{
        _mutualMinglerStr = [NSString stringWithFormat:@"%lu Mutual Minglers",(unsigned long)_userProfileInfo.minglersIds.count];
    }
    [self.tableView reloadData];
}

-(void)getMutualMinglerTags{
    
    minglerTagsArray = [NSArray array];
    zeppaEvent = [[ZPAMyZeppaEvent alloc]init];
   
    if (zeppaEvent.getTagIds.count == 0 ) {
        
       minglerTagsArray = [[ZPAZeppaEventTagSingleton sharedObject]getZeppaTagForUser:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
    }else{
        minglerTagsArray = [[ZPAZeppaEventTagSingleton sharedObject]getTagsFromTagIdsArray:zeppaEvent.getTagIds];
    }
    
    
    _counter = (minglerTagsArray.count>0)?1:0;

    
    for (GTLZeppaclientapiEventTag *tag in minglerTagsArray) {
        [self showTagButtonWithTitleString:tag];
    }

    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

-(void)getMutualMinglerEventsList{
    
      minglersEventArray = [NSArray array];
    
    minglersEventArray = [[ZPAZeppaEventSingleton sharedObject]getEventMediatorsForFriend:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]] ;
    
    NSLog(@"%zd",minglersEventArray.count);
    
    [self hideProressHUD];
    
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadData];
}
///*************************************************
#pragma mark - Tag Private Method
///*************************************************


-(void)showTagButtonWithTitleString:(GTLZeppaclientapiEventTag *)tag{
    
    
    NSString *title =tag.tagText;
    NSLog(@"tagId %@",tag.identifier);
    
    if (![title isEqualToString:@""]) {
        title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        UIButton *newButton =[[UIButton alloc]init];
        
        [newButton setTitle:title.capitalizedString forState:UIControlStateNormal];
        [newButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        
        if ([_defaultTagsForUser isFollowing:tag]) {
           [newButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
            [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       }else{
             [newButton setBackgroundColor:[UIColor whiteColor]];
             [newButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
      }
        
       //[newButton setBackgroundColor:[UIColor colorWithRed:37/255.0f green:161/255.0f blue:225/255.0f alpha:1.0f]];
       
        
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
        
        
        _heightExtend = textSize.height+2*PADDING;
        
        UIView *newView =[[UIView alloc]init];
        
        if (_tempArray.count!=0) {
            UIView *lastView =(UIView *)[_tempArray lastObject];
            [newView setFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width,lastView.frame.origin.y,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            
            if (newView.frame.origin.x+newButton.frame.size.width>300) {
                newView.frame =CGRectMake(PADDING, newView.frame.origin.y+newView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
                _counter++;
                [self resizeTagviewAndTableCell];
            }
            
        }else{
            [newView setFrame:CGRectMake(PADDING,PADDING,textSize.width+2*PADDING,textSize.height+2*PADDING)];
        }
        [newView addSubview:newButton];
        [_userProfileCell.tagBaseView addSubview:newView];
        [_tempArray addObject:newView];
        
        [newButton addTarget:self action:@selector(newButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
}

-(void)didFinishUpdatingUser:(ZPAMyZeppaUser *)user{
    
    
    [ZPAAppData sharedAppData].loggedInUser = user;
    currentUser = [ZPAAppData sharedAppData].loggedInUser;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}
//-(void)updateProfileTags:(NSNotification *)notify{
//    [[_userProfileCell.tagBaseView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
//    
//    [_tempArray removeAllObjects];
//   // [minglerTagsArray removeAllObjects];
//    
//    [_tableView reloadData];
//    // [_basicInfoCell.viewForBaselineLayout addSubview:_basicInfoCell.view_TagContainer];
//}

-(void)resizeTagviewAndTableCell{
    
    
    NSIndexPath *indexpath =[NSIndexPath indexPathForRow:0 inSection:0 ];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
-(void)arrangeButtonWhenCallCellForRowAtIndex{
    for (UIView *view in _userProfileCell.contentView.subviews) {
        if (view.tag==TAGS_BASEVIEW_TAGVALUE) {
            [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
    
    for (int j=0; j<_tempArray.count; j++) {
        UIView *view =[_tempArray objectAtIndex:j];
        UIButton *button = (UIButton *)[view viewWithTag:TAGS_BUTTON_TAG];
        CGRect frame = button.frame;
        
        if (j==0) {
            view.frame=CGRectMake(PADDING, PADDING, frame.size.width+PADDING, frame.size.height+PADDING);
        }
        else{
            UIView *preView =[_tempArray objectAtIndex:j-1];
            view.frame=CGRectMake(preView.frame.origin.x+preView.frame.size.width, preView.frame.origin.y, frame.size.width+PADDING, frame.size.height+PADDING);
            if (view.frame.origin.x+view.frame.size.width>300) {
                view.frame=CGRectMake(PADDING, view.frame.origin.y+view.frame.size.height, view.frame.size.width, view.frame.size.height);
            }
        }
        [_userProfileCell.tagBaseView addSubview:view];
    }
    
}

-(IBAction)newButtonAction:(UIButton *)sender{
    
    [self executeZeppaTagFollowApi:sender];
    
    
//    if (selectedTagBtn.count >= 6) {
//        
//        UIButton *firstButton = [selectedTagBtn firstObject];
//        [firstButton setBackgroundColor:[UIColor whiteColor]];
//        [firstButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
//        [selectedTagBtn removeObject:firstButton];
//       // [_eventTagIdsArray removeObject:[_eventTagIdsArray firstObject]];
//        
//    }
////    [sender setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
////    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
////   // [_eventTagIdsArray addObject:tag.identifier];
//    [selectedTagBtn addObject:sender];
//    


//       if ([ isFollowing] == NO) {
//
//        [tagInfo insertZeppaTagFollow:[self executeZeppaTagFollowApi:sender]];
//        [sender setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
//    }else{
//        [sender setBackgroundColor:[UIColor whiteColor]];
//    }
    
//    
//    if(sender.backgroundColor == [UIColor whiteColor]){
//        [sender setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
//    }else{
//        [sender setBackgroundColor:[UIColor whiteColor]];
//        
//    }
}
-(void )executeZeppaTagFollowApi:(UIButton *)tagButton{
    
    
    GTLZeppaclientapiEventTagFollow * tagFollow = [[GTLZeppaclientapiEventTagFollow alloc]init];
    
    
    
    for (GTLZeppaclientapiEventTag * tag in minglerTagsArray) {
        if ([tag.tagText.uppercaseString isEqualToString:tagButton.titleLabel.text.uppercaseString]) {
            
            if ([_defaultTagsForUser isFollowing:tag ] == NO ){
                
            [tagButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
            [tagButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
            tagFollow.tagOwnerId = _userProfileInfo.userId;
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

-(void)removeUserToUserRelationShip:(ZPADefaulZeppatUserInfo *)userInfo{
    
    
    GTLQueryZeppaclientapi *updateU2URelationshipTask = [GTLQueryZeppaclientapi queryForRemoveZeppaUserToUserRelationshipWithRelationshipId:[userInfo.relationship.identifier longLongValue] idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaUserToUserRelationship executeQuery:updateU2URelationshipTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUserToUserRelationship  *response, NSError *error) {
        //
        
        if(error){
            
        } else if ( response.identifier){
            
            //            [resultView setText:[NSString stringWithFormat:@"ZeppaUserToUserRelationship: {\n   identifier: %@\n   created: %@\n   updated: %@\n   creatorId: %@\n   subjectId: %@\n   relationshipType: %@\n   }", response.identifier, response.created, response.updated, response.creatorId, response.subjectId, response.relationshipType]];
            
            [self performSegueWithIdentifier:@"unwindFromUserProfile" sender:self];
            

            //
            
        } else {
            //            [resultView setText:@"Error Inserting ZeppaUserToUserRelationship"];
        }
        
    }];
    
    
}


-(GTLServiceZeppaclientapi *)zeppaUserToUserRelationship{
    
    static GTLServiceZeppaclientapi *service = nil;
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    return service;
    
}

-(NSIndexPath *)getIndexPathOfRowWithBtnClick:(UIButton *)sender{
    CGPoint center= sender.center;
    CGPoint rootViewPoint = [sender.superview convertPoint:center toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:rootViewPoint];
    NSLog(@"%@",indexPath);
    
    return indexPath;
    
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


-(void)showProgressHUD{
    
    _progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _progressHud.labelText = @"Loading User Details.....";
    
 // To disable touch event in a view and show HUD
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [_progressHud show:YES];
    
}

-(void)hideProressHUD{
    
    
    //To enable touch event in a view and hide HUD
    
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    
}

@end
