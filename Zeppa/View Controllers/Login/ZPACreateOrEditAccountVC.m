//
//  ZPACreateOrEditAccountVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 29/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPACreateOrEditAccountVC.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPAZeppaEventTagSingleton.h"
#import "ZPAUserInfoCell.h"
#import "ZPAApplication.h"
#import "ZPAUserCalendarNameCell.h"
#import "ZPAAuthenticatonHandler.h"
#import "UIImageView+WebCache.h"
#import "Downloader.h"


#import "GTLZeppaclientapiZeppaUserInfo.h"
#import "GTLCalendarCalendarListEntry.h"
#import "GTLCalendar.h"
#import "GTLQueryZeppaclientapi.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaUser.h"

#import "GTLZeppaclientapi.h"
#import "GTLZeppaclientapiPhotoInfo.h"
#import <Google/SignIn.h>


@import EventKit;

#define TABLE_SEC_INDEX_USER_INFO           0
#define TABLE_SEC_INDEX_GOOGLE_CALENDARS    1
#define TABLE_SEC_INDEX_iOS_CALENDARS       2

#define TOTAL_SECTIONS  3

#define ACTION_INDEX_CAMERA             0
#define ACTION_INDEX_PHOTO_GALLERY      1

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define PADDING 8
#define TAGS_BUTTON_TAG 100
#define WIDTHPADDING 5


typedef NS_OPTIONS(NSUInteger, CalendarFecthedStatus) {
    CalendarFecthedStatusNone   = 0,
    CalendarFecthedStatusGoogle = 1 << 0,
    CalendarFecthedStatusiOS    = 1 << 1,
};

@interface ZPACreateOrEditAccountVC ()<UITextFieldDelegate, UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,DownloaderResponse>

@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, strong)NSMutableArray *tagsArray;
@property (nonatomic, assign)CalendarFecthedStatus calendarFetchStatus;
@property (readonly) GTLServiceZeppaclientapi *service;

@end

@implementation ZPACreateOrEditAccountVC{
    
    NSMutableArray *_tagsTempArray;
}

//****************************************************
#pragma mark - View Life Cycle
//****************************************************
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"Init with name %@", nibBundleOrNil);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"View did load");
    [super viewDidLoad];
    [self initialization];
    [self configure];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    if (_vcDisplayMode == VCDisplayModeEditAccount) {
        // This is an edit account situation
        self.title = @"Edit Account";
       _tagsArray = [[[ZPAZeppaEventTagSingleton sharedObject] getMyTags] mutableCopy];
        _view_TagContainer.hidden = (_tagsArray.count>0)?NO:YES;
        for (GTLZeppaclientapiEventTag *tag in _tagsArray) {
            
            [self showTagButtonWithTitleString:tag.tagText];
           
        }
    }else{
        // this is a create account situation
        self.title = @"Create Account";
        _view_TagContainer.hidden = YES;
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
    [[NSNotificationCenter defaultCenter]removeObserver:self];

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
    
    
//    NSDictionary* info = [note userInfo];
//    CGSize _kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    float kbHeight = _kbSize.width > _kbSize.height ? _kbSize.height : _kbSize.width;
  //  self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height + kbHeight);
    
    
}
-(void)keyboardWillHide:(NSNotification *)note
{
    //self.tableView.contentSize = CGSizeMake(self.tableView.contentSize.width, self.tableView.contentSize.height);
   // self.tableView.contentOffset=CGPointZero;
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return [textField resignFirstResponder];
}


