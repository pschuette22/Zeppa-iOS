//
//  ZPAMyProfileVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAMyProfileVC.h"
#import "ZPACreateOrEditAccountVC.h"
#import "ZPAMyBasicInfoCell.h"
#import "ZPAMyPlannedEventCell.h"
#import "ZPAZeppaEventSingleton.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"
#import "UIImageView+WebCache.h"
#import "ZPALoginVC.h"
#import "ZPAAppDelegate.h"
#import "ZPAZeppaEventTagSingleton.h"

#import "ZPAAuthenticatonHandler.h"
#import "ZPAEventDetailVC.h"


//Tags Properties
#define TAGS_BASEVIEW_TAGVALUE 100

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define PADDING 8
#define TAGS_BUTTON_TAG 100
#define WIDTHPADDING 5

#define TABLE_SEC_INDEX_MY_BASIC_INFO       0
#define TABLE_SEC_INDEX_MY_PLANNED_EVENTS   1

#define TOTAL_SECTIONS  2

#define HEADER_HEIGHT   32.0f

//#define MY_BASIC_INFO_CELL_HEIGHT 200
#define BASIC_INFO_BASE_HEIGHT 105
#define ADD_TAG_BASE_HEIGHT 39
#define MY_PLANNED_EVENTS_INFO_CELL_HEIGHT 100

#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)




@interface ZPAMyProfileVC ()<ZPACreateOrEditAccountVCDelegate>
@property(nonatomic,strong) ZPAMyBasicInfoCell *basicInfoCell;
@property(nonatomic,strong) ZPAMyZeppaUser *currentUser;
@property(nonatomic,strong) NSArray *arrMyPlannedEvents;
@end

@implementation ZPAMyProfileVC{
    
    NSMutableArray *_tempArray;
    NSInteger _counter;
    NSMutableArray *tagArray;
}
//****************************************************
#pragma mark - View Life Cycle
//****************************************************
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
    [self configure];
    
    tagArray = [NSMutableArray array];
    [_tableView clipsToBounds];
//    if(_currentUser.tagsArray.count==0){
//        [self resizeTagviewAndTableCell];
//    }

    
    ///_counter for increase RowHeight each time
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
//    {
//        if (![[UIScreen mainScreen] bounds].size.height == 480)
//        {
//            
//            if(_currentUser.tagsArray.count==0){
//                [self updateProfileTags:nil];
//            }
//
//        }
//        else
//        {
//            //iphone 3.5 inch screen iphone 3g,4s
//        }
//    }
    
    
   [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateProfileTags:) name:kZeppaTagUpdateNotificationKey object:nil];
//    [_basicInfoCell.viewForBaselineLayout addSubview:_basicInfoCell.view_tagContainer];
    
    _tempArray  = [NSMutableArray array];
    _arrMyPlannedEvents = [[[ZPAZeppaEventSingleton sharedObject] getHostedEventMediators] mutableCopy];
    _currentUser = [ZPAAppData sharedAppData].loggedInUser;
    
    
//    for (GTLZeppaclientapiEventTag *tag in _currentUser.tagsArray) {
//        [self showTagButtonWithTitleString:tag.tagText];
//    }
    
    [_tableView reloadData];
    
}
-(void)dealloc{
    
    [self unregisterFromNotifications];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Get ready to show event details
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Get ready to show event details
    // check to make sure this is headed to an Event Detail View Controller
    if([segue.destinationViewController.restorationIdentifier isEqualToString:@"ZPAEventDetailVC"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ZPAMyZeppaEvent *zeppaEvent = _arrMyPlannedEvents[indexPath.row];
        ZPAEventDetailVC *eventDetailVC = (ZPAEventDetailVC*) segue.destinationViewController;
        eventDetailVC.eventDetail = zeppaEvent;
    }
    
}


///**********************************************
#pragma mark - Configure
///**********************************************
-(void)configure{
    
    
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"My Profile", nil);
    ///Set background color of UIView
    [self.view setBackgroundColor:[ZPAStaticHelper backgroundTextureColor]];
    
    [self registerForNotifications];
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


- (void)keyboardWillShow:(NSNotification*)note {
    
    
    NSDictionary* info = [note userInfo];
    CGSize _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float kbHeight = _kbSize.width > _kbSize.height ? _kbSize.height : _kbSize.width;
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.frame.size.height+kbHeight);
    
    
}
-(void)keyboardWillHide:(NSNotification *)note
{
    NSDictionary* info = [note userInfo];
    CGSize _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float kbHeight = _kbSize.width > _kbSize.height ? _kbSize.height : _kbSize.width;

//    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height);
    
    self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.frame.size.height-kbHeight);
    self.tableView.contentOffset=CGPointZero;
    
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

