//
//  ZPAReportEventVC.m
//  Zeppa
//
//  Created by Dheeraj on 12/11/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPARepostEventVC.h"

#define SCROLLVIEW_HEIGHT 568
#define VIEW_SECONDINITIAL 405
#define VIEW_BASE_TAGFEATURE 95




#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define PADDING 8
#define TAGS_BUTTON_TAG 100
#define HEIGHTEXTEND 33
#define WIDTHPADDING 5
#define TAGS_BASEVIEW_TAG_VALUE 100

@interface ZPARepostEventVC (){
    
    NSMutableArray *temp;
    NSMutableArray *testArray;
    ZPAMyZeppaUser *currentUser;
    int counter;
}

@property (nonatomic, strong)UITextView  *currentTextView;
@end

@implementation ZPARepostEventVC
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
    [self makeDesignForAllControl];
    [self registerForNotifications];
    
    
    
    testArray = [NSMutableArray array];
    counter = 1;
    for (int i = 0; i<15; i++)
    {
        UIButton *newButton =[[UIButton alloc]init];
        NSString *string = @"Temp Array";
        [newButton setTitle:string forState:UIControlStateNormal];
        [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newButton setBackgroundColor:[UIColor colorWithRed:37/255.0f green:161/255.0f blue:225/255.0f alpha:1.0f]];
        
        [newButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [newButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [newButton.layer setBorderWidth:1.0];
        [newButton.layer setBorderColor:[[UIColor clearColor]CGColor]];
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
    }
    
    [self arrangeButtonWhenCallCellForRowAtIndex];
    // Do any additional setup after loading the view.
}
-(void)dealloc{
    [self unregisterFromNotifications];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///******************************************
#pragma mark - InitialSetting Method
///******************************************

-(void)makeDesignForAllControl{
    
    
    self.title = @"Repost Event";
    
    _scrollView_Base.contentSize = CGSizeMake(320, 568);
    
    [_descriptionTextView.layer setCornerRadius:3.0];
    [_descriptionTextView.layer setBorderColor:[[ZPAStaticHelper zeppaThemeColor] CGColor]] ;
    [_descriptionTextView.layer setBorderWidth:1.0];
    [_descriptionTextView.layer setMasksToBounds:YES];
    
    [_btn_addNewTag.layer setCornerRadius:3.0];
    [_btn_addNewTag.layer setBorderColor:[[ZPAStaticHelper zeppaThemeColor] CGColor]] ;
    [_btn_addNewTag.layer setBorderWidth:1.0];
    [_btn_addNewTag.layer setMasksToBounds:YES];
}

///******************************************
#pragma mark - Private Method
///******************************************

- (IBAction)addButtonTapped:(UIButton *)sender {
    
    
    [self stopWobble];
    if (![_txt_NewTag.text isEqualToString:@""]) {
        UIButton *newButton =[[UIButton alloc]init];
        [newButton setTitle:_txt_NewTag.text forState:UIControlStateNormal];
        [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newButton setBackgroundColor:[UIColor colorWithRed:37/255.0f green:161/255.0f blue:225/255.0f alpha:1.0f]];
        
        [newButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [newButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        [newButton.layer setBorderWidth:1.0];
        [newButton.layer setBorderColor:[[UIColor clearColor]CGColor]];
        [newButton.layer setCornerRadius:3.0];
        [newButton.layer setMasksToBounds:YES];
        
        CGSize textSize = [_txt_NewTag.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
        
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
            [newView setFrame:CGRectMake(0,0,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            NSLog(@"%f",newView.frame.origin.y);
        }
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = .5;
        [newButton addGestureRecognizer:longPress];
        
        [newView addSubview:newButton];
        [self.view_TagContainer addSubview:newView];
        [testArray addObject:newView];
        [self updateAllViewsFrames];
    }
    _txt_NewTag.text=@"";
    
    
    
    
    
}

///*************************************************
#pragma mark - Tag Private Method
///*************************************************

- (void)startWobble{
    for (UIView *btn in _view_TagContainer.subviews) {
        btn.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-2));
    }
    [UIView animateWithDuration:0.10
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                         for (UIView *btn in _view_TagContainer.subviews) {
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
        [_view_TagContainer addSubview:view];
    }
    [self updateAllViewsFrames];
}
-(void)updateAllViewsFrames{
    
    
    _scrollView_Base.contentSize = CGSizeMake(320, SCROLLVIEW_HEIGHT+(counter*HEIGHTEXTEND));

    
    
    _view_baseBelowLocation.frame = CGRectMake(_view_baseBelowLocation.frame.origin.x, _view_baseBelowLocation.frame.origin.y, _view_baseBelowLocation.frame.size.width,VIEW_SECONDINITIAL+counter*HEIGHTEXTEND);
    _view_baseTagsFeature.frame = CGRectMake(_view_baseTagsFeature.frame.origin.x, _view_baseTagsFeature.frame.origin.y, _view_baseTagsFeature.frame.size.width, VIEW_BASE_TAGFEATURE+counter*HEIGHTEXTEND);
    
    _view_TagContainer.frame = CGRectMake(_view_TagContainer.frame.origin.x, _view_TagContainer.frame.origin.y, _view_TagContainer.frame.size.width, counter*HEIGHTEXTEND);
    
    
    _view_baseInvites.frame = CGRectMake(_view_baseInvites.frame.origin.x,_view_baseTagsFeature.frame.origin.y+_view_baseTagsFeature.frame.size.height , _view_baseInvites.frame.size.width, _view_baseInvites.frame.size.height);
    

    
    
}
///*****************************************************
#pragma mark - TextView Delegate Method
///*****************************************************

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSUInteger newLength = [textView.text length] + [text length] - range.length;
    
    _descriptionLabel.hidden = (newLength == 0) ? NO : YES;
   
    return (newLength > [ZPAStaticHelper getMaxCharacterInTextField]) ? NO : YES;
    
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
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
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
   
    [self.scrollView_Base setContentOffset:CGPointZero];
    
}

///*********************************************
#pragma mark - TextField Delegate Method
///*********************************************

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    
    return (newLength > [ZPAStaticHelper getMaxCharacterInTextField]) ? NO : YES;

}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [ZPAStaticHelper setContentOffSetof:textField insideInView:_scrollView_Base];
    
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return   [textField resignFirstResponder];
}

@end