//-(void)textFieldDidBeginEditing:(UITextField *)textField{
//    
//    UIToolbar * keyboardToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
//    keyboardToolBar.barStyle = UIBarStyleBlackTranslucent;
//    
//    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneClicked:)];
//    
//    [keyboardToolBar setItems: [NSArray arrayWithObjects:flexibleSpace,doneButton,nil]];
//    
//    textField.inputAccessoryView = keyboardToolBar;
//   
//}
//
//- (IBAction)doneClicked:(id)sender
//{
//    NSLog(@"Done Clicked.");
//    [self.view endEditing:YES];
//}
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
- (IBAction)btnCancelTapped:(UIBarButtonItem *)sender {
    
    //preform two task 1: clear email form user default
    //2: clear ZeppaId form user default.
    if(_vcDisplayMode == VCDisplayModeCreateAccount){
        
        [[ZPAAuthenticatonHandler sharedAuth] logout];
    }
    [[ZPAZeppaEventTagSingleton sharedObject] notificationChange];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    
}
-(IBAction)btnDoneTapped:(UIBarButtonItem *)sender{
    
    [self.view endEditing:YES];
    [self showActivity];
    if (_vcDisplayMode == VCDisplayModeCreateAccount) {
        
        [self callNewZeppaUserApi];
    }
    if (_vcDisplayMode == VCDisplayModeEditAccount) {
        
        [[ZPAZeppaEventTagSingleton sharedObject] notificationChange];
        
        [self callUpdateZeppaUserApi];
        
    }
    
}
-(IBAction)btnEditProfilePicTapped:(UIButton *)sender
{
    ///Display Action sheet to show options to edit image
    UIActionSheet *editProfilePicActionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Camera",nil),NSLocalizedString(@"Photo Gallery", nil), nil];
    [editProfilePicActionSheet showInView:self.view];
}
///**********************************************
#pragma mark Configure Method
///**********************************************
-(void)configure
{
    // Do any additional setup after loading the view.
    ///Set background color of uiview
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.view setBackgroundColor:[ZPAStaticHelper backgroundTextureColor]];
    
    //Set ImageView Bordar and CornerRadius
    self.userImageView.layer.borderColor = [ZPAStaticHelper greyBorderColor].CGColor;
    self.userImageView.layer.borderWidth = 1.0f;
    self.userImageView.layer.cornerRadius = 10.0f;
    self.userImageView.layer.masksToBounds = YES;
    
    ///Reset CalendarFetchStatus
    self.calendarFetchStatus = CalendarFecthedStatusNone;
    
    // Determine if the user is creating or editing account
    if (_vcDisplayMode == VCDisplayModeEditAccount) {
        // Set values based on Zeppa's held object
        _giveName_Txt.text = _user.endPointUser.userInfo.givenName;
        _familyName_Txt.text = _user.endPointUser.userInfo.familyName;
        _email_Txt.text = _user.endPointUser.authEmail;
        _contactNo_Txt.text = [self getFormattedNumber:_user.endPointUser.phoneNumber];
    
        _imageUrl = _user.endPointUser.userInfo.imageUrl;
        if(_imageUrl){
            NSURL *profileImageURL = [NSURL URLWithString:_imageUrl];
            [_userImageView setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                ///Write any image related code here
            }];
        }
        
    } else {
        // This is a create account instance
        GIDGoogleUser *currentUser = [[GIDSignIn sharedInstance] currentUser];
        
        // Set the auth email, this is definitely known
        _email_Txt.text = currentUser.profile.email;
        
        // Set the user's name, if possible
        NSString *name = currentUser.profile.name;
        if(name && name.length>0){
            // Identify the first space
            
            NSRange range = [name rangeOfString:@" "];
            NSString *givenName = [name substringToIndex:range.length];
            _giveName_Txt.text = givenName;
            if(range.length > 0 && range.length < name.length){
                NSString *familyName = [name substringFromIndex:range.length];
                _familyName_Txt.text = familyName;
            }
        }
        
        // If this user has an associated image
        if(currentUser.profile.hasImage) {
            NSURL *profileImageURL = [currentUser.profile imageURLWithDimension:_userImageView.frame.size.height];
            [_userImageView setImageWithURL:profileImageURL placeholderImage:[ZPAAppData sharedAppData].defaultUserImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                ///Write any image related code here
            }];
            // Hang onto the url
            _imageUrl = profileImageURL.absoluteString;
        }
        
    }

    
    [self registerForNotifications];
}
-(void)dismissKeyboard {
    [_contactNo_Txt resignFirstResponder];
    [_familyName_Txt resignFirstResponder];
    [_giveName_Txt resignFirstResponder];
}
///**********************************************
#pragma mark - Initialization Method
///**********************************************
-(void)initialization{
    
    _tagsArray = [NSMutableArray array];
    _tagsTempArray = [NSMutableArray array];
}
///*************************************************
#pragma mark - Tag Private Method
///*************************************************
-(void)showTagButtonWithTitleString:(NSString *)title{
    
    if (![title isEqualToString:@""]) {
        
      
//        title = [title stringByReplacingOccurrencesOfString:@" " withString:@""];
//        title= title.capitalizedString;
        UIButton *newButton =[[UIButton alloc]init];
        [newButton setTitle:title forState:UIControlStateNormal];
        [newButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [newButton setBackgroundColor:[ZPAStaticHelper zeppaThemeColor]];
        
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
        
        self.tcHeightConstraint.constant = 0;
        if (_tagsTempArray.count!=0) {
            UIView *lastView =(UIView *)[_tagsTempArray lastObject];
            [newView setFrame:CGRectMake(lastView.frame.origin.x+lastView.frame.size.width,lastView.frame.origin.y,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            
            if (newView.frame.origin.x+newButton.frame.size.width>self.view.frame.size.width) {
                newView.frame =CGRectMake(PADDING, newView.frame.origin.y+newView.frame.size.height, newView.frame.size.width, newView.frame.size.height);
                self.tcHeightConstraint.constant += newView.frame.size.height;
            }
            
        }else{
            [newView setFrame:CGRectMake(PADDING,PADDING,textSize.width+2*PADDING,textSize.height+2*PADDING)];
            self.tcHeightConstraint.constant = newView.frame.size.height;
        }
        
        //newButton.tag = DELETE_BUTTON_TAG;
        [newView addSubview:newButton];
        [_view_TagContainer addSubview:newView];
        [_tagsTempArray addObject:newView];
    }
    
    [self setCrossButton];
    
    [self updateContentViewSize];

}

-(void)setCrossButton
{
    
    for (UIView *view in _tagsTempArray) {
        UIButton *button = (UIButton*)[view viewWithTag:TAGS_BUTTON_TAG];
        
        UIButton *crssBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30 , 20)];
       // [crssBtn setBackgroundColor:[UIColor redColor]];
        UIButton *crossButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        
        [crossButton setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        crossButton.center=CGPointMake(button.frame.origin.x, button.frame.origin.y);
        
        [crssBtn addTarget:self action:@selector(deleteButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:crossButton];
        [view addSubview:crssBtn];
    }
    [self startWobble];
    
}




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
- (IBAction)deleteButton:(UIButton *)sender {
    
    UIView *delectButtonBaseView =(UIButton *)sender.superview;
    delectButtonBaseView.hidden=YES;
  
    UIButton *deleteButton = (UIButton *)[delectButtonBaseView viewWithTag:TAGS_BUTTON_TAG];
    
    for (GTLZeppaclientapiEventTag *tag in _tagsArray) {
        
        if ([tag.tagText isEqualToString:deleteButton.titleLabel.text]) {
            
            NSLog(@"Delete: %@",deleteButton.titleLabel.text);
           [[ZPAZeppaEventTagSingleton sharedObject]executeRemoveRequestWithIdentifier:[tag.identifier longLongValue]];
            [[ZPAZeppaEventTagSingleton sharedObject]removeZeppaEventTag:tag];
            break;
        }
        
        
    }
    for (int i=0; i<_tagsTempArray.count; i++) {
        if (delectButtonBaseView==[_tagsTempArray objectAtIndex:i]) {
            break;
        }
    }
    [_tagsTempArray removeObject:delectButtonBaseView];
   
    
    NSMutableArray *tempArray = [NSMutableArray array];
    tempArray = [_tagsTempArray mutableCopy];
    UIView *view;
    self.tcHeightConstraint.constant = 0;
    for (int j=0; j<tempArray.count; j++) {
         view =[tempArray objectAtIndex:j];
        UIButton *button = (UIButton *)[view viewWithTag:TAGS_BUTTON_TAG];
        CGRect frame = button.frame;
        
        if (j==0) {
            view.frame=CGRectMake(PADDING, PADDING, frame.size.width+PADDING, frame.size.height+PADDING);
            self.tcHeightConstraint.constant = view.frame.size.height;
        }
        else{
            UIView *preView =[tempArray objectAtIndex:j-1];
            view.frame=CGRectMake(preView.frame.origin.x+preView.frame.size.width, preView.frame.origin.y, frame.size.width+PADDING, frame.size.height+PADDING);
            if (view.frame.origin.x+view.frame.size.width>self.view.frame.size.width) {
                view.frame=CGRectMake(PADDING, view.frame.origin.y+view.frame.size.height, frame.size.width+PADDING, frame.size.height+PADDING);
                self.tcHeightConstraint.constant += view.frame.size.height;
            }
        }
        
    }
    
    [self updateContentViewSize];
}
-(void)updateContentViewSize{
    
    // Update the frame constraints and animate the changes
    _view_TagContainer.frame = CGRectMake(_view_TagContainer.frame.origin.x, _view_TagContainer.frame.origin.y, self.view.frame.size.width, self.tcHeightConstraint.constant);
    _baseScrollView.contentSize = CGSizeMake(0, _view_TagContainer.frame.origin.y+_view_TagContainer.frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
    
}
//****************************************************
#pragma mark - Private Methods
//****************************************************
-(NSString *)getFileNameFromEmail:(NSString *)email{
    
    NSString *fileName = email;
    fileName = [[fileName componentsSeparatedByString:@"@"] objectAtIndex:0];
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"] invertedSet];
    fileName = [[fileName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    fileName = [fileName stringByAppendingString:[NSString stringWithFormat:@"-%lld.jpg",(long long)([ZPADateHelper currentTimeMillis])]];
    return fileName;
    
    
}
//*****************************************************
#pragma mark - Downloader Delegate
//*****************************************************
-(void)downloader:(Downloader*)downloader dataDownloaded:(NSData*)data{
    
    
    [self performSelectorOnMainThread:@selector(fetchedData:)
                           withObject:data waitUntilDone:YES];
    
    
}

-(void)downloader:(Downloader*)downloader errorDownloading:(NSError*)error{
    
    
    
}
-(void)downloader:(Downloader*)downloader responseRecieved:(NSURLResponse*)response{
    
    // NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    // NSLog(@"Response Code:%ld",(long)[httpResponse statusCode]);
    
}
-(void)beginDownloadingWithDownloader:(Downloader*)downloader{
    
    
    
    
}
-(void)downloader:(Downloader *)downloader progreessPercentage:(float )progress{
    
    //   NSLog(@"%f",progress);
    
}

- (void)fetchedData:(NSData *)responseData {
    
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    
    if ([json objectForKey:@"blobKey"] && [json objectForKey:@"servingUrl"]) {
        
        NSString *blobKey = [json objectForKey:@"blobKey"];
        NSString *servingUrl = [json objectForKey:@"servingUrl"];
        [self callProfilePhotoApiWithBlobKey:blobKey andservingUrl:servingUrl];
        
    }
}
//****************************************************
#pragma mark - UIActionSheetDelegate Methods
//****************************************************
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == ACTION_INDEX_CAMERA) {
        ///Display Camera
        NSLog(@"Camera tapped");
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera animated:YES];
        
    }
    else if (buttonIndex == ACTION_INDEX_PHOTO_GALLERY){
    
        ///Display Photo Gallery
        NSLog(@"Gallery Tapped");
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum animated:YES];
        
    }
    
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType animated:(BOOL)animated
{
    
   UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:animated completion:nil];
 
}

//****************************************************
#pragma mark - UIImagePickerControllerDelegate
//****************************************************

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    UIImagePickerControllerSourceType pickerSourceType = picker.sourceType;
    if (pickerSourceType == UIImagePickerControllerSourceTypeCamera) {
        
        if (image.imageOrientation == UIImageOrientationUp
            ||image.imageOrientation == UIImageOrientationDown
            ||image.imageOrientation == UIImageOrientationLeft) {
            
            image = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:UIImageOrientationRight];
            
        }
        
        
        //Resize Image and save it in retinal quality
//        UIImage * resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(view_Overlay.frame.size.width * 2, view_Overlay.frame.size.height * 2) interpolationQuality:kCGInterpolationHigh];
        
        
        
    }
    else{
        
        //        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
        
        //Resize Image and save it in retinal quality
//        UIImage * resizedImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(view_Overlay.frame.size.width * 2, view_Overlay.frame.size.height * 2) interpolationQuality:kCGInterpolationHigh];
        
//        NSLog(@"resized image size = %f,%f",resizedImage.size.width,resizedImage.size.height);
        
        
     }
    
    _userImageView.image = image;
    _user.image = image;
    [self uploadPhotoToUser:image];
   
    [self dismissViewControllerAnimated:NO completion:^{
        
        
    }];

}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [self dismissViewControllerAnimated:NO completion:^{
        
        
    }];
    
}
//****************************************************
#pragma mark - Activity Methods
//****************************************************
-(void)showActivity{
    [_activity_Loading startAnimating];
    [self.navigationController.navigationBar setUserInteractionEnabled:NO];
    self.view.userInteractionEnabled = NO;
    
}
-(void)hideActivity{
    
    [_activity_Loading stopAnimating];
    [self.navigationController.navigationBar setUserInteractionEnabled:YES];
    self.view.userInteractionEnabled = YES;
}

