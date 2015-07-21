//
//  ZPALoginVC.m
//  Zeppa
//
//  Created by Milan Agarwal on 29/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//
#import "ZPALoginVC.h"
#import "ZPACalendar.h"
#import "ZPAEvent.h"
#import "ZPADateHelper.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPACreateOrEditAccountVC.h"
#import "ZPAApplication.h"
#import "ZPAUserDefault.h"
#import "ZPAZeppaUserSingleton.h"
#import "ZPASwapperVC.h"
#import "ZPASplitVC.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTMHTTPFetcherLogging.h"
#import "GTLServicePlus.h"
#import "GTLQueryPlus.h"
#import "GTLPlusPerson.h"
#import "GTLCalendar.h"

#import "GTLZeppauserendpoint.h"
#import "GTLZeppauserendpointZeppaUserInfo.h"

typedef enum {

    GoogleFetchOperationNone = -1,
    GoogleFetchOperationBasicInfo,
    GoogleFetchOperationCalendarList,
    GoogleFetchOperationCalendarEvents,
    GoogleFetchOperationFriendList
    
}GoogleFetchOperation;

@interface ZPALoginVC ()<ZPACreateOrEditAccountVCDelegate,loginWithGoogleSdkDelegate,loginErrorDelegate>

@property (nonatomic, strong) GoogleOAuth *googleOAuth;
@property (nonatomic, strong) ZPAMyZeppaUser *user;
@property (nonatomic, assign) GoogleFetchOperation currentOperation;
@property (nonatomic, weak) GTMOAuth2Authentication *auth;

@property (readonly) GTLServicePlus *plusService;
@property (readonly) GTLServiceZeppauserendpoint *zeppaUserService;


@end

@implementation ZPALoginVC

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
///**********************************************
#pragma mark - View Life Cycle Methods
///**********************************************
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideActivity];
    
    [ZPAAuthenticatonHandler sharedAuth].delegate = self;
    [ZPAZeppaUserSingleton sharedObject].delegate = self;
    
    [self.view setBackgroundColor:[ZPAStaticHelper backgroundTextureColor]];
    _btnLoginWithGoogle.hidden = YES;

   // NSString *zeppUserIdentifier = [NSString stringWithFormat:@"5107179300323328"];
   NSString *zeppUserIdentifier = [ZPAUserDefault getValueFromUserDefaultUsingKey:kCurrentZeppaUserId];
   if (zeppUserIdentifier && zeppUserIdentifier.length> 0) {
       
       [self showActivity];
       ///Silentily call google plus
       [[ZPAAuthenticatonHandler sharedAuth] signInWithGooglePlus];
       
    }else{
       _btnLoginWithGoogle.hidden = NO;
       
   }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self.view endEditing:YES];
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
- (IBAction)btnLoginWithGoogleTapped:(UIButton *)sender {
    sender.hidden = YES;
    [self showActivity];
    [[ZPAAuthenticatonHandler sharedAuth] signInWithGooglePlus];
}
///**********************************************
#pragma mark  - LoginWithGoogleSdkDelegate
///**********************************************
/*!
 @decription delegate method of ZPAAuthentication class and call when return after authentication
 */
-(void)loginWithGoogleAuthSuccessfully:(BOOL)condition{
    
    //[self hideActivity];
    
    if (condition) {
        
       //  NSString *zeppUserIdentifier = [NSString stringWithFormat:@"5107179300323328"];
        
        NSString *zeppUserIdentifier = [ZPAUserDefault getValueFromUserDefaultUsingKey:kCurrentZeppaUserId];
        if (zeppUserIdentifier && zeppUserIdentifier.length> 0) {
            
            self.auth = [ZPAAuthenticatonHandler sharedAuth].auth;
            if ([ZPAAuthenticatonHandler isAuthValid:self.auth]) {
                ///Using dispatch after is a hack to let the login view appear before presenting the ZPACreateorEditAccountVC
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self followSignInProtocolWithZeppaUserId:zeppUserIdentifier];
                    
                });
                
            }else{
                ///There is no valid auth object saved, show login button
                _btnLoginWithGoogle.hidden = NO;
            }
            
        }else{
            
            [self fetchBasicInfo];
        }
        
    }else{
        ///If Any Problem is occur in authentication
        _btnLoginWithGoogle.hidden = NO;
    }
    
}
//****************************************************
#pragma mark - Private Method
//****************************************************

