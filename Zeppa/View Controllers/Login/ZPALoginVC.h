//
//  ZPALoginVC.h
//  Zeppa
//
//  Created by Milan Agarwal on 29/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <GooglePlus/GooglePlus.h>
#import "GoogleOAuth.h"
#import "ZPAMyZeppaUser.h"
#import "ZPAAuthenticatonHandler.h"



@class GPPSignInButton;

///This Class will handle the user login.

@protocol ZPALoginVCDelegate;

@interface ZPALoginVC : UIViewController

@property (nonatomic, assign)id<ZPALoginVCDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity_Loading;
@property (weak, nonatomic) IBOutlet UIButton *btnLoginWithGoogle;

- (IBAction)btnLoginWithGoogleTapped:(UIButton *)sender;

@end

@protocol ZPALoginVCDelegate <NSObject>

/*!
 * @description This will be called to notify the delegate that the login process is completed.
 * @param loginVC contains the reference of the Login view controller
 * @param user will contain the information of the signed in user.
 */
- (void)zpaLoginVC:(ZPALoginVC *)loginVC didLogInWithUser:(ZPAMyZeppaUser *)user;
//- (void)zpaLoginVC:(ZPALoginVC *)loginVC didFailToLogInWithError:(NSError *)error;

@end