///*************************************
#pragma mark - ZeppaEndUser Api Methods
///*************************************
///Create new Zeppa user
-(void)callNewZeppaUserApi{
    
    NSString * phoneStr = [self getPrimaryUnformattedNumber:_contactNo_Txt.text];
    
    NSLog(@"%@",_user.endPointUser.userInfo.imageUrl);
    GTLZeppaclientapiZeppaUser *zeppaUser = [[GTLZeppaclientapiZeppaUser alloc] init];
    GTLZeppaclientapiZeppaUserInfo *userInfo = [[GTLZeppaclientapiZeppaUserInfo alloc] init];
    
    [userInfo setGivenName:_giveName_Txt.text];
    [userInfo setFamilyName:_familyName_Txt.text];
    [userInfo setImageUrl:_imageUrl];
    [zeppaUser setAuthEmail:_user.endPointUser.authEmail];
    [zeppaUser setPhoneNumber:phoneStr];
    [zeppaUser setUserInfo:userInfo];
    
    GTLQueryZeppaclientapi *insertZeppaUser = [GTLQueryZeppaclientapi queryForInsertZeppaUserWithObject:zeppaUser idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    
    typeof(self) __weak weakSelf = self;
    
    [self.zeppaUserService executeQuery:insertZeppaUser completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUser *response, NSError *error) {
        //
        
        if(error) {
            
            [ZPAStaticHelper showAlertWithTitle:@"Error" andMessage:@"Error creating zeppa user"];
            
            NSLog(@"Error to execute api call");
            
        } else if (response.identifier) {
            
            GTLZeppaclientapiZeppaUserInfo *responseInfo= [response userInfo];
            
            if (responseInfo) {
                ZPAMyZeppaUser *user = [[ZPAMyZeppaUser alloc]init];
                user.endPointUser = response;
                user.endPointUser.userInfo = responseInfo;
                [[ZPAZeppaUserSingleton sharedObject] setMyZeppaUser:user];
                [[ZPAApplication sharedObject] initizationsWithCurrentUser:user];
                [self hideActivity];
                [weakSelf.delegate didFinishCreatingNewUser:user];
                
            }
        } else {
            NSLog(@"Insert ZeppaUser Operation Unsuccessful");
        }
    }];
    
}