/*!
 *@decription this function is used to get all infomation regarding to authorised user
  */
-(void)fetchBasicInfo{
    
    typeof(self) weakSelf = self;
    
    // [self showActivity];
    ///1. Fetch user information from Google Plus
    [self getProfileInformationWithCompletionHandler:^(ZPAMyZeppaUser *zpaUser, NSError *error) {
        
        
        if (!error) {
            ///Save this zpauser object to avoid making call for get profile info again in makeNextScreenDecisionWithZeppaUser method
            /*If we get googleId from authentication than get current user
             when current user get than call Home screen otherwise create
             account screen.
             */
            weakSelf.user = zpaUser;
            if (zpaUser.endPointUser.googleProfileId && zpaUser.endPointUser.googleProfileId.length > 0) {
                
                [[ZPAZeppaUserSingleton sharedObject]getCurrentZeppaUserWithCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                    if (error) {
                        [ZPAStaticHelper showAlertWithTitle:@"error" andMessage:@"Error Fetching Currrent user"];
                        NSLog(@"error %@",error.description);
                        _btnLoginWithGoogle.hidden = NO;
                    }
                    ZPAMyZeppaUser *currentUser = object;
                    if([currentUser.endPointUser.identifier longLongValue]>0){
                        
                        [weakSelf makeNextScreenDecisionWithZeppaUser:currentUser];
                        [[ZPAApplication sharedObject] initizationsWithCurrentUser:currentUser];
                        
                    }else{
                        
                        [weakSelf makeNextScreenDecisionWithZeppaUser:nil];
                    }
                }];
            }
        }
        else{
            
            [ZPAStaticHelper showAlertWithTitle:NSLocalizedString(@"Fetch Basic Info Error", nil) andMessage:error.localizedDescription];
                [self hideActivity];
            _btnLoginWithGoogle.hidden = NO;
        }
    }];
    
}
/*!
 * method to fetch profile information of the logged in user via Google
 *
 */
