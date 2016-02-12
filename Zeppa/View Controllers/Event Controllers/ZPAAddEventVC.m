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

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLZeppaclientapiEventTag.h"

#import "GTLZeppaclientapiEventTagFollow.h"

#import "ZPAAuthenticatonHandler.h"

#import "ZPAZeppaEventSingleton.h"
#import "ZPAMyZeppaEvent.h"
#import "ZPAZeppaEventTagSingleton.h"
#import "ZPAFetchDefaultTagsForUser.h"
#import "GrowingTextViewHandler.h"

#define SEGUE_ID_ADD_INVITES @"addInvitesSegue"

//#define SCROLLVIEW_HEIGHT 505
//#define VIEW_SECONDINITIAL 405
#define VIEW_BASE_TAGFEATURE 80
//
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define PADDING 8
#define TAGS_BUTTON_TAG 100
#define DESCRIPTION_DESIGN_HEIGHT 54
//#define HEIGHTEXTEND 33
//#define MAX_HEIGHT 2000

typedef NS_ENUM(NSInteger, selectedBtn){
    startDate=0,
    endDate
};

@interface ZPAAddEventVC ()<CustomPickerDelegate,UIPickerViewDataSource, UIPickerViewDelegate,UITextViewDelegate,addInvitesDelegate>
@property (nonatomic, strong)NSMutableArray *tagsArray;
@property (nonatomic, assign,getter = isFirstTime) BOOL firstTime;
@property (nonatomic, strong)NSMutableArray *arrInvitedUsers;
@property (nonatomic, strong) ZPAFetchDefaultTagsForUser *defaultTagsForUser;
@property (nonatomic,strong)ZPADefaulZeppatUserInfo *userProfileInfo;
@property (strong, nonatomic) GrowingTextViewHandler *handler;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagContainerHeightConstraint;

@end