//****************************************************
#pragma mark - UITableViewDataSource Methods
//****************************************************

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TOTAL_SECTIONS;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TABLE_SEC_INDEX_MY_BASIC_INFO) {
        return 1;
    }
    return _arrMyPlannedEvents.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger indexSec = indexPath.section;
    if (indexSec == TABLE_SEC_INDEX_MY_BASIC_INFO) {
        NSLog(@"Cell for row at index path");
        ///Show User's basic profile details
        _basicInfoCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAMyBasicInfoCell"];
        ///Get Saved Current User Object
        ///Set profile image
        if (_currentUser.image) {
            _basicInfoCell.imageView_MyProfile.image = _currentUser.image;
        }
        else{
            
            NSURL *profileImageURL = [NSURL URLWithString:_currentUser.endPointUser.userInfo.imageUrl];
            [_basicInfoCell.imageView_MyProfile setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                
                ///Write any image related code here
                
            }];
        }
                ///Set user name
        
        _basicInfoCell.lblUserName.text = [NSString stringWithFormat:@"%@ %@",_currentUser.endPointUser.userInfo.givenName,_currentUser
                                           .endPointUser.userInfo.familyName];
        
        ///Set Contact Number
        NSString *contactNumber = [self getFormattedNumber:_currentUser.endPointUser.phoneNumber];
        
        if ([ZPAStaticHelper canUseWebObject:contactNumber]
            && contactNumber.length > 0) {
            ///Set the Contact Number if present and unhide it
            [_basicInfoCell.btnContactNumber setTitle:contactNumber forState:UIControlStateNormal];
            [_basicInfoCell.btnContactNumber setHidden:NO];
        }
        else{
            ///Hide the contact number button if not present and reset frames if required
            [_basicInfoCell.btnContactNumber setHidden:YES];
            
        }
        [_basicInfoCell.btnEmail setTitle:_currentUser.endPointUser.authEmail forState:UIControlStateNormal];
        ///Adjust frame for Add new tag controls
        
//        CGRect frame = _basicInfoCell.contentView.frame;
//        frame.size.height = MY_BASIC_INFO_CELL_HEIGHT + self.tagContainerHeight.constant;
//        _basicInfoCell.contentView.frame = frame;
//        
//        
//        CGRect viewFrame = _basicInfoCell.view_tagContainer.frame;
//        viewFrame.size.height = self.tagContainerHeight.constant;
//        _basicInfoCell.view_tagContainer.frame = viewFrame;
        // Reset the tag container height
        [self  arrangeButtonWhenCallCellForRowAtIndex];
        
        // Set the size of the tag container
        [self resizeTagContainer];
        
//        CGFloat y_origin = BASIC_INFO_BASE_HEIGHT + _tagContainerHeight; // 3 for the padding at the end
//        // Make the new rect for the add tag view
//        _basicInfoCell.view_baseAddTag.frame = CGRectMake(_basicInfoCell.view_baseAddTag.frame.origin.x, y_origin, _basicInfoCell.view_baseAddTag.frame.size.width, _basicInfoCell.view_baseAddTag.frame.size.height);
        
        return _basicInfoCell;
    }
    else if (indexSec == TABLE_SEC_INDEX_MY_PLANNED_EVENTS)
    {
        ///Show User's Planned Events
        ZPAMyPlannedEventCell *myPlannedEventsCell = [tableView dequeueReusableCellWithIdentifier:@"ZPAMyPlannedEventCell"];
        [myPlannedEventsCell configureCellUsingZeppaEvent:[_arrMyPlannedEvents objectAtIndex:indexPath.row]];
        return myPlannedEventsCell;
    }
    return  nil;
    
}
//****************************************************
#pragma mark - UITableViewDelegate Methods
//****************************************************

///@todo need to implement below methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indexSet = indexPath.section;
    
    if (indexSet == TABLE_SEC_INDEX_MY_BASIC_INFO) {
        CGFloat height = BASIC_INFO_BASE_HEIGHT + ADD_TAG_BASE_HEIGHT + self.basicInfoCell.tagContainerHeight.constant;
        NSLog(@"Info Cell Height: %f", height);
        
        return height;
        
    }
    if (indexSet == TABLE_SEC_INDEX_MY_PLANNED_EVENTS) {
        return MY_PLANNED_EVENTS_INFO_CELL_HEIGHT;
        
    }
    return 200;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == TABLE_SEC_INDEX_MY_PLANNED_EVENTS) {
        return 0;
    }
    return 0;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    ///Create My Planned Events Header View