-(void)getProfileInformationWithCompletionHandler:(getGPProfileInfoCompletionHandler)completion
{
    
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    
    GTLQueryPlus *query =
    [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                                        
                    [ZPAStaticHelper showAlertWithTitle:NSLocalizedString(@"Fetch Basic Info Error", nil) andMessage:error.localizedDescription];
                    [self hideActivity];
                    _btnLoginWithGoogle.hidden = NO;
                    
                }else{
            
                NSMutableDictionary *dictionary = person.JSON;
              ///Create ZeppaUser object if does not exist
              ZPAMyZeppaUser  *zeppaUser = [[ZPAMyZeppaUser alloc]init];
             if ([ZPAStaticHelper canUseWebObject:dictionary]) {
           
                 ///Create ZeppaUserEndpointZeppaUser object
                 if(!zeppaUser.endPointUser)
                 {
                     zeppaUser.endPointUser =[GTLZeppauserendpointZeppaUser object];
                     
                 }
                 ///Create GTLZeppauserendpointZeppaUserInfo object
                 if (!zeppaUser.endPointUser.userInfo) {
                     zeppaUser.endPointUser.userInfo = [GTLZeppauserendpointZeppaUserInfo object];
                 }
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             ///Save Google Plus id
             NSString *googlePlusProfileId = [dictionary objectForKey:kZeppaGooglePlusIdKey];
             if ([ZPAStaticHelper canUseWebObject:googlePlusProfileId]) {
                 ///Save to defaults
                 [defaults setObject:googlePlusProfileId forKey:kZeppaLoggedInUserGooglePlusIdKey];
                 [defaults synchronize];
                 ///Save Google plus id in user object
                 zeppaUser.endPointUser.googleProfileId = googlePlusProfileId;
                 
             }
                         ///Get First name and last name
             NSDictionary *dictName = [dictionary objectForKey:kZeppaGooglePlusNameKey];
             if ([ZPAStaticHelper canUseWebObject:dictName]) {
                 ///First name
                 NSString *strFirstName = [dictName objectForKey:kZeppaGooglePlusNameGivenNameKey];
                 if ([ZPAStaticHelper canUseWebObject:strFirstName]) {
                     zeppaUser.endPointUser.userInfo.givenName = strFirstName;
                 }
                 
                 ///Last Name
                 NSString *strLastName = [dictName objectForKey:kZeppaGooglePlusNameFamilyNameKey];
                 if ([ZPAStaticHelper canUseWebObject:strLastName]) {
                     zeppaUser.endPointUser.userInfo.familyName = strLastName;
                 }
             }
             ///Get Profile Image URL
             NSDictionary *dictImage = [dictionary objectForKey:kZeppaGooglePlusImageKey];
             if ([ZPAStaticHelper canUseWebObject:dictImage]) {
                 
                 NSString *strImageUrl = [dictImage objectForKey:kZeppaGooglePlusImageUrlKey];
                 if ([ZPAStaticHelper canUseWebObject:strImageUrl]) {
                     
                     NSArray *arrImageUrlComponents = [strImageUrl componentsSeparatedByString:@"?"];
                     if (arrImageUrlComponents.count > 0) {
                         strImageUrl = [arrImageUrlComponents firstObject];
                         
                     }
                     
                     zeppaUser.endPointUser.userInfo.imageUrl = strImageUrl;
                 }
                 
             }
             
             ///Get emails
             NSArray *arrEmails = [dictionary objectForKey:kZeppaGooglePlusEmailsKey];
             if ([ZPAStaticHelper canUseWebObject:arrEmails] && arrEmails.count > 0) {
                 NSMutableArray *arrEmailValues = [NSMutableArray array];
                 for (NSDictionary *dictEmail in arrEmails) {
                     NSString *strEmail = [dictEmail objectForKey:kZeppaGooglePlusEmailsValueKey];
                     if ([ZPAStaticHelper canUseWebObject:strEmail]) {
                         [arrEmailValues addObject:strEmail];
                     }
                 }
                 
                 if (arrEmailValues.count > 0) {
                     zeppaUser.arrEmails = [NSArray arrayWithArray:arrEmailValues];
                     zeppaUser.endPointUser.userInfo.googleAccountEmail = [zeppaUser.arrEmails firstObject];
                 }
                 
                 
                 
             }
                 
             }
             if (completion != NULL) {
                 completion(zeppaUser, error);
             }
             
         }
     }];
    
}
/*!
 * @description Once we have valid auth object and google profile id, this method can be called, which will look after the next stage of sign in protocol in which it will try to fetch the existing user from backend server with either saved database id or google profile id. The successful response will either give GTLZeppauserendpointZeppaUser object if it exist on backend server otherwise nil. This is response will be passed to makeNextScreenDecisionWithZeppaUser: method to decide the next screen to be shown to user.
 * @param valid, non empty google plus id of authenticated user
 */

-(void)followSignInProtocolWithZeppaUserId:(NSString *)ZeppaUserId
{
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
  NSNumber *zeppUserIdentifier = [f numberFromString:ZeppaUserId];
    
    __weak ZPALoginVC *weakSelf = self;
    
    if (zeppUserIdentifier > 0) {
        
        
       long long userId = [zeppUserIdentifier longLongValue];
        
        
        ///Fetch the current user object using saved zeppaUserId
        [[ZPAZeppaUserSingleton sharedObject]getZeppaUserWithUserId:userId andCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
            
            if (error) {
                [ZPAStaticHelper showAlertWithTitle:@"error" andMessage:@"Error Fetching Currrent user"];
                 NSLog(@"error %@",error.description);
                _btnLoginWithGoogle.hidden = NO;
                [self hideActivity];
            }
            
            if (!error) {
                if(object){
                    
                    ZPAMyZeppaUser *currentUser = object;
                    [weakSelf makeNextScreenDecisionWithZeppaUser:currentUser];
                    [[ZPAApplication sharedObject] initizationsWithCurrentUser:currentUser];
                    
                }else{
                    
                    //It never be execute but if any exception is generate than for fetcthing Zeppauser  it works
                    [[ZPAZeppaUserSingleton sharedObject]getCurrentZeppaUserWithCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
                        
                        if(object){
                            
                            ZPAMyZeppaUser *currentUser = object;
                            [weakSelf makeNextScreenDecisionWithZeppaUser:currentUser];
                            [[ZPAApplication sharedObject] initizationsWithCurrentUser:currentUser];
                            
                        }else{
                            
                            weakSelf.btnLoginWithGoogle.hidden = NO;
                        }
                    }];
                }
                
            }else if(error) {
                
                NSLog(@"Error in GTLQueryZeppauserendpoint %@",error.localizedDescription);
                [ZPAStaticHelper showAlertWithTitle:NSLocalizedString(@"Authentication Error", nil)  andMessage:error.localizedDescription];
                
                ///Show login button
                weakSelf.btnLoginWithGoogle.hidden = NO;
                [self hideActivity];
            }
            
            
        }];
        
        
    }
}