@implementation ZPAAddEventVC
{
//    ZPADateAndTimePicker *dateAndTimePicker;
    ZPACustomPicker *customPicker;
//    NSString *dateAndTimeValue;
    selectedBtn selectedButton;
    NSString * mapLocationStr;
    NSMutableArray *temp;
    NSMutableArray *testArray;
    NSMutableArray *invitedUserIdArray;
    ZPAMyZeppaUser *currentUser;
//    NSMutableArray *eventTagIdsArray;
    int counter;
    UIAlertView * alertWithTextField;
    ZPAAddInvitesVC *addInvitesVC;
    NSMutableArray *tagBtnArray;
    NSMutableArray * selectedTagBtn;

    NSDate * startTime;
    NSDate *endTime;
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
    
    // set the description label handler
    self.handler = [[GrowingTextViewHandler alloc]initWithTextView:self.textView_Description withHeightConstraint:self.heightConstraint];
    [self.handler updateMinimumNumberOfLines:2 andMaximumNumberOfLine:8];
    
    // set the tags array and tags to display
    _tagsArray = [[[ZPAZeppaEventTagSingleton sharedObject] getMyTags] mutableCopy];
    _arrInvitedUsers = [NSMutableArray array];
    testArray = [NSMutableArray array];
    counter = 1;
    
    for (GTLZeppaclientapiEventTag *tag in _tagsArray) {
        
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
            // Make sure user interaction is enabled
            [newView setUserInteractionEnabled:YES];
            
        }

        
        [newButton addTarget:self action:@selector(newButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [newView addSubview:newButton];
        
        [testArray addObject:newView];
        [tagBtnArray addObject:newButton];
        
    }
    
    [self arrangeButtonWhenCallCellForRowAtIndex];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    self.title = NSLocalizedString(@"New Activity", nil);
    
    self.firstTime = YES;
    
//    [self configureScreen];
    
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
    
    customPicker = [ZPAStaticHelper customPickerView];
    customPicker.delegate = self;
    
    // Set the start and end times
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnits = NSCalendarUnitTimeZone | NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *components = [calendar components: calendarUnits fromDate: [NSDate date]];
    components.second=0;
    components.minute += (5-components.minute%5);
    startTime = [calendar dateFromComponents:components];
    components.hour+=1;
    endTime = [calendar dateFromComponents:components];
    // Update the time text displayed to the user
    [self updateTimeText];
    
    
    
    currentUser = [ZPAAppData sharedAppData].loggedInUser;
    currentUser.tagsArray = [[NSMutableArray alloc]init];
    _eventTagIdsArray = [NSMutableArray array];
    
    for (NSNumber *tagId in [ZPAZeppaEventTagSingleton sharedObject].tagId){
        
        [_tagsArray addObject:[[ZPAZeppaEventTagSingleton sharedObject] getZeppaTagWithId:[tagId longLongValue]]];
    }
}

/**
 */
-(void)resetScrollViewContentSize
{
//#warning should resize views
    
    float bottomPadding = 0.0f;
    float contentHeight = self.view_infoBaseView.frame.origin.y + self.view_TagsContainer.frame.size.height + self.view_addTagBase.frame.size.height + self.view_baseAddInvites.frame.size.height + bottomPadding;
    
    float availableHeight = self.scrollView_base.frame.size.height;
    
    contentHeight = contentHeight > availableHeight ? contentHeight : availableHeight;
    
    CGSize contentSize = (CGSize){self.scrollView_base.frame.size.width,contentHeight};
    [self.scrollView_base setContentSize:contentSize];
    
    [self updateBaseViewFramesWithOffset:0 withAnimationDuration:0];
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
#pragma mark - UIPickerViewDataSource Methods
//****************************************************

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    // If this is the privacy picker
    if(pickerView == self.privacyPicker){
        return 1;
    }
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    // If this is the privacy picker
    if(pickerView == self.privacyPicker){
        return 2;
    }
    
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
    
    // Assuming this is the privacy picker, switch on the row index to determine the appropriate title
    if(pickerView == self.privacyPicker){
        switch (row){
            case 0:
                return @"Casual";
            case 1:
                return @"Private";
        }
    }
    
    return @"None";
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
    
    
    
    return YES;
}

- (IBAction)doneClicked:(id)sender
{
    NSLog(@"Done Clicked.");
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat heightBeforeResize = self.heightConstraint.constant;
    [self.handler resizeTextViewWithAnimation:YES];
    CGFloat heightAfterResize = self.heightConstraint.constant;
    
    // Check to see if frames should be resized
    if(heightBeforeResize != heightAfterResize){
        [self updateBaseViewFramesWithOffset:(heightAfterResize-heightBeforeResize) withAnimationDuration:0.1];
    }
}


//****************************************************
#pragma mark - Notification
//****************************************************


- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
//    NSDictionary* info = [note userInfo];
//    CGSize _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    float kbHeight = _kbSize.width > _kbSize.height ? _kbSize.height : _kbSize.width;
//    _scrollView_base.contentSize = CGSizeMake(_scrollView_base.bounds.size.width, _scrollView_base.bounds.size.height + kbHeight);
    
//    _scrollView_base.contentSize = CGSizeMake(_scrollView_base.bounds.size.width, _scrollView_base.bounds.size.height - _kbSize.height);
    
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    
//    NSDictionary* info = [note userInfo];
//    CGSize _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    float kbHeight = _kbSize.width > _kbSize.height ? _kbSize.height : _kbSize.width;
//    _scrollView_base.contentSize = CGSizeMake(_scrollView_base.bounds.size.width, _scrollView_base.bounds.size.height - kbHeight);
//        _scrollView_Base.contentSize = CGSizeZero;
    
//    _scrollView_base.contentSize = CGSizeMake(_scrollView_base.bounds.size.width, _scrollView_base.bounds.size.height + _kbSize.height);
    
//    [self resetScrollViewContentSize];
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
    [alertWithTextField textFieldAtIndex:0].placeholder = @"42 Wallaby way, Sydney";
    
    [alertWithTextField show];
}

/*
 * User attempts to set the start time
 */
