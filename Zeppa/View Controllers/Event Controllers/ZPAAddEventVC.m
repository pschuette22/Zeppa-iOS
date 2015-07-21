//
//  ZPAAddEventVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 08/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAAddEventVC.h"
#import "ZPAAddInvitesVC.h"

#import "BRStaticHelper.h"

#import "GTLZeppaeventendpointZeppaEvent.h"
#import "GTLQueryZeppaeventendpoint.h"
#import "GTLServiceZeppaeventendpoint.h"
#import "GTLEventtagendpointEventTag.h"

#import "GTLEventtagfollowendpointEventTagFollow.h"

#import "ZPAAuthenticatonHandler.h"

#import "ZPAZeppaEventSingleton.h"
#import "ZPAMyZeppaEvent.h"
#import "ZPAZeppaEventTagSingleton.h"
#import "ZPAFetchDefaultTagsForUser.h"

#define SEGUE_ID_ADD_INVITES @"addInvitesSegue"

#define SCROLLVIEW_HEIGHT 505
#define VIEW_SECONDINITIAL 405
#define VIEW_BASE_TAGFEATURE 80

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define PADDING 8
#define TAGS_BUTTON_TAG 100
#define HEIGHTEXTEND 33

typedef NS_ENUM(NSInteger, selectedBtn){
    startDate=0,
    endDate
};

@interface ZPAAddEventVC ()<CustomPickerDelegate,DateAndTimePickerDelegate,UITextViewDelegate,addInvitesDelegate>
@property (nonatomic, strong)NSMutableArray *tagsArray;
@property (nonatomic, assign,getter = isFirstTime) BOOL firstTime;
@property (nonatomic, strong)NSMutableArray *arrInvitedUsers;
@property (nonatomic, strong) ZPAFetchDefaultTagsForUser *defaultTagsForUser;
@property (nonatomic,strong)ZPADefaulZeppatUserInfo *userProfileInfo;

@end

@implementation ZPAAddEventVC
{
    ZPADateAndTimePicker *dateAndTimePicker;
    ZPACustomPicker *customPicker;
    NSString *dateAndTimeValue;
    selectedBtn selectedButton;
    NSString * mapLocationStr;
    NSMutableArray *temp;
    NSMutableArray *testArray;
    NSMutableArray *invitedUserIdArray;
    ZPAMyZeppaUser *currentUser;
   // NSMutableArray *eventTagIdsArray;
    int counter;
    UIAlertView * alertWithTextField;
   ZPAAddInvitesVC *addInvitesVC;
    NSMutableArray *tagBtnArray;
    NSMutableArray * selectedTagBtn;
    NSString * startTime;
    NSString * endTime;
    NSInteger noOfLines;
}