//Update Zeppa user
-(void)callUpdateZeppaUserApi{
  
    typeof(self) __weak weakSelf = self;
    [self showActivity];
    
    NSString * phoneStr = [self getPrimaryUnformattedNumber:_contactNo_Txt.text];
    
    GTLZeppaclientapiZeppaUser *zeppaUser = [ZPAAppData sharedAppData].loggedInUser.endPointUser;
    GTLZeppaclientapiZeppaUserInfo *userInfo = [zeppaUser userInfo];
    
    [userInfo setGivenName:_giveName_Txt.text];
    [userInfo setFamilyName:_familyName_Txt.text];
    [userInfo setImageUrl:_imageUrl];
    [zeppaUser setPhoneNumber:phoneStr];
    
    // Cannot update email
    
    GTLQueryZeppaclientapi *updateZeppaUserTask = [GTLQueryZeppaclientapi queryForUpdateZeppaUserWithObject:zeppaUser idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.zeppaUserService executeQuery:updateZeppaUserTask completionHandler:^(GTLServiceTicket *ticket, GTLZeppaclientapiZeppaUser *response, NSError *error) {
        //
        
        if(error) {
            
            [ZPAStaticHelper showAlertWithTitle:@"Error!" andMessage:@"Error updating user profile"];
            [self hideActivity];
            // error
        } else if (response.identifier) {
            
            NSLog(@"%@",response.userInfo);
            [self hideActivity];
            weakSelf.user.endPointUser = response;
            weakSelf.user.endPointUser.userInfo = [response userInfo];
            [weakSelf.delegate didFinishUpdatingUser:weakSelf.user];
            // success
            
        } else {
            // returned nil object
        }
        
    }];
}
// Create ZeppaUser service
-(GTLServiceZeppaclientapi *) zeppaUserService {
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
    
    // Set Auth that is held in the delegate
    
    return service;
}
///*************************************
#pragma mark - ImageUpload Api Methods
///*************************************
-(void)uploadPhotoToUser:(UIImage *)loginpic
{
    [self showActivity];
    NSURL *pasturl = [NSURL URLWithString:@"https://1-dot-zeppa-frontend-dot-zeppa-cloud-1821.appspot.com/getuploadurl"];
    NSData *data = [NSData dataWithContentsOfURL:pasturl];
    NSString *newUrl = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (newUrl) {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL* requestURL = [NSURL URLWithString:newUrl];
        [request setURL:requestURL];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval:30];
        [request setHTTPMethod:@"POST"];
        
        NSString *BoundaryConstant = @"****";
        NSString *fieldname = @"data";
        NSString *fileName = [self getFileNameFromEmail:_email_Txt.text];
        
        // set Content-Type in HTTP header
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        // post body
        NSMutableData *body = [NSMutableData data];
        
        // add image data
        NSData *imageData = UIImageJPEGRepresentation(loginpic, 100);
        if (imageData) {
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fieldname,fileName] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // setting the body of the post to the reqeust
        [request setHTTPBody:body];
        
        // set the content-length
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        // set URL
        [request setURL:requestURL];
        
        //     Get Response of Your Request
        Downloader *downloaderForOccasions = [[Downloader alloc]initWithRequest:request delegate:self];
        [downloaderForOccasions download];
        
    }
}

