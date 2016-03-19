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
#import "ZPADefaultZeppaEventInfo.h"
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

#define USER_PROFILE_CELL_HEIGHT 99
#define MINGELS_CELL_HEIGHT 36
#define USER_EVENT_CELL_HEIGHT 136

#define TABLE_ROW_INDEX_MINGLERS 0

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define PADDING 8
#define TAGS_BUTTON_TAG 100
#define HEIGHTEXTEND 33
#define WIDTHPADDING 5
#define TAGS_BASEVIEW_TAG_VALUE 100

@interface ZPAUserProfileVC ()<MutualMinglerTagDelegate>
//@property (nonatomic, strong) ZPAFetchMutualMingers *muturalMingler;
@property (nonatomic, strong) ZPAFetchDefaultTagsForUser *defaultTagsForUser;
//@property (nonatomic, strong) ZPAFetchEventsForMingler *eventForMingler;
//@property (nonatomic, strong)UINavigationController *eventDetailNavigation;
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
    
//    int counter;
    NSString *_mutualMinglerStr;
    
    NSMutableArray *_tempArray;
//    NSInteger _counter;
//    NSInteger _heightExtend;
    
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

    selectedTagBtn = [NSMutableArray array];
    
    [self showProgressHUD];
    
//    _eventDetailNavigation = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAEventDetailNavC"];
    
    [self callZeppaApi];
    
    //Replace with current user name.
    self.title = [NSString stringWithFormat:@"%@'s Profile",_userProfileInfo.userInfo.givenName];
    currentUser = [ZPAAppData sharedAppData].loggedInUser;