//****************************************************
#pragma mark - Life Cycle
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
    
    [self initialization];

    [_navigationBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    _checkBox.tintColor = [UIColor darkGrayColor];
    _checkBox.checkMarkColor = [ZPAStaticHelper zeppaThemeColor];
    _checkBox.checked = YES;
    currentUser = [ZPAAppData sharedAppData].loggedInUser;
    currentUser.tagsArray = [[NSMutableArray alloc]init];
    _tagsArray = [[[ZPAZeppaEventTagSingleton sharedObject] getMyTags] mutableCopy];
    _arrInvitedUsers = [NSMutableArray array];
    testArray = [NSMutableArray array];
    counter = 1;
    
    for (GTLEventtagendpointEventTag *tag in _tagsArray) {
        
        UIButton *newButton =[[UIButton alloc]init];
        NSString *string =tag.tagText;
        
        [newButton setTitle:string forState:UIControlStateNormal];
        [newButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
        [newButton setBackgroundColor:[UIColor whiteColor]];
        
        [newButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [newButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [newButton.layer setBorderWidth:1.0];
        [newButton.layer setBorderColor:[[ZPAStaticHelper zeppaThemeColor]CGColor]];
        [newButton.layer setCornerRadius:3.0];
        [newButton.layer setMasksToBounds:YES];
        
        CGSize textSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        
        [newButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [newButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [newButton setFrame:CGRectMake(PADDING,PADDING,textSize.width+PADDING,textSize.height+PADDING)];
        [newButton setTag:TAGS_BUTTON_TAG];
        
        
        
        UIView *newView =[[UIView alloc]init];
        
        if (testArray.count!=0) {
            UIView *lastView =(UIView *)[testArray lastObject];
            [newView setFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width,lastView.frame.origin.y,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            
        }else{
            [newView setFrame:CGRectMake(PADDING,PADDING,textSize.width+2*PADDING,textSize.height+2*PADDING)];
        }
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = .5;
        [newButton addGestureRecognizer:longPress];
        
        [newView addSubview:newButton];
        [testArray addObject:newView];
        
        [tagBtnArray addObject:newButton];
        
        [newButton addTarget:self action:@selector(newButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self arrangeButtonWhenCallCellForRowAtIndex];
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    self.title = NSLocalizedString(@"Add Event", nil);
    
    self.firstTime = YES;
    
    
    [self configureScreen];
    
  //  [self registerForNotifications];
    
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    if (self.isFirstTime) {
        self.firstTime = NO;
        [self resetScrollViewContentSize];
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
   // [self unregisterFromNotifications];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
  //  addInvitesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPAAddInvitesVC"];
    
    if ([segue.identifier isEqualToString:SEGUE_ID_ADD_INVITES]) {
        
        addInvitesVC = segue.destinationViewController;
        ///Initialze any property here
        if (invitedUserIdArray.count>0) {
        
            addInvitesVC.invitesUserIdArray = invitedUserIdArray;
            
        }
        
        addInvitesVC.delegate = self;
    }
    
    
       
}


//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    
//    if (invitedUserIdArray.count == 0) {
//        [ZPAStaticHelper showAlertWithTitle:nil andMessage:@"No user to Invite."];
//        return NO;
//        
//    }
//    return YES;
//}
-(IBAction)unwindSegueToAddEventVC:(UIStoryboardSegue *)sender{
    
    addInvitesVC = sender.sourceViewController;
    
    if ([addInvitesVC isKindOfClass:[ZPAAddInvitesVC class]]) {
        NSLog(@"unwindToEvents");
        
        invitedUserIdArray = addInvitesVC.invitesUserIdArray;
    }
    _lbl_noOfInvites.text = [NSString stringWithFormat:@"%zd",invitedUserIdArray.count];
    
}

//****************************************************
#pragma mark - Private Methods
//****************************************************

//-(void)registerForNotifications
//{
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//-(void)unregisterFromNotifications
//{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//}



-(void)configureScreen
{
    
    
    ///Configure Comment View
//    self.textView_Description.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
//    self.textView_Description.layer.borderWidth = 1.0f;
//    self.textView_Description.layer.cornerRadius = 5.0f;
//    self.textView_Description.layer.masksToBounds = YES;
    
    
}
-(void)initialization{
    
    _tagsArray = [NSMutableArray array];
    
    tagBtnArray = [NSMutableArray array];
    
    selectedTagBtn = [NSMutableArray array];
    
    dateAndTimePicker = [ZPAStaticHelper datePickerView];
    dateAndTimePicker.delegate = self;
    
    customPicker = [ZPAStaticHelper customPickerView];
    customPicker.delegate = self;
    
    
    _lblEventStartTime.text =[NSString stringWithFormat:@"Today %@",[[ZPADateHelper sharedHelper]stringFromDate:[NSDate date] withFormat:@"hh:mm a"]];
    
    
    _lblEventEndTime.text = [NSString stringWithFormat:@"Today %@",[[ZPADateHelper sharedHelper]stringFromDate:[NSDate dateWithTimeInterval:(60*60) sinceDate:[NSDate date]] withFormat:@"hh:mm a"]];
    
    currentUser = [ZPAAppData sharedAppData].loggedInUser;
    currentUser.tagsArray = [[NSMutableArray alloc]init];
    _eventTagIdsArray = [NSMutableArray array];
    
    for (NSNumber *tagId in [ZPAZeppaEventTagSingleton sharedObject].tagId){
        
        [_tagsArray addObject:[[ZPAZeppaEventTagSingleton sharedObject] getZeppaTagWithId:[tagId longLongValue]]];
    }
}

-(void)resetScrollViewContentSize
{
    float bottomPadding = 0.0f;
    float contentHeight = self.view_baseBelowLocation.frame.origin.y + self.view_baseBelowLocation.frame.size.height + bottomPadding;
    
    float availableHeight = self.scrollView_base.frame.size.height;
    
    contentHeight = contentHeight > availableHeight ? contentHeight : availableHeight;
    
    CGSize contentSize = (CGSize){self.scrollView_base.frame.size.width,contentHeight};
    [self.scrollView_base setContentSize:contentSize];
    
    
}

-(NSMutableArray *)arrInvitedUsers
{
    if (_arrInvitedUsers) {
        return _arrInvitedUsers;
    }
    
    _arrInvitedUsers = [NSMutableArray array];
    return _arrInvitedUsers;
    
}

//****************************************************
#pragma mark - UITextFieldDelegate Methods
//****************************************************

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[BRStaticHelper sharedObject] setContentOffSetof:textField insideInView:_scrollView_base withLastFieldTagValue:103];
    return YES;
    
}
//****************************************************
#pragma mark - UITextViewDelegate Methods
//****************************************************

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [[BRStaticHelper sharedObject] setContentOffSetof:textView insideInView:_scrollView_base withLastFieldTagValue:103];
        return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSUInteger newLength = (textView.text.length - range.length) + text.length;
    _lblDescriptionPlaceholder.hidden = (newLength>0)?YES:NO;
    
    if ([text isEqualToString:@"\n"]) {
        noOfLines++;
        
        if (noOfLines >= 2) {
        
            return NO;
    
        }
        
    }
    
    return YES;
}
- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}


//****************************************************
#pragma mark - Notification
//****************************************************


- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float kbHeight = _kbSize.width > _kbSize.height ? _kbSize.height : _kbSize.width;
    _scrollView_base.contentSize = CGSizeMake(_scrollView_base.bounds.size.width, _scrollView_base.bounds.size.height + kbHeight);
    
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    
    NSDictionary* info = [note userInfo];
    CGSize _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float kbHeight = _kbSize.width > _kbSize.height ? _kbSize.height : _kbSize.width;
    _scrollView_base.contentSize = CGSizeMake(_scrollView_base.bounds.size.width, _scrollView_base.bounds.size.height - kbHeight);
    //    _scrollView_Base.contentSize = CGSizeZero;
    [self resetScrollViewContentSize];
}


//****************************************************
#pragma mark - Action Methods
//****************************************************


- (IBAction)doneBtnTapped:(UIBarButtonItem *)sender {
    
    if ([ZPAZeppaEventTagSingleton sharedObject].tagId.count>0) {
        
      //  if (_eventTagIdsArray.count == 0 ) {
            [_eventTagIdsArray addObjectsFromArray:[ZPAZeppaEventTagSingleton sharedObject].tagId];
//        }else{
//            [_eventTagIdsArray removeObject:[ZPAZeppaEventTagSingleton sharedObject].tagId];
//            [_eventTagIdsArray addObjectsFromArray:[ZPAZeppaEventTagSingleton sharedObject].tagId];
//            
//        }
        _eventTagIdsArray = [[[NSOrderedSet orderedSetWithArray:_eventTagIdsArray ] array]mutableCopy];
        
    }
    

    
    //[self addNewZeppaEvents];
    [self executeInsertZeppaEventTask:nil];
    
    
    
}

- (IBAction)btnMapLocationTapped:(UIButton *)sender {
    
    [_txtEventLocation resignFirstResponder];
    [_txtEventTitle resignFirstResponder];
    [_txtNewTag resignFirstResponder];
    [_textView_Description resignFirstResponder];
    
    alertWithTextField = [[UIAlertView alloc]initWithTitle:@"Set Map Address" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done",nil];
    alertWithTextField.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertWithTextField textFieldAtIndex:0].placeholder = @"42 Wallaby way,Sydney";
    
    [alertWithTextField show];
}

- (IBAction)btnSelectEventStartTimeTapped:(id)sender {
    
    [_txtEventLocation resignFirstResponder];
    [_txtEventTitle resignFirstResponder];
    [_txtNewTag resignFirstResponder];
    [_textView_Description resignFirstResponder];

    
    selectedButton = startDate;
    
    dateAndTimePicker.frame = self.view.bounds;
    dateAndTimePicker.titleLabel.text = @"Select Start Date";
    
    [self.view addSubview:dateAndTimePicker];
}

- (IBAction)btnSelectEventEndTimeTapped:(id)sender {
    
    [_txtEventLocation resignFirstResponder];
    [_txtEventTitle resignFirstResponder];
    [_txtNewTag resignFirstResponder];
    [_textView_Description resignFirstResponder];

    
    selectedButton = endDate;
    
    dateAndTimePicker.frame = self.view.bounds;
    dateAndTimePicker.titleLabel.text = @"Select End Date";
    
    [self.view addSubview:dateAndTimePicker];
}

- (IBAction)btnSelectEventPrivacyTapped:(id)sender {
    
    [_txtEventLocation resignFirstResponder];
    [_txtEventTitle resignFirstResponder];
    [_txtNewTag resignFirstResponder];
    [_textView_Description resignFirstResponder];

    
    customPicker.frame = self.view.bounds;
    [self.view addSubview:customPicker];
    customPicker.pickerTitleLbl.text = @"Select Privacy";
    customPicker.presentingArray = [NSMutableArray arrayWithObjects:@"Casual",@"Private", nil];
    
}
- (IBAction)btnAddNewTagTapped:(id)sender {
    
    [self stopWobble];
    
    
    ///Remove whitespace in string.
    NSString *titleString = [_txtNewTag.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    ///Check button title is not nil or blank
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
    
    //Check tag is already is exist or not.
    for (GTLEventtagendpointEventTag * tag in _tagsArray) {
        
        if ([titleString.uppercaseString isEqualToString:tag.tagText.uppercaseString]) {
            
            [ZPAStaticHelper showAlertWithTitle:@"" andMessage:@"Tag already exist"];
            return;
            
        }
    }
    GTLEventtagendpointEventTag *tag = [[GTLEventtagendpointEventTag alloc]init];
        tag.tagText = titleString;
        tag.ownerId = [[ZPAZeppaEventTagSingleton sharedObject]getCurrentUserId];
      [[ZPAZeppaEventTagSingleton sharedObject] executeInsetEventTagWithEventTag:tag WithCompletion:^(GTLEventtagendpointEventTag *tag, NSError *error) {
          [_tagsArray addObject:tag];
        
       }];
        
        UIButton *newButton =[[UIButton alloc]init];
        [newButton setTitle:titleString forState:UIControlStateNormal];
        [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
        
        [newButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [newButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [newButton.layer setBorderWidth:1.0];
        [newButton.layer setBorderColor:[[ZPAStaticHelper zeppaThemeColor]CGColor]];
        [newButton.layer setCornerRadius:3.0];
        [newButton.layer setMasksToBounds:YES];
        
        CGSize textSize = [_txtNewTag.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        
        [newButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [newButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [newButton setFrame:CGRectMake(PADDING,PADDING,textSize.width+PADDING,textSize.height+PADDING)];
        [newButton setTag:TAGS_BUTTON_TAG];
        
        
        
        UIView *newView =[[UIView alloc]init];
        
        if (testArray.count!=0) {
            UIView *lastView =(UIView *)[testArray lastObject];
            [newView setFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width,lastView.frame.origin.y,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            
            if (newView.frame.origin.x+newButton.frame.size.width>300) {
                newView.frame =CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
                NSLog(@"%f",newView.frame.origin.y);
                counter++;
            }
            
        }else{
            [newView setFrame:CGRectMake(0,0,textSize.width+2*PADDING,textSize.height+2*PADDING-2)];
            NSLog(@"%f",newView.frame.origin.y);
        }
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = .5;
        [newButton addGestureRecognizer:longPress];
        
        [newView addSubview:newButton];
        [self.view_TagsContainer addSubview:newView];
        [testArray addObject:newView];
        [self updateAllViewsFrames];
        [newButton addTarget:self action:@selector(newButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        if (selectedTagBtn.count >= 6) {
            
            UIButton *firstButton = [selectedTagBtn firstObject];
            [firstButton setBackgroundColor:[UIColor whiteColor]];
            [firstButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
            [selectedTagBtn removeObject:firstButton];
            [_eventTagIdsArray removeObject:[_eventTagIdsArray firstObject]];
            
        }
        [newButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
        [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [tagBtnArray addObject:newButton];
       // [_eventTagIdsArray addObject:tag.identifier];
        [selectedTagBtn addObject:newButton];
    
        
        
        
        if (tag.identifier) {
            [_eventTagIdsArray addObject:tag.identifier];
            
            
        
            
        }
        
    
    //Reset TextField When Tag is added.
    _txtNewTag.text=@"";
     [_txtNewTag becomeFirstResponder];
        
}

- (IBAction)cancelBtnTapped:(UIBarButtonItem *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)addInviteesBtn:(UIButton *)sender {
    
    
}
///*************************************************
#pragma mark - AlertView Delegate Method
///*************************************************

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView isEqual:alertWithTextField] ) {
        mapLocationStr = [alertView textFieldAtIndex:0].text;
        NSLog(@"%@",[alertView textFieldAtIndex:0].text);

    }
}




///*************************************************
#pragma mark - Tag Private Method
///*************************************************

- (void)startWobble{
    for (UIView *btn in _view_TagsContainer.subviews) {
        btn.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-2));
    }
    [UIView animateWithDuration:0.10
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                         for (UIView *btn in _view_TagsContainer.subviews) {
                             btn.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(2));
                         }
                     }
                     completion:NULL
     ];
}

- (void)stopWobble {
    [UIView animateWithDuration:0.10
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         for (UIButton *btn in testArray) {
                             btn.transform = CGAffineTransformIdentity;
                             for (UIView *view in btn.subviews) {
                                 if ([view isKindOfClass:[UIButton class]] && view.tag!=TAGS_BUTTON_TAG){
                                     [view removeFromSuperview];
                                 }
                             }
                         }
                     }
                     completion:NULL];
}
- (IBAction)deleteButton:(UIButton *)sender {
    
    UIButton *delectButton =(UIButton *)sender.superview;
    delectButton.hidden=YES;
    int i;
    for (i=0; i<testArray.count; i++) {
        if (delectButton==[testArray objectAtIndex:i]) {
            break;
        }
    }
    [testArray removeObject:delectButton];
    [self stopWobble];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    tempArray = [testArray mutableCopy];
    
    for (int j=0; j<tempArray.count; j++) {
        UIView *view =[tempArray objectAtIndex:j];
        UIButton *button = (UIButton *)[view viewWithTag:TAGS_BUTTON_TAG];
        CGRect frame = button.frame;
        
        if (j==0) {
            view.frame=CGRectMake(0, 0, frame.size.width+PADDING, frame.size.height+PADDING);
        }
        else{
            UIView *preView =[tempArray objectAtIndex:j-1];
            view.frame=CGRectMake(preView.frame.origin.x+preView.frame.size.width, preView.frame.origin.y, frame.size.width+PADDING, frame.size.height+PADDING);
            if (view.frame.origin.x+view.frame.size.width>300) {
                view.frame=CGRectMake(0, view.frame.origin.y+view.frame.size.height, frame.size.width+PADDING, frame.size.height+PADDING);
                
                
            }
        }
        
    }
    counter = ([[tempArray lastObject] frame].origin.y/32.7)+1;
    [self updateAllViewsFrames];
}
-(void)setCrossButton
{
    
    for (UIView *view in testArray) {
        UIButton *button = (UIButton*)[view viewWithTag:TAGS_BUTTON_TAG];
        UIButton *crossButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        
        [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        crossButton.center=CGPointMake(button.frame.origin.x, button.frame.origin.y);
        [crossButton addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:crossButton];
    }
    [self startWobble];
    
}
- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan){
        [self setCrossButton];
    }
}
-(void)arrangeButtonWhenCallCellForRowAtIndex{
    
    for (int j=0; j<testArray.count; j++) {
        UIView *view =[testArray objectAtIndex:j];
        UIButton *button = (UIButton *)[view viewWithTag:TAGS_BUTTON_TAG];
        CGRect frame = button.frame;
        
        if (j==0) {
            view.frame=CGRectMake(0,0, frame.size.width+PADDING, frame.size.height+PADDING);
        }
        else{
            UIView *preView =[testArray objectAtIndex:j-1];
            view.frame=CGRectMake(preView.frame.origin.x+preView.frame.size.width, preView.frame.origin.y, frame.size.width+PADDING, frame.size.height+PADDING);
            if (view.frame.origin.x+view.frame.size.width>300) {
                view.frame=CGRectMake(0, view.frame.origin.y+view.frame.size.height, view.frame.size.width, view.frame.size.height);
                counter++;
                
                
            }
        }
        [_view_TagsContainer addSubview:view];
    }
    [self updateAllViewsFrames];
}
-(void)updateAllViewsFrames{
    
    
    _scrollView_base.contentSize = CGSizeMake(320, SCROLLVIEW_HEIGHT+(counter*HEIGHTEXTEND));
    
    
    
    _view_baseBelowLocation.frame = CGRectMake(_view_baseBelowLocation.frame.origin.x, _view_baseBelowLocation.frame.origin.y, _view_baseBelowLocation.frame.size.width,VIEW_SECONDINITIAL+counter*HEIGHTEXTEND);
    
    _view_baseTagsFeature.frame = CGRectMake(_view_baseTagsFeature.frame.origin.x, _view_baseTagsFeature.frame.origin.y, _view_baseTagsFeature.frame.size.width, VIEW_BASE_TAGFEATURE+counter*HEIGHTEXTEND-25);
    
    _view_TagsContainer.frame = CGRectMake(_view_TagsContainer.frame.origin.x, _view_TagsContainer.frame.origin.y, _view_TagsContainer.frame.size.width, counter*HEIGHTEXTEND);
    
    
    _view_baseAddInvites.frame = CGRectMake(_view_baseAddInvites.frame.origin.x,_view_baseTagsFeature.frame.origin.y+_view_baseTagsFeature.frame.size.height+15 , _view_baseAddInvites.frame.size.width, _view_baseAddInvites.frame.size.height);
    
}

-(IBAction)newButtonAction:(UIButton *)sender{
    
    
    
    if(sender.backgroundColor == [UIColor whiteColor]){
        
    for (GTLEventtagendpointEventTag * tag in _tagsArray) {
            
        if ([sender.titleLabel.text isEqualToString:tag.tagText]) {
            
            if (selectedTagBtn.count >= 6) {
                
                UIButton *firstButton = [selectedTagBtn firstObject];
                [firstButton setBackgroundColor:[UIColor whiteColor]];
                [firstButton setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
                [selectedTagBtn removeObject:firstButton];
                [_eventTagIdsArray removeObject:[_eventTagIdsArray firstObject]];
               
            }
            [sender setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_eventTagIdsArray addObject:tag.identifier];
            [selectedTagBtn addObject:sender];
            
            }
        
        }
    }else{
        [sender setBackgroundColor:[UIColor whiteColor]];
        [sender setTitleColor:[ZPAStaticHelper zeppaThemeColor] forState:UIControlStateNormal];
        
        for (GTLEventtagendpointEventTag * tag in _tagsArray) {
            
            if ([sender.titleLabel.text isEqualToString:tag.tagText]) {
                [_eventTagIdsArray removeObject:tag.identifier];
                [selectedTagBtn removeObject:sender];
            }
            
        }

    }
    
    
    
   // [self executeZeppaTagFollowApi:sender];
}

-(void )executeZeppaTagFollowApi:(UIButton *)tagButton{
    
    
    GTLEventtagfollowendpointEventTagFollow * tagFollow = [[GTLEventtagfollowendpointEventTagFollow alloc]init];
    
    
    
    for (GTLEventtagendpointEventTag * tag in _tagsArray) {
        if ([tag.tagText.uppercaseString isEqualToString:tagButton.titleLabel.text.uppercaseString]) {
            
            if ([_defaultTagsForUser isFollowing:tag ] == NO ){
                
                [tagButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
                
                tagFollow.tagOwnerId = _userProfileInfo.userId;
                tagFollow.followerId = currentUser.endPointUser.identifier;
                tagFollow.tagId = tag.identifier;
                [_defaultTagsForUser insertZeppaTagFollow:tagFollow];
                
            }else{
                
                [_defaultTagsForUser removeZeppaTagFollow:tag];
                [tagButton setBackgroundColor:[ UIColor whiteColor]];
            }
        }
    }
    
}


///*************************************************
#pragma mark - Date And Time Picker Delegate Method
///*************************************************

-(void)doneBtnTappedOnDateAndTimePicker:(NSDate *)date{
    
    NSMutableDictionary *tempDateAndTime =  [NSMutableDictionary dictionary];
    [tempDateAndTime setObject:[[ZPADateHelper sharedHelper] stringFromDate:date withFormat:@"MM/dd/yyyy hh:mm a"] forKey:@"detail"];
    
    switch (selectedButton) {
        case startDate:
        {
            startTime = [tempDateAndTime objectForKey:@"detail"];
            
            double startTimeStamp = ([date timeIntervalSince1970])*1000;
            
           _lblEventStartTime.text = [self dispalyDateWithRequiredFormat:[NSNumber numberWithDouble:startTimeStamp]];
            
            NSDate *afterOneHour = [NSDate dateWithTimeInterval:(60*60) sinceDate:[[ZPADateHelper sharedHelper]dateFromString:[tempDateAndTime objectForKey:@"detail"] withFormat:@"MM/dd/yyyy hh:mm a"]];
            
            endTime = [[ZPADateHelper sharedHelper]stringFromDate:afterOneHour withFormat:@"MM/dd/yyyy hh:mm a"];
            
            double endTimeStamp = ([afterOneHour timeIntervalSince1970])*1000;
            
            _lblEventEndTime.text = [self dispalyDateWithRequiredFormat:[NSNumber numberWithDouble:endTimeStamp]];
            
        }
            break;
            
        case endDate:
            endTime = [tempDateAndTime objectForKey:@"detail"];
            
            double startTimeStamp = ([date timeIntervalSince1970])*1000;
            
            _lblEventEndTime.text = [self dispalyDateWithRequiredFormat:[NSNumber numberWithDouble:startTimeStamp]];
            break;
            
        default:
            break;
    }
    
    
}
///*************************************************
#pragma mark - Custom PickerView  Delegate Method
///*************************************************

-(void)doneBtnTappedOnCustomPicker:(NSString *)string{
    [customPicker removeFromSuperview];
    _lblEventPrivacy.text= string;
}

///*************************************************
#pragma mark - Events API Method
///*************************************************


- (void) executeInsertZeppaEventTask:(id)sender {
    
    ZPAMyZeppaEvent * myZeppaEvent = [[ZPAMyZeppaEvent alloc]init];
    UIAlertView *alert;
    
    GTLZeppaeventendpointZeppaEvent *zeppaEvent = [[GTLZeppaeventendpointZeppaEvent alloc] init];
    
   
    
    [zeppaEvent setHostId:currentUser.endPointUser.identifier];
    [zeppaEvent setTitle:_txtEventTitle.text];
    [zeppaEvent setDescriptionProperty:_textView_Description.text];
    [zeppaEvent setPrivacy:[_lblEventPrivacy.text uppercaseString]];
    
    [zeppaEvent setGuestsMayInvite:[NSNumber numberWithInt:_checkBox.checked]];
    
    NSDate *startDate = [[ZPADateHelper sharedHelper]dateFromString:startTime withFormat:@"MM/dd/yyyy hh:mm a"];
    
    double startTimeStamp = ([startDate timeIntervalSince1970])*1000;
    
    NSNumber * startTimee = [NSNumber numberWithDouble:startTimeStamp];
    
    
    
    NSDate *endDate = [[ZPADateHelper sharedHelper]dateFromString:endTime withFormat:@"MM/dd/yyyy hh:mm a"];
    double endTimeStamp = ([endDate timeIntervalSince1970])*1000;
     NSNumber * endTimee = [NSNumber numberWithDouble:endTimeStamp];
    
    [zeppaEvent setStart:startTimee];
   
    [zeppaEvent setEnd:endTimee];
    
    [zeppaEvent setDisplayLocation:_txtEventLocation.text];
    [zeppaEvent setMapsLocation:mapLocationStr];
   
    
    [zeppaEvent setTagIds:_eventTagIdsArray];
    [zeppaEvent setInvitedUserIds:invitedUserIdArray];
    
    if (![self isValidEvent:zeppaEvent]) {
        alert = [[UIAlertView alloc]initWithTitle:@"Invalid Event" message:@"Must include a title, location, and upcoming time/date" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }else if (_eventTagIdsArray.count == 0){
        
        alert = [[UIAlertView alloc]initWithTitle:@"Add Tags" message:@"Add a few category tags first! This is how Zeppa recommends your events to people you mingle with" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    
        
    }else{
        
        alert = [[UIAlertView alloc]initWithTitle:@"Posting Event" message:@"One Moment,Please" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];

    
    GTLQueryZeppaeventendpoint *insertZeppaEventTask = [GTLQueryZeppaeventendpoint queryForInsertZeppaEventWithObject:zeppaEvent];
    
    [[self zeppaEventService] executeQuery:insertZeppaEventTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaeventendpointZeppaEvent * event, NSError *error) {
        //
        
        if(error){
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView * alert1 = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Error Posting Event" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alert1 show];
            
        } else if (event.identifier){
            
            myZeppaEvent.event = event;
           
            [[ZPAZeppaEventSingleton sharedObject]addZeppaEvents:myZeppaEvent];
            [[NSNotificationCenter defaultCenter]postNotificationName:kzeppacalendarSync object:nil];
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else if (event == nil) {
            
            [alert dismissWithClickedButtonIndex:0 animated:YES];
            UIAlertView * alert1 = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Error Posting Event" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alert1 show];
        }

        
    }];
    
    
    
}
}



// Create Zeppa Event service
-(GTLServiceZeppaeventendpoint *) zeppaEventService {
    static GTLServiceZeppaeventendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaeventendpoint alloc] init];
        service.retryEnabled = YES;
    }
    
    // Set Auth that is held in the delegate
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
        
    
    return service;
}

-(BOOL)isValidTimeWithStartTime:(long long )startMillis andEndTime:(long long)endMillis{
    
    long long currentTime = [ZPADateHelper currentTimeMillis];
    if (startMillis >= endMillis) {
        return false;
    }else if (endMillis < currentTime){
        return false;
    }else{
        return true;
    }
}


-(BOOL)isValidEvent:(GTLZeppaeventendpointZeppaEvent *)event{
    
    return [self isValidTimeWithStartTime:[event.start longLongValue] andEndTime:[event.end longLongValue]] && [ZPAStaticHelper isValidString:event.title] && ([ZPAStaticHelper isValidString:event.displayLocation] || [ZPAStaticHelper isValidString:event.mapsLocation]);
}

///*************************************************
#pragma mark - Add Invites Delegate Method
///*************************************************

-(void)noOfInvitees{
    
    invitedUserIdArray = addInvitesVC.invitesUserIdArray;

    if (invitedUserIdArray.count == 0 ) {
        _lbl_noOfInvites.text = @"";
    }else{
    
    _lbl_noOfInvites.text = [NSString stringWithFormat:@"%zd",invitedUserIdArray.count];
    }

}

-(UIButton *)getTagButton:(NSArray *)selectedBtnArray{
    
    
    UIButton * selectedBtn = [selectedTagBtn firstObject];
    
          for (UIButton * tagBtn in tagBtnArray) {
    
        if ([tagBtn.titleLabel.text isEqualToString:selectedBtn.titleLabel.text ]){
            
            return selectedBtn;
        }
    }
    return nil;
    
}


-(NSString *)dispalyDateWithRequiredFormat:(NSNumber *)inputTime{
    
    NSTimeInterval interval;
    NSString * timeToDisplayString;
    
    NSDate *tomorrow = [NSDate dateWithTimeInterval:(24*60*60) sinceDate:[NSDate date]];
    NSDate *yesterday = [NSDate dateWithTimeInterval:-(24*60*60) sinceDate:[NSDate date]];
    
    NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
    
    [dateformate setDateFormat:@"dd/MM/YYYY"];
    
    NSString * todayStr= [dateformate stringFromDate:[NSDate date]];
    
    NSString * tommorowStr = [dateformate stringFromDate:tomorrow];
    NSString * yesterdayStr = [dateformate stringFromDate:yesterday];
    
    long long currentTimeInMills = (long long)([[NSDate date] timeIntervalSince1970] * 1000.0);
    
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:currentTimeInMills/1000];
    
    
    double inputChangedTime = [inputTime doubleValue];
    
    
    NSDate * inputDate = [NSDate dateWithTimeIntervalSince1970:inputChangedTime/1000];
    
    NSDate *inputTempDate = [[ZPADateHelper sharedHelper] dateFromDate:inputDate withFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *currTempDate = [[ZPADateHelper sharedHelper] dateFromDate:currentDate withFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *inputStr = [dateformate stringFromDate:inputDate];
    
    //NSString *endDateStr= [[ZPADateHelper sharedHelper]stringFromDate:endDate withFormat:@"dd-MM-yyyy hh:mm a"];
    
    interval = [currTempDate timeIntervalSinceDate:inputTempDate];
    int hours = (int)interval / 3600;
    int minutes = (interval - (hours*3600)) / 60;
    
    minutes = minutes + (hours*60);
    
    if ([inputStr isEqualToString:todayStr]) {
        
        timeToDisplayString = [NSString stringWithFormat:@"Today %@",[[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"hh:mm a"]];
      
      
    }else if([inputStr isEqualToString:tommorowStr]){
        
        timeToDisplayString = [NSString stringWithFormat:@"Tomorrow %@",[[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"hh:mm a"]];
        
    }else if([inputStr isEqualToString:yesterdayStr]){
        
        timeToDisplayString = [NSString stringWithFormat:@"Yesterday %@",[[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"hh:mm a"]];
        
    }else if ([inputTime longLongValue] - currentTimeInMills < (1000 * 60 * 60 * 24 * 7) ){
        
        timeToDisplayString = [NSString stringWithFormat:@"%@ %@",[[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"EEEE"],[[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"hh:mm a"]];
        
    }else{
        timeToDisplayString = [[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"MM/dd/yyyy hh:mm a"];
    }
    return timeToDisplayString;
}


@end