/*!
 * @description It will decide whether to show main interface (i.e home screen) if zeppaUser is not nil and valid user, otherwise it will show Create New Account screen to create a new Zeppa User.
 * @param zeppaUser A GTLZeppauserendpoint user object fetched using GTLServiceZeppauserendpoint methods
 */
-(void)makeNextScreenDecisionWithZeppaUser:(ZPAMyZeppaUser *)zeppaUser
{
    
    // if zeppa user nil than open createAccount Screen otherwise open Home screen.
    [self hideActivity];
    __weak typeof(self) weakSelf = self;
    if (!zeppaUser) {
        if (!self.user) {
            ///This will be the most unlikely to be happen case where we have either saved zeppa user database id or google plus id who have earlier logged in but does not seems to be exist in the backend server anymore in which case only the self.zeppaUser will be nil
            
            /// So Pull the user's Profile information
            
            
            weakSelf.user = zeppaUser;
            
            ///Show Create new account screen
            UINavigationController *createNewAccountNavC = [weakSelf.storyboard instantiateViewControllerWithIdentifier:@"ZPACreateOrEditAccountNavC"];
            
            ZPACreateOrEditAccountVC *createNewAccountVC = [[createNewAccountNavC viewControllers]firstObject];
            createNewAccountVC.user = weakSelf.user;
            createNewAccountVC.vcDisplayMode = VCDisplayModeCreateAccount;
            createNewAccountVC.delegate = weakSelf;
            [weakSelf presentViewController:createNewAccountNavC animated:YES completion:NULL];
            
            ///Show the login button
            [weakSelf.btnLoginWithGoogle setHidden:NO];
            
            
            
        }
        else{
            
            ///Show Create new account screen
            UINavigationController *createNewAccountNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPACreateOrEditAccountNavC"];
            
            ZPACreateOrEditAccountVC *createNewAccountVC = [[createNewAccountNavC viewControllers]firstObject];
            createNewAccountVC.user = weakSelf.user;
            createNewAccountVC.vcDisplayMode = VCDisplayModeCreateAccount;
            createNewAccountVC.delegate = self;
            [self presentViewController:createNewAccountNavC animated:YES completion:NULL];
            
        }
        
        
        
    }
    else{
        
        [_delegate zpaLoginVC:self didLogInWithUser:zeppaUser];
        
        
    }
    
}

//****************************************************
#pragma mark - ZPACreateOrEditAccountVCDelegate Methods
//****************************************************
-(void)didFinishCreatingNewUser:(ZPAMyZeppaUser *)user
{
    [ZPAAppData sharedAppData].loggedInUser = user;
    [_delegate zpaLoginVC:self didLogInWithUser:user];
}

//***********************************
#pragma mark - ActivityView Methods
//***********************************
-(void)showActivity{
    
    [self.activity_Loading startAnimating];
    self.view.userInteractionEnabled = NO;
}
-(void)hideActivity{
    
    [self.activity_Loading stopAnimating];
    self.view.userInteractionEnabled = YES;
}

//***********************************
#pragma mark - login Error Delegate Methods
//***********************************
-(void)showLoginError{
    
//    [ZPAStaticHelper showAlertWithTitle:@"error" andMessage:@"Error Fetching Currrent user"];
//    _btnLoginWithGoogle.hidden = NO;
//    [self hideActivity];
    
      [_delegate zpaLoginVC:self didLogInWithUser:nil];
    
}

@end
