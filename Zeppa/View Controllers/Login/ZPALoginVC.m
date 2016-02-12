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

#import "GTMHTTPFetcherLogging.h"
#import "GTLCalendar.h"

#import "GTLZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaUserInfo.h"

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

@property (readonly) GTLServiceZeppaclientapi *zeppaUserService;


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
    _btnLoginWithGoogle.hidden = NO;
    
    // If User is signed in, sign in automatically
    if([ZPAUserDefault getValueFromUserDefaultUsingKey:kCurrentZeppaUserEmail]){
        _btnLoginWithGoogle.hidden = YES;
        [self showActivity];
        [[ZPAAuthenticatonHandler sharedAuth] signInWithGoogle];
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
    [[ZPAAuthenticatonHandler sharedAuth] signInWithGoogle];
}



///**********************************************
#pragma mark  - LoginWithGoogleSdkDelegate
///**********************************************

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    // This is what gets called when auth process has completed
    
    // There was an error with login... try again
    if(error || !signIn.currentUser){
        [self hideActivity];
        _btnLoginWithGoogle.hidden = NO;
        
    } else {
        // Follow the signin protocol
        [self followSignInProtocol];
    }
    
    
}

//****************************************************
#pragma mark - Private Method
//****************************************************


/*!
 * @description Once we have valid auth object and google profile id, this method can be called, which will look after the next stage of sign in protocol in which it will try to fetch the existing user from backend server with either saved database id or google profile id. The successful response will either give GTLZeppaclientapiZeppaUser object if it exist on backend server otherwise nil. This is response will be passed to makeNextScreenDecisionWithZeppaUser: method to decide the next screen to be shown to user.
 * @param valid, non empty google plus id of authenticated user
 */

-(void)followSignInProtocol
{
    
    NSLog(@"Attempting to sign in");
    
    __weak ZPALoginVC *weakSelf = self;

    [[ZPAZeppaUserSingleton sharedObject]getCurrentZeppaUserWithCompletionHandler:^(GTLServiceTicket *ticket, id object, NSError *error) {
        
        if (error) {
            
            
            [ZPAStaticHelper showAlertWithTitle:@"error" andMessage:@"Error Signing in"];
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