//    currentUser.tagsArray = [[NSMutableArray alloc]init];
//    currentUser.tagsArray = _userTagArray;
    
    _mutualMinglerStr = @"Loading Friends...";
    
    
    NSLog(@"%@",_userProfileInfo.userId);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (_progressHud.hidden == NO) {
            
            [self hideProressHUD];

        }
    });
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
        
    } else if([segue.destinationViewController.restorationIdentifier isEqualToString:@"ZPAEventDetailVC"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ZPAMyZeppaEvent *zeppaEvent = minglersEventArray[indexPath.row];
        ZPAEventDetailVC *eventDetailVC = (ZPAEventDetailVC*) segue.destinationViewController;
        eventDetailVC.eventDetail = zeppaEvent;
    }
    
    
       
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    
    if (![_mutualMinglerStr isEqualToString:@"No Mutual Friends"]  && ![_mutualMinglerStr isEqualToString:@"Fetching Friends..."]) {
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
//        CGRect frame = _userProfileCell.contentView.frame;
//        frame.size.height = USER_PROFILE_CELL_HEIGHT + (_counter * _heightExtend);
//        _userProfileCell.contentView.frame = frame;
        [_userProfileCell.commonMinglerButton setTitle:_mutualMinglerStr forState:UIControlStateNormal];
        
//        CGRect viewFrame = _userProfileCell.tagBaseView.frame;
//        viewFrame.size.height = _counter * _heightExtend+15;
//        _userProfileCell.tagBaseView.frame = viewFrame;
       
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
        
        // The height of this cell is equal to the info height dynamic height of the tag container
        return USER_PROFILE_CELL_HEIGHT + self.userProfileCell.tcHeightConstraint.constant;
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
    
//    if (indexPath.section == TABLE_SEC_INDEX_USEREVENT) {
//      
//    ZPAEventDetailVC *eventDetail= [[_eventDetailNavigation viewControllers] objectAtIndex:0];
//        
//    eventDetail.eventDetail= [minglersEventArray objectAtIndex:indexPath.row];
//    eventDetail.tagsArray = [minglerTagsArray mutableCopy];
//    eventDetail.userInfo = _userProfileInfo;
//    eventDetail.isMinglerTag = YES;
//        
//    [self presentViewController:_eventDetailNavigation animated:YES completion:NULL];
//    
//    
//    
//    }
    
}



///*************************************************
#pragma mark - UIAction Methods
///*************************************************
- (IBAction)unMingleBtnTapped:(id)sender {
    

    // TODO: delete user relationship
//    [self removeUserToUserRelationShip:_userProfileInfo];
    
    [[ZPAZeppaEventSingleton sharedObject]removeMediatorsForUser:[_userProfileInfo.userId longLongValue]];
    
    [[ZPAZeppaEventTagSingleton sharedObject]removeZeppaEventTagsUsingUserId:[_userProfileInfo.userId longLongValue]];
    
    
    [self performSegueWithIdentifier:@"unwindFromUserProfile" sender:self];
    
    
}
- (IBAction)commonMinglersBtnTapped:(UIButton *)sender {
    // TODO: show a list of people user and selected user have in common
    
}

//- (IBAction)textBtnTapped:(UIButton *)sender {
//    
//    NSIndexPath *indexPath = [self getIndexPathOfRowWithBtnClick:sender];
//    zeppaEvent = [minglersEventArray objectAtIndex:indexPath.row];
//    
//    ZPADefaulZeppatUserInfo * eventMediatorInfo = [ZPADefaulZeppatUserInfo sharedObject];
//    
//    id eventHostMediator = [[ZPAZeppaUserSingleton sharedObject]getZPAUserMediatorById:[zeppaEvent.event.hostId longLongValue]];
//    
//    if ([eventHostMediator isKindOfClass:[ZPADefaulZeppatUserInfo class]]) {
//        eventMediatorInfo = eventHostMediator;
//    }else{
//        
//    }
//    
////    if (eventMediatorInfo.zeppaUserInfo.primaryUnformattedNumber) {
////        [self showSmsWithRecepientsNumber:eventMediatorInfo.zeppaUserInfo.primaryUnformattedNumber];
////    }else{
////        [self sendEmailWithRecipientsMail:eventMediatorInfo.zeppaUserInfo.googleAccountEmail];
////    }
//
//    
//}



///**********************************************
#pragma mark - Zeppa Api Call
///**********************************************
-(void)callZeppaApi{
    
//    _muturalMingler = [[ZPAFetchMutualMingers alloc]init];
//    _muturalMingler.delegate = self;
//    [_muturalMingler executeZeppaMinglerApiWithZeppaUser:_userProfileInfo withUserIndetifier:[self getUserID]];
//    
//    
//    _defaultTagsForUser = [[ZPAFetchDefaultTagsForUser alloc]init];
//    _defaultTagsForUser.delgate = self;
//    [_defaultTagsForUser executeZeppaApiWithUserId:[self getUserID] andMinglerId:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
//    
//    _eventForMingler  =  [[ZPAFetchEventsForMingler alloc]init];
//    _eventForMingler.delegate = self;
////    [_eventForMingler executeZeppaApiWithMinglerId:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
//    [_eventForMingler executeZeppaApiWithMinglerId:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
    
}
-(long long)getUserID{
    
    return [[[ZPAZeppaUserSingleton sharedObject] getMyZeppaUserIdentifier] longLongValue];
}
-(void)getMutualMinglerList{
    
//    
//    if(_userProfileInfo.minglersIds.count==0){
//        
//        _mutualMinglerStr = @"No Mutual Friends";
//        
//    }else if (_userProfileInfo.minglersIds.count == 1){
//        
//        _mutualMinglerStr = [NSString stringWithFormat:@"1 Mutual Friend"];
//        
//    }else{
//        _mutualMinglerStr = [NSString stringWithFormat:@"%lu Mutual Friends",(unsigned long)_userProfileInfo.minglersIds.count];
//    }
//    [self.tableView reloadData];
}

-(void)getMutualMinglerTags{
    
//    minglerTagsArray = [NSArray array];
//    zeppaEvent = [[ZPAMyZeppaEvent alloc]init];
//   
//    if (zeppaEvent.getTagIds.count == 0 ) {
//        
//       minglerTagsArray = [[ZPAZeppaEventTagSingleton sharedObject]getZeppaTagForUser:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]];
//    }else{
//        minglerTagsArray = [[ZPAZeppaEventTagSingleton sharedObject]getTagsFromTagIdsArray:zeppaEvent.getTagIds];
//    }
//    
//    
////    _counter = (minglerTagsArray.count>0)?1:0;
//
//    
//    for (GTLZeppaclientapiEventTag *tag in minglerTagsArray) {
//        [self showTagButtonWithTitleString:tag];
//    }
//
//    
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

-(void)getMutualMinglerEventsList{
    
//      minglersEventArray = [NSArray array];
//    
//    minglersEventArray = [[ZPAZeppaEventSingleton sharedObject]getEventMediatorsForFriend:[_userProfileInfo.zeppaUserInfo.key.parent.identifier longLongValue]] ;
//    
//    NSLog(@"%zd",minglersEventArray.count);
//    
//    [self hideProressHUD];
//    
//    
//    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
//    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//    //[self.tableView reloadData];
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
        
        [newButton setTitle:title forState:UIControlStateNormal];
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
        
        
//        _heightExtend = textSize.height+2*PADDING;
        
        UIView *newView =[[UIView alloc]init];
        
        if (_tempArray.count!=0) {
            UIView *lastView =(UIView *)[_tempArray lastObject];
            [newView setFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width,lastView.frame.origin.y,textSize.width,textSize.height)];
            
            if (newView.frame.origin.x+newButton.frame.size.width>self.view.frame.size.width) {
                newView.frame =CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
//                _counter++;
                self.userProfileCell.tcHeightConstraint.constant+= newView.frame.size.height;
            }
            
        }else{
            [newView setFrame:CGRectMake(0,0,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            self.userProfileCell.tcHeightConstraint.constant = newView.frame.size.height;
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
    
    self.userProfileCell.tcHeightConstraint.constant = 0;
    for (int j=0; j<_tempArray.count; j++) {
        UIView *view =[_tempArray objectAtIndex:j];
        UIButton *button = (UIButton *)[view viewWithTag:TAGS_BUTTON_TAG];
        CGRect frame = button.frame;
        
        if (j==0) {
            view.frame=CGRectMake(view.frame.origin.x, view.frame.origin.y, frame.size.width+PADDING, frame.size.height+PADDING);
            self.userProfileCell.tcHeightConstraint.constant = view.frame.size.height;
        }
        else{
            UIView *preView =[_tempArray objectAtIndex:j-1];
            view.frame=CGRectMake(preView.frame.origin.x+preView.frame.size.width, preView.frame.origin.y, frame.size.width+PADDING, frame.size.height+PADDING);
            if (view.frame.origin.x+view.frame.size.width>self.view.frame.size.width) {
                view.frame=CGRectMake(0, view.frame.origin.y+view.frame.size.height, view.frame.size.width, view.frame.size.height);
                self.userProfileCell.tcHeightConstraint.constant += view.frame.size.height;
            }
        }
        [_userProfileCell.tagBaseView addSubview:view];
    }
    
    // Set the frame size
    CGRect frame = self.userProfileCell.tagBaseView.frame;
    self.userProfileCell.tagBaseView.frame = CGRectMake(0, 0, frame.size.width, self.userProfileCell.tcHeightConstraint.constant);
//    [UIView animateWithDuration:0 animations:^{
//        [self.view layoutIfNeeded];
//    }];
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
////****************************************************
//#pragma mark - Private methods
////****************************************************


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
