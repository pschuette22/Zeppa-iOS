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

@interface ZPALoginVC ()<ZPACreateOrEditAccountVCDelegate>

@property (nonatomic, strong) ZPAMyZeppaUser *user;
@property (nonatomic, assign) GoogleFetchOperation currentOperation;
@property (nonatomic, weak) GTMOAuth2Authentication *auth;

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
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    [self.view setBackgroundColor:[ZPAStaticHelper backgroundTextureColor]];
    _btnLoginWithGoogle.hidden = YES;

   NSString *zeppUserIdentifier = [ZPAUserDefault getValueFromUserDefaultUsingKey:kCurrentZeppaUserId];
   if (zeppUserIdentifier && zeppUserIdentifier.length> 0) {
       
       [self showActivity];
       ///Silentily call google plus
       [[ZPAAuthenticatonHandler sharedAuth] signInWithGoogleSilently:YES];
       
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
   [[ZPAAuthenticatonHandler sharedAuth] signInWithGoogleSilently:NO];

    
//    GTMOAuth2ViewControllerTouch *authController;
//    NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeZeppauserendpointUserinfoEmail, kGTLAuthScopeCalendar, nil];
//    
//    authController = [[GTMOAuth2ViewControllerTouch alloc] initWithScope:[scopes componentsJoinedByString:@" "]
//                                                                clientID:kZeppaGooglePlusClientIdKey
//                                                            clientSecret:kZeppaGooglePlusClientSecretKey
//                                                        keychainItemName:kZeppaKeychainItemNameKey
//                                                                delegate:self
//                                                        finishedSelector:@selector(viewController:finishedWithAuth:error:)];
//    [self presentViewController:authController animated:YES completion:nil];
    
}

//- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
//      finishedWithAuth:(GTMOAuth2Authentication *)authResult
//                 error:(NSError *)error {
//    if (error != nil) {
//        NSLog(@"Error: %@", error);
//        // FUCK
//    }
//    else {
//        
//        NSLog(@"All went through apparently");
//        [viewController dismissViewControllerAnimated:YES completion:nil];
//    }
//}

///**********************************************
#pragma mark  - LoginWithGoogleSdkDelegate
///**********************************************

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    // This is what gets called when auth process has completed
    
    // There was an error with login... try again
    if(error){
        [self hideActivity];
        _btnLoginWithGoogle.hidden = NO;
        // TODO: Show error
    } else {
        
        GIDGoogleUser *user = signIn.currentUser;
        
        // Get the keychain item and update the necessary fields
        GTMOAuth2Authentication *auth = [[GTMOAuth2Authentication alloc] init];
        
        [auth setClientID:kZeppaGooglePlusClientIdKey];
        [auth setClientSecret:kZeppaGooglePlusClientSecretKey];
        [auth setUserEmail:user.profile.email];
        [auth setUserID:user.userID];
        [auth setAccessToken:user.authentication.accessToken];
        [auth setRefreshToken:user.authentication.refreshToken];
        [auth setExpirationDate: user.authentication.accessTokenExpirationDate];
        
        
        
        // Set the locally held auth to the one that was just grabbed
        self.auth = auth;
        
        [GTMOAuth2ViewControllerTouch saveParamsToKeychainForName:kZeppaKeychainItemNameKey authentication:auth];
        
        [self followSignInProtocol];
    }
    
    
}

//****************************************************
#pragma mark - Private Method
//****************************************************


/*!
 * @description Once we have valid auth object and google profile id, this method can be called, which will look after the next stage of sign in protocol in which it will try to fetch the existing user from backend server with either saved database id or google profile id. The successful response will either give GTLZeppauserendpointZeppaUser object if it exist on backend server otherwise nil. This is response will be passed to makeNextScreenDecisionWithZeppaUser: method to decide the next screen to be shown to user.
 * @param valid, non empty google plus id of authenticated user
 */

-(void)followSignInProtocol
{
    
    NSLog(@"Attempting to sign in");
    
  NSNumber *zeppUserIdentifier = [ZPAUserDefault getValueFromUserDefaultUsingKey:kCurrentZeppaUserId];
    
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
            } else if (object) {
                
                    ZPAMyZeppaUser *currentUser = object;
                    [_delegate zpaLoginVC:weakSelf didLogInWithUser:currentUser];
                    [[ZPAApplication sharedObject] initizationsWithCurrentUser:currentUser];

                
            } else {
                
                [self followSignInProtocolForCurrentUser];

            }
            
            
        }];
        
        
    } else {
    
        [self followSignInProtocolForCurrentUser];
        
    }
}

-(void) followSignInProtocolForCurrentUser {
    
    __weak ZPALoginVC *weakSelf = self;

    //It never be execute but if any exception is generate than for fetcthing Zeppauser  it works
    [[ZPAZeppaUserSingleton sharedObject]getCurrentZeppaUserWithCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        if (error) {
            [ZPAStaticHelper showAlertWithTitle:@"error" andMessage:@"Error Fetching Currrent user"];
            NSLog(@"error %@",error.description);
            _btnLoginWithGoogle.hidden = NO;
            [self hideActivity];
        } else if(object){
            
            ZPAMyZeppaUser *currentUser = object;
            [_delegate zpaLoginVC:weakSelf didLogInWithUser:currentUser];
            [[ZPAApplication sharedObject] initizationsWithCurrentUser:currentUser];
            
        }else{

            weakSelf.btnLoginWithGoogle.hidden = NO;
            [self hideActivity];
            
            [weakSelf navigateToCreateAccountScreen];
            
        }
    }];
}


-(void) navigateToCreateAccountScreen
{
    
    UINavigationController *createNewAccountNavC = [self.storyboard instantiateViewControllerWithIdentifier:@"ZPACreateOrEditAccountNavC"];
    
    ZPACreateOrEditAccountVC *createNewAccountVC = [[createNewAccountNavC viewControllers]firstObject];
    createNewAccountVC.vcDisplayMode = VCDisplayModeCreateAccount;
    createNewAccountVC.delegate = self;
    [self presentViewController:createNewAccountNavC animated:YES completion:NULL];
    
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


@end