-(void)callProfilePhotoApiWithBlobKey:(NSString *)blobKey andservingUrl:(NSString *)url{
    
    GTLZeppaclientapiPhotoInfo *photoInfo = [[GTLZeppaclientapiPhotoInfo alloc]init];
    
    [photoInfo setBlobKey:blobKey];
    [photoInfo setUrl:url];
    [photoInfo setOwnerEmail:_email_Txt.text];
    
    
    GTLQueryZeppaclientapi *query = [GTLQueryZeppaclientapi queryForInsertPhotoInfoWithObject:photoInfo idToken:[[ZPAAuthenticatonHandler sharedAuth] authToken]];
    
    [self.photoService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
       
        if (!error && object) {
            GTLZeppaclientapiPhotoInfo *photo = object;
            _imageUrl = photo.url;
            [self hideActivity];
            [ZPAStaticHelper showAlertWithTitle:nil andMessage:@"Profile Photo uploaded successfully"];
        }
        
    }];
}

-(GTLServiceZeppaclientapi *) photoService {
    
    static GTLServiceZeppaclientapi *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaclientapi alloc] init];
        service.retryEnabled = YES;
    }
        // Set Auth that is held in the delegate
    
    
    return service;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField ==_contactNo_Txt){
    
    if (![string isEqualToString:@""]) {
        
    
    NSUInteger length = [self getLength:textField.text];
    //NSLog(@"Length  =  %d ",length);
    
    if(length == 10)
    {
        if(range.length == 0)
            return NO;
    }
        
    if (length == 0 && [string isEqualToString: @"1"]) {
        
        return NO;
    }
    
    if(length == 3)
    {
        NSString *num = [self formatNumber:textField.text];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
    }
    else if(length == 6){
        
        NSString *num = [self formatNumber:textField.text];
        //NSLog(@"%@",[num  substringToIndex:3]);
        //NSLog(@"%@",[num substringFromIndex:3]);
        textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
        if(range.length > 0)
            textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
    }
    }
    }
    return YES;
}

-(NSString*)formatNumber:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSLog(@"%@", mobileNumber);
    
    NSUInteger length = [mobileNumber length];
    if(length > 10)
    {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
        NSLog(@"%@", mobileNumber);
        
    }
    
    
    return mobileNumber;
}


-(NSUInteger)getLength:(NSString*)mobileNumber
{
    
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSUInteger length = [mobileNumber length];
    
    return length;
    
    
}



-(NSString *)getPrimaryUnformattedNumber:(NSString *)contactStr{
    
    // NSString *lastTenDigit;
    NSString *fileName = contactStr;
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    fileName = [[fileName componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    if(fileName.length > 10){
        // Remove the first digit
        // Make sure this is a 10 digit number
        fileName = [fileName substringFromIndex:[fileName length] - 10];
    }
    
    return fileName;
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

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    UITouch *touch = [touches anyObject];
//    if ([touch view]) {
//        [self.view endEditing:YES];
//    }
//}

@end