- (IBAction)btnSelectEventStartTimeTapped:(id)sender {
    
    [self.view layoutIfNeeded];
    
    CGFloat y_offset = 0;
    NSTimeInterval duration = 0.3;
    // Determine if date picker is visible by observing it's height
    if(self.startPickerHeight.constant>0){
        // picker is visible, set and hide
        // Set the start time to the selected time
//        startTime = [[ZPADateHelper sharedHelper] stringFromDate:self.startTimePicker.date withFormat:@"MM/dd/yyyy hh:mm a"];
        self.startBaseHeight.constant=33;
        // TODO: update end time as needed
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
            self.startPickerHeight.constant=0;
            startTime = self.startTimePicker.date;
            
            // Update end time if applicable
            if([startTime timeIntervalSinceDate:endTime] > 0){
                endTime = [NSDate dateWithTimeInterval:(60*60) sinceDate:startTime];
            }
            
            [self updateTimeText];
        }];
        // Animate layout changes
        y_offset = -100;
        
    } else {
        // picker should be made visible
        
        // Set the picker times to the currently visible times
        
        // Animate start picker visible
        self.startPickerHeight.constant=100;
        self.startBaseHeight.constant+=100;
        // Set the current time to the minimum date
        self.startTimePicker.minimumDate = [NSDate date];
        
        // Set the picker time to the start time
        self.startTimePicker.date = startTime;
        
        // Animate the changes
        [UIView animateWithDuration:duration animations:^{
            
            [self.view layoutIfNeeded];
            
        }];
        
        y_offset = 100;
    }

    [self updateBaseViewFramesWithOffset:y_offset withAnimationDuration:duration];

}

- (IBAction)btnSelectEventEndTimeTapped:(id)sender {
    
    [self.view layoutIfNeeded];
    CGFloat y_offset = 0;
    NSTimeInterval duration = 0.3;
    // Determine if date picker is visible by observing it's height
    if(self.endPickerHeight.constant>0){
        // picker is visible, set and hide
        // Set the start time to the selected time
        //        startTime = [[ZPADateHelper sharedHelper] stringFromDate:self.startTimePicker.date withFormat:@"MM/dd/yyyy hh:mm a"];
        
        self.endBaseHeight.constant=33;
        
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
            
            self.endPickerHeight.constant=0;
            
            endTime = self.endTimePicker.date;
            
            // Update end time if applicable
            if([startTime timeIntervalSinceDate:endTime] > 0){
                startTime = [NSDate dateWithTimeInterval:-(60*60) sinceDate:endTime];
                // If current date is later, set it to the current date
                startTime = [startTime laterDate:[NSDate date]];
            }
            
            [self updateTimeText];

        }];
        // Animate layout changes
        
        y_offset = -100;
        
    } else {
        // picker should be made visible
        
        // Set the picker times to the currently visible times
        
        // Animate start picker visible
        self.endBaseHeight.constant+=100;
        self.endTimePicker.minimumDate = [NSDate date];
        self.endTimePicker.date = endTime;
        
        // Animate the layout changes
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
            self.endPickerHeight.constant=100;
        }];
        
        y_offset = 100;
    }
    
    [self updateBaseViewFramesWithOffset:y_offset withAnimationDuration:duration];

}

/*
 * User has selected to change the privacy
 */
 
- (IBAction)btnSelectEventPrivacyTapped:(id)sender {
    
    [self.view layoutIfNeeded];
    
    CGFloat y_offset = 0;
    NSTimeInterval duration = 0.3;
    // Determine if date picker is visible by observing it's height
    if(self.privacyPickerHeight.constant>0){
        // picker is visible, set and hide
        
        self.privacyBaseHeight.constant=33;
        
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
            
            self.privacyPickerHeight.constant=0;
            NSInteger selectedIndex = [self.privacyPicker selectedRowInComponent:0];
            self.lblEventPrivacy.text = (selectedIndex==0?@"Casual":@"Private");
            
        }];
        // Animate layout changes
        
        y_offset = -75;
        
    } else {
        // picker should be made visible
        
        // Set the picker times to the currently visible times
        
        // Animate start picker visible
        self.privacyPickerHeight.constant=75;
        self.privacyBaseHeight.constant+=75;
        NSInteger selectedIndex = [self.lblEventPrivacy.text isEqualToString:@"Casual"]?0:1;
        [self.privacyPicker selectRow:selectedIndex inComponent:0 animated:NO];
        
        // Animate the layout changes
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
            
        }];
        
        y_offset = 75;
    }
    
    [self updateBaseViewFramesWithOffset:y_offset withAnimationDuration:duration];
    
}