//    CGRect headerViewFrame = tableView.bounds;
//    headerViewFrame.origin = (CGPoint){0,0};
//    headerViewFrame.size.height = HEADER_HEIGHT;
//    UIView *headerView = [[UIView alloc]initWithFrame:headerViewFrame];
//    headerView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *lblMyPlannedEvents = [[UILabel alloc]initWithFrame:CGRectZero];
//    lblMyPlannedEvents.textAlignment = NSTextAlignmentCenter;
//    lblMyPlannedEvents.text = NSLocalizedString(@"My Planned Events:", nil);
//    lblMyPlannedEvents.textColor = [ZPAStaticHelper titleColorForHeaders];
//    
//    lblMyPlannedEvents.backgroundColor = [UIColor clearColor];
//    
//    [headerView addSubview:lblMyPlannedEvents];
//    
//    return headerView ;
//}



///*****************************************************
#pragma mark- TextField Delegate Method
///*****************************************************


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > [ZPAStaticHelper getMaxCharacterInTextField]) ? NO : YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    float tableViewHeight =   self.tableView.contentSize.height;
    self.tableView.contentSize=CGSizeMake(self.tableView.contentSize.width, tableViewHeight+(self.basicInfoCell.tagContainerHeight.constant));
    self.tableView.contentOffset=CGPointMake(0, _basicInfoCell.txtNewTag.frame.origin.y-100);
    
    return YES;
}
///*************************************************
#pragma mark- Tag Private Method
///*************************************************
- (IBAction)tagButtonTapped:(UIButton *)sender{
    
//    tagArray= _currentUser.tagsArray;
    
    
    NSString *titleString = [_basicInfoCell.txtNewTag.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (titleString && titleString.length>0) {
        
        titleString = [titleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *arr = [titleString componentsSeparatedByString:@" "];
        titleString = @"";
        for (NSString *str in arr) {
            titleString = [titleString stringByAppendingString:str.capitalizedString];
        }
        
    }else{
        [ZPAStaticHelper showAlertWithTitle:@"" andMessage:@"Please Enter Tag Text"];
        return;
    }

    
   
    for (UIView *view in _tempArray) {
        UIButton *button = (UIButton *)[view viewWithTag:TAGS_BUTTON_TAG];
        
        if ([button.titleLabel.text.uppercaseString isEqualToString:titleString.uppercaseString]) {
            [ZPAStaticHelper showAlertWithTitle:@"" andMessage:@"Tag already exist"];
            return;
            
            
        }
    }
    
        
        //str1 = [str1.capitalizedString stringByAppendingString:str2.capitalizedString];
        
        
        GTLZeppaclientapiEventTag *tag = [[GTLZeppaclientapiEventTag alloc]init];
        tag.tagText = titleString;
        tag.ownerId = [[ZPAZeppaEventTagSingleton sharedObject]getCurrentUserId];
    
    // TODO: implement adding tags from profile
    
       [[ZPAZeppaEventTagSingleton sharedObject] executeInsetEventTagWithEventTag:tag WithCompletion:^(GTLZeppaclientapiEventTag *tag, NSError *error) {
       
        
       }];
    
        [self showTagButtonWithTitleString:titleString];
        _basicInfoCell.txtNewTag.text=@"";
    }

-(void)showTagButtonWithTitleString:(NSString *)title{
    
    
    if (![title isEqualToString:@""]) {
        
        UIButton *newButton =[[UIButton alloc]init];
        [newButton setTitle:title forState:UIControlStateNormal];
        [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newButton setBackgroundColor:[UIColor colorWithRed:10/255.0f green:210/255.0f blue:255/255.0f alpha:1.0f]];
        
        [newButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [newButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [newButton.layer setBorderWidth:1.0];
        [newButton.layer setBorderColor:[[UIColor clearColor]CGColor]];
        [newButton.layer setCornerRadius:3.0];
        [newButton.layer setMasksToBounds:YES];
        
        CGSize textSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        
        [newButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [newButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [newButton setFrame:CGRectMake(PADDING,PADDING,textSize.width+PADDING,textSize.height+PADDING)];
        [newButton setTag:TAGS_BUTTON_TAG];
        
        
        UIView *newView =[[UIView alloc]init];
        
        if (_tempArray.count!=0) {
            UIView *lastView =(UIView *)[_tempArray lastObject];
            [newView setFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width,lastView.frame.origin.y,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            
            if (newView.frame.origin.x+newButton.frame.size.width>self.tableView.contentSize.width) {
                
                newView.frame =CGRectMake(PADDING, newView.frame.origin.y+newView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
                
                _counter++;
                self.basicInfoCell.tagContainerHeight.constant += newView.frame.size.height;

                [self resizeTagviewAndTableCell];
                
            }
            
        }else{
            
        [newView setFrame:CGRectMake(0,PADDING,textSize.width+2*PADDING,textSize.height+2*PADDING)];

            self.basicInfoCell.tagContainerHeight.constant = newView.frame.size.height+(2*PADDING);
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                _counter = 1;
            [_tableView reloadData];
            }

            
        }
        [newView addSubview:newButton];
        [_basicInfoCell.view_tagContainer addSubview:newView];
        [_tempArray addObject:newView];
    }
    
    
}
-(void)resizeTagviewAndTableCell{
    
    
    NSIndexPath *indexpath =[NSIndexPath indexPathForRow:0 inSection:0 ];
    [self resizeTagContainer];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
-(void)arrangeButtonWhenCallCellForRowAtIndex{
    for (UIView *view in _basicInfoCell.contentView.subviews) {
        if (view.tag==TAGS_BASEVIEW_TAGVALUE) {
            [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
    // Reset the tag container height
    for (int j=0; j<_tempArray.count; j++) {
        UIView *view =[_tempArray objectAtIndex:j];
        UIButton *button = (UIButton *)[view viewWithTag:TAGS_BUTTON_TAG];
        CGRect frame = button.frame;
        
        
        if (j==0) {
            _counter=1;
            view.frame=CGRectMake(PADDING, PADDING, frame.size.width+PADDING, frame.size.height+PADDING);
            self.basicInfoCell.tagContainerHeight.constant=view.frame.size.height + (2*PADDING);
        }
        else{
            UIView *preView =[_tempArray objectAtIndex:j-1];
            view.frame=CGRectMake(preView.frame.origin.x+preView.frame.size.width, preView.frame.origin.y, frame.size.width+PADDING, frame.size.height+PADDING);
            if (view.frame.origin.x+view.frame.size.width>self.tableView.contentSize.width) {
                view.frame=CGRectMake(PADDING, view.frame.origin.y+view.frame.size.height, view.frame.size.width, view.frame.size.height);
                _counter++;
                self.basicInfoCell.tagContainerHeight.constant+=view.frame.size.height;
            }
        }
        [_basicInfoCell.view_tagContainer addSubview:view];
    }
   
    
 }
/*
 * Resizes the tag container view and height constraints
 */
- (void) resizeTagContainer {
    CGRect tcFrame = _basicInfoCell.view_tagContainer.frame;
    CGFloat xOrigin = tcFrame.origin.x;
    CGFloat yOrigin = tcFrame.origin.y;
    CGFloat width = self.tableView.contentSize.width;
    _basicInfoCell.view_tagContainer.frame = CGRectMake(xOrigin, yOrigin, width, self.basicInfoCell.tagContainerHeight.constant);
    [self.view layoutIfNeeded];
}


- (IBAction)editBtnTapped:(UIBarButtonItem *)sender {
    
    
    UINavigationController *createNewAccountNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPACreateOrEditAccountNavC"];
    
    ZPACreateOrEditAccountVC *createNewAccountVC = [[createNewAccountNavC viewControllers]firstObject];
    createNewAccountVC.user = [ZPAAppData sharedAppData].loggedInUser;
    createNewAccountVC.vcDisplayMode = VCDisplayModeEditAccount;
    createNewAccountVC.delegate = self;
    [self presentViewController:createNewAccountNavC animated:YES completion:NULL];
    
    
}
-(void)didFinishUpdatingUser:(ZPAMyZeppaUser *)user{
    
    
    [ZPAAppData sharedAppData].loggedInUser = user;
    _currentUser = [ZPAAppData sharedAppData].loggedInUser;
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
}
-(void)updateProfileTags:(NSNotification *)notify{
    [[_basicInfoCell.view_tagContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [_tempArray removeAllObjects];
//    [_currentUser.tagsArray removeAllObjects];
    
    [_tableView reloadData];
   // [_basicInfoCell.viewForBaselineLayout addSubview:_basicInfoCell.view_TagContainer];
}

-(NSString *)getFormattedNumber:(NSString *)number{
    
    
    
    if (number.length>0) {

        NSMutableString *str = [NSMutableString stringWithString:number];
        
        if([str hasPrefix:@"1"]){
            NSString * s = [str substringFromIndex:1];
            str = [s mutableCopy];
        }
        
        [str insertString:@"(" atIndex:0];
        [str insertString:@")" atIndex:4];
        [str insertString:@" " atIndex:5];
        [str insertString:@"-" atIndex:9];
        
        
        number = [str copy];
        return number;
    }
    
    
    
    return number;
}


@end
