//
//  ZPAFeedbackVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 20/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAFeedbackVC.h"
#import "GTLZeppafeedbackendpointZeppaFeedback.h"
#import "GTLQueryZeppafeedbackendpoint.h"
#import "GTLServiceZeppafeedbackendpoint.h"
#import "ZPAAuthenticatonHandler.h"
#import <AudioToolbox/AudioServices.h>

#define RATE_STAR_WIDTH 28

@interface ZPAFeedbackVC ()
@property (readonly) GTLServiceZeppafeedbackendpoint *zeppaFeedbackService;
@property (nonatomic, assign) UITextView *currentTextView;
@property (nonatomic, assign) float rating;
@property (nonatomic, assign,getter = isFirstTime) BOOL firstTime;
@end

@implementation ZPAFeedbackVC

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [ZPAStaticHelper backgroundTextureColor];
    self.title = NSLocalizedString(@"Feedback", nil);
    
    self.firstTime = YES;
    
    [self configureScreen];
    
    [self registerForNotifications];
    
    
}

-(void)viewDidAppear:(BOOL)animated
{
 
    [super viewDidAppear:animated];
    if (self.isFirstTime) {
        self.firstTime = NO;
        [self resetScrollViewContentSize];

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [self unregisterFromNotifications];
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
#pragma mark - Action Methods
//****************************************************

- (IBAction)btnRateZeppaTapped:(UIButton *)sender {
    
    self.rating = sender.tag; ///Tag is set according to stars rating
    [self fillStarsUsingRatingValue:self.rating];
    
    ///Set Slider accordingly
    self.slider_StarRating.value = self.rating;
    
}

- (IBAction)rateZeppaSliderValueChanged:(id)sender {
    
    self.rating = [(UISlider *)sender value];
    [self fillStarsUsingRatingValue:self.rating];
    
}

- (IBAction)btnSendFeedbackTapped:(id)sender {
    
    
    //AudioServicesPlaySystemSound (kSystemSoundID_Vibrate) ;
    ///@todo: Make A send feedback API call
    [self sendFeedbackApi];
}

//****************************************************
#pragma mark - Private Methods
//****************************************************

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



-(void)configureScreen
{
    
    ///Configure Top Dialog
    self.lblDialogBubble.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.lblDialogBubble.layer.borderWidth = 1.0f;
    self.lblDialogBubble.layer.cornerRadius = 15.0f;
    self.lblDialogBubble.layer.masksToBounds = YES;
    
    ///Configure Subject View
    self.view_SubjectContainer.layer.borderColor = [ZPAStaticHelper zeppaThemeColor].CGColor;
    self.view_SubjectContainer.layer.borderWidth = 1.0f;
    self.view_SubjectContainer.layer.cornerRadius = 5.0f;
    self.view_SubjectContainer.layer.masksToBounds = YES;
    
    ///Change Color of placeholder text of subject textfield
    if ([self.txtSubject respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [ZPAStaticHelper zeppaThemeColor];
        NSString *placeHolderText = NSLocalizedString(@"Subject", nil);
        self.txtSubject.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolderText attributes:@{NSForegroundColorAttributeName: color}];
    }
    else {
        
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        
    }
    
    ///Configure Comment View
    self.txtView_Comment.layer.borderColor = [ZPAStaticHelper zeppaThemeColor].CGColor;
    self.txtView_Comment.layer.borderWidth = 1.0f;
    self.txtView_Comment.layer.cornerRadius = 5.0f;
    self.txtView_Comment.layer.masksToBounds = YES;
    
    
    ///Configure Send feedback Button
    self.btnFeedback.layer.borderColor = [UIColor colorWithRed:40.0f/255 green:152.0f/255 blue:199.0f/255 alpha:1.0f].CGColor;
    self.btnFeedback.layer.borderWidth = 1.0f;
    self.btnFeedback.layer.cornerRadius = 5.0f;
    self.btnFeedback.layer.masksToBounds = YES;
    
    
}

-(void)resetScrollViewContentSize
{
    float bottomPadding = 20.0f;
    float contentHeight = self.btnFeedback.frame.origin.y + self.btnFeedback.frame.size.height + bottomPadding;
    
    float availableHeight = self.scrollView_Base.frame.size.height;
    
    contentHeight = contentHeight > availableHeight ? contentHeight : availableHeight;
    
    CGSize contentSize = (CGSize){self.scrollView_Base.frame.size.width,contentHeight};
    [self.scrollView_Base setContentSize:contentSize];
    
    
}

-(void)fillStarsUsingRatingValue:(float)rating
{
    
    float starBGFillerWidth = rating * RATE_STAR_WIDTH;
    CGRect starBGFillerFrame = self.view_StarRatingBackgroundFiller.frame;
    
    if (starBGFillerWidth < 0) {
        starBGFillerWidth = 0;
    }
    else if (starBGFillerWidth > self.imageView_RatingStars.frame.size.width)
    {
        starBGFillerWidth = self.imageView_RatingStars.frame.size.width;
    }
    
    starBGFillerFrame.size.width = starBGFillerWidth;
    self.view_StarRatingBackgroundFiller.frame = starBGFillerFrame;
    
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
    float topPadding = 20.0f;
    [self.scrollView_Base setContentOffset:CGPointMake(self.scrollView_Base.contentOffset.x,textField.superview.frame.origin.y - topPadding) animated:YES];
    return YES;
    
}

//****************************************************
#pragma mark - UITextViewDelegate Methods
//****************************************************
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    _lblCommentPlaceholder.hidden = (newLength == 0) ? NO : YES;
    
   // return (newLength > [ZPAStaticHelper getMaxCharacterInTextField]) ? NO : YES;
    
    return YES;
    
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _currentTextView = textView;
    
    [ZPAStaticHelper setContentOffSetof:textView insideInView:_scrollView_Base];
    
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
    
}

//****************************************************
#pragma mark - Notification
//****************************************************
- (void)keyboardWillShow:(NSNotification*)note {
    // Scroll the view to the comment text box
    NSDictionary* info = [note userInfo];
    CGSize _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    float kbHeight = _kbSize.width > _kbSize.height ? _kbSize.height : _kbSize.width;
    _scrollView_Base.contentSize = CGSizeMake(_scrollView_Base.bounds.size.width, _scrollView_Base.bounds.size.height + kbHeight);
    
}

-(void)keyboardWillHide:(NSNotification *)note
{
    //    _scrollView_Base.contentSize = CGSizeZero;
    [self resetScrollViewContentSize];
}
//*******************************
#pragma mark - Api Call Method
//*******************************
- (void)sendFeedbackApi{
   /*
    For future use
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    */
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber* identifier = [f numberFromString:[[NSUserDefaults standardUserDefaults] valueForKey:kCurrentZeppaUserId]];
    
    NSString * rating= [NSString stringWithFormat:@"%.02f",_rating];
    
    GTLZeppafeedbackendpointZeppaFeedback *feedback = [[GTLZeppafeedbackendpointZeppaFeedback alloc] init];
    
    [feedback setUserId:identifier];
    [feedback setReleaseCode:@"1.0.0"];
    [feedback setRating:[f numberFromString:rating]];
    [feedback setDeviceType:@"iOS"];
    [feedback setSubject:_txtSubject.text];
    [feedback setFeedback:_txtView_Comment.text];
    
    GTLQueryZeppafeedbackendpoint *insertFeedbackTask = [GTLQueryZeppafeedbackendpoint queryForInsertZeppaFeedbackWithObject:feedback];
    
    [[self zeppaFeedbackService] executeQuery:insertFeedbackTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppafeedbackendpointZeppaFeedback *response, NSError *error) {
        //
        
        if(error) {
            NSLog(@"Error sending feedback %@",error.description);
            
        } else if( response.identifier){
            
        [ZPAStaticHelper showAlertWithTitle:nil andMessage:@"Feedback Send Successfully"];
            
        } else {
            NSLog(@"Insert Operation Unsuccessful");
        }
        
    }];
    
}

-(GTLServiceZeppafeedbackendpoint *)zeppaFeedbackService
{
    ///Create ZeppaUserEndPoint Service
    static GTLServiceZeppafeedbackendpoint *zeppaFeedbackService = nil;
    if (!zeppaFeedbackService) {
        
        zeppaFeedbackService = [[GTLServiceZeppafeedbackendpoint alloc]init];
        zeppaFeedbackService.retryEnabled = YES;
        [zeppaFeedbackService setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    }
    return zeppaFeedbackService;
}
@end