- (IBAction)btnAddNewTagTapped:(id)sender {
    
//    [self stopWobble];
    
    
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
    for (GTLZeppaclientapiEventTag * tag in _tagsArray) {
        
        if ([titleString.uppercaseString isEqualToString:tag.tagText.uppercaseString]) {
            
            [ZPAStaticHelper showAlertWithTitle:@"" andMessage:@"Tag already exist"];
            // TODO: set the already existing tag to selected
            return;
            
        }
    }
    GTLZeppaclientapiEventTag *tag = [[GTLZeppaclientapiEventTag alloc]init];
        tag.tagText = titleString;
        tag.ownerId = [[ZPAZeppaEventTagSingleton sharedObject]getCurrentUserId];
      [[ZPAZeppaEventTagSingleton sharedObject] executeInsetEventTagWithEventTag:tag WithCompletion:^(GTLZeppaclientapiEventTag *tag, NSError *error) {
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
            
            if (newView.frame.origin.x+newButton.frame.size.width>self.view_TagsContainer.frame.size.width) {
                newView.frame =CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
                // If another level is being added, update the height constraint of the container
                self.tagContainerHeightConstraint.constant+=newView.frame.size.height;
                NSLog(@"%f",newView.frame.origin.y);
                counter++;
            }
            
        }else{
            [newView setFrame:CGRectMake(0,0,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            NSLog(@"%f",newView.frame.origin.y);
            self.tagContainerHeightConstraint.constant = newView.frame.size.height;
        }
    
        [newView addSubview:newButton];
        [self.view_TagsContainer addSubview:newView];
        [testArray addObject:newView];
        [self updateBaseViewFramesWithOffset:0 withAnimationDuration:0.1];

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
    [self updateBaseViewFramesWithOffset:0 withAnimationDuration:0.1];
    
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




-(void)arrangeButtonWhenCallCellForRowAtIndex{
    
    for (int j=0; j<testArray.count; j++) {
        UIView *view =[testArray objectAtIndex:j];
        UIButton *button = (UIButton *)[view viewWithTag:TAGS_BUTTON_TAG];
        CGRect frame = button.frame;
        
        if (j==0) {
            view.frame=CGRectMake(0,0, frame.size.width+PADDING, frame.size.height+PADDING);
            self.tagContainerHeightConstraint.constant+=view.frame.size.height;
        }
        else{
            UIView *preView =[testArray objectAtIndex:j-1];
            view.frame=CGRectMake(preView.frame.origin.x+preView.frame.size.width, preView.frame.origin.y, frame.size.width+PADDING, frame.size.height+PADDING);
            if (view.frame.origin.x+view.frame.size.width>[[UIScreen mainScreen] bounds].size.width) {
                view.frame=CGRectMake(0, view.frame.origin.y+view.frame.size.height, view.frame.size.width, view.frame.size.height);
                counter++;
                // Indicates a new line is needing to be made, update the tag container height here
                self.tagContainerHeightConstraint.constant+=view.frame.size.height;
                
            }
        }
        [self.view_TagsContainer addSubview:view];
    }
    // Also account for difference in description height here.
    CGFloat desc_dif = self.heightConstraint.constant - DESCRIPTION_DESIGN_HEIGHT;
    [self updateBaseViewFramesWithOffset:desc_dif withAnimationDuration:0.1];
}

/*
 * Update the frame sizes of all views to account for a change in subview size
 */
-(void)updateBaseViewFramesWithOffset: (CGFloat) y_diff withAnimationDuration: (NSTimeInterval) duration {
    
    // Notify all container views they may need to update their constraints
    
    // Animate pending layout changes
    [UIView animateWithDuration:duration animations:^{
        
        CGFloat y = 0;
        NSLog(@"info base y origin %f",y);
        
        self.view_infoBaseView.frame = CGRectMake(self.view_infoBaseView.frame.origin.x, y, self.scrollView_base.contentSize.width, self.view_infoBaseView.frame.size.height+y_diff);

        y+=self.view_infoBaseView.frame.size.height;
        NSLog(@"Tag container y origin %f",y);
        
        self.view_TagsContainer.frame = CGRectMake(self.view_infoBaseView.frame.origin.x, y, self.scrollView_base.contentSize.width, self.tagContainerHeightConstraint.constant);
        
        y+=self.tagContainerHeightConstraint.constant;
        NSLog(@"Add Tag Base y origin %f",y);
        self.view_addTagBase.frame = CGRectMake(self.view_addTagBase.frame.origin.x, y, self.scrollView_base.contentSize.width, self.view_addTagBase.frame.size.height);
        
        y+=self.view_addTagBase.frame.size.height;
        NSLog(@"Add invite y origin %f",y);
        self.view_baseAddInvites.frame = CGRectMake(self.view_baseAddInvites.frame.origin.x, y, self.scrollView_base.contentSize.width, self.view_baseAddInvites.frame.size.height);
        
        y += self.view_baseAddInvites.frame.size.height;

        
        
//        // Adjust the content view size
        _scrollView_base.contentSize = CGSizeMake(self.scrollView_base.frame.size.width,  y);
        
        
    }];

    
}


-(IBAction)newButtonAction:(UIButton *)sender{
    
    
    NSLog(@"New Button Action for: %@", sender.currentTitle);
    
    if(sender.backgroundColor == [UIColor whiteColor]){
        
    for (GTLZeppaclientapiEventTag * tag in _tagsArray) {
            
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
        
        for (GTLZeppaclientapiEventTag * tag in _tagsArray) {
            
            if ([sender.titleLabel.text isEqualToString:tag.tagText]) {
                [_eventTagIdsArray removeObject:tag.identifier];
                [selectedTagBtn removeObject:sender];
            }
            
        }

    }
    
    
    
   // [self executeZeppaTagFollowApi:sender];
}

-(void )executeZeppaTagFollowApi:(UIButton *)tagButton{
    
    
    GTLZeppaclientapiEventTagFollow * tagFollow = [[GTLZeppaclientapiEventTagFollow alloc]init];
    
    
    
    for (GTLZeppaclientapiEventTag * tag in _tagsArray) {
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
    
    GTLZeppaclientapiZeppaEvent *zeppaEvent = [[GTLZeppaclientapiZeppaEvent alloc] init];
    
    
    [zeppaEvent setHostId:currentUser.endPointUser.identifier];
    [zeppaEvent setTitle:_txtEventTitle.text];
    [zeppaEvent setDescriptionProperty:_textView_Description.text];
    [zeppaEvent setPrivacy:[_lblEventPrivacy.text uppercaseString]];
    
    [zeppaEvent setGuestsMayInvite:[NSNumber numberWithInt:_checkBox.checked]];
    
    double startTimeStamp = ([startTime timeIntervalSince1970])*1000;
    
    NSNumber * startTimee = [NSNumber numberWithDouble:startTimeStamp];
    

    double endTimeStamp = ([endTime timeIntervalSince1970])*1000;
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
        
        alert = [[UIAlertView alloc]initWithTitle:@"Add Tags" message:@"Tap to add a few tags (blue bubbles) first. This is how Zeppa recommends your events to people you mingle with" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];
    
        
    }else{
        
        alert = [[UIAlertView alloc]initWithTitle:@"Posting Event" message:@"One Moment,Please" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [alert show];

    
    GTLQueryZeppaclientapi *insertZeppaEventTask = [GTLQueryZeppaclientapi queryForInsertZeppaEventWithObject:zeppaEvent idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [[self zeppaEventService] executeQuery:insertZeppaEventTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaEvent * event, NSError *error) {
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
-(GTLServiceZeppaclientapi *) zeppaEventService {
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    
    // Set Auth that is held in the delegate
        
    
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


-(BOOL)isValidEvent:(GTLZeppaclientapiZeppaEvent *)event{
    
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


/*
 * Update the times shown to the user
 */
- (void) updateTimeText {
    // Set the default start time
    _lblEventStartTime.text = [self displayDateWithRequiredFormat:startTime];
    // set the default end time
    _lblEventEndTime.text = [self displayDateWithRequiredFormat:endTime];
}

/*
 * Format date string for easier readability
 */
-(NSString *)displayDateWithRequiredFormat:(NSDate *)inputDate{
    
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
        
    }else if ([inputDate timeIntervalSinceDate:[NSDate date]] < (1000 * 60 * 60 * 24 * 7) ){
        
        timeToDisplayString = [NSString stringWithFormat:@"%@ %@",[[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"EEEE"],[[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"hh:mm a"]];
        
    }else{
        timeToDisplayString = [[ZPADateHelper sharedHelper] stringFromDate:inputDate withFormat:@"MM/dd/yyyy hh:mm a"];
    }
    return timeToDisplayString;
}


@end
