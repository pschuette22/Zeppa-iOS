//
//  ZPAGooglePlusLoginHelper.m
//  Zeppa
//
//  Created by Milan Agarwal on 30/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAGooglePlusLoginHelper.h"
#import <GoogleOpenSource/GoogleOpenSource.h>

static ZPAGooglePlusLoginHelper * loginHelper;

@interface ZPAGooglePlusLoginHelper ()
{
    GPPSignIn *signIn;
}

@end

@implementation ZPAGooglePlusLoginHelper


//****************************************************
#pragma mark - Life Cycle
//****************************************************

-(void)dealloc
{
    self.delegate = nil;
    self.arrScopes = nil;
    self.clientId = nil;
    signIn = nil;

}

//****************************************************
#pragma mark - Public Interface
//****************************************************

+(ZPAGooglePlusLoginHelper *)sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!loginHelper) {
            loginHelper = [[ZPAGooglePlusLoginHelper alloc]init];
        
        }
    });
    return loginHelper;
}

-(instancetype)init
{
    if (self = [super init]) {
        signIn = [GPPSignIn sharedInstance];
        self.clientId = kZeppaGooglePlusClientIdKey;
        self.shouldFetchGooglePlusUser = YES;
        self.shouldFetchGoogleUserEmail = YES;
        
        // Uncomment one of these two statements for the scope you chose in the previous step
        self.arrScopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
        //signIn.scopes = @[ @"profile" ];            // "profile" scope
        
        signIn.delegate = self;
        
    }
    return self;
}

-(instancetype)initWithClientID:(NSString *)clientId andDelegate:(id<ZPAGooglePlusLoginHelperDelegate>)delegate
{
    if (self = [super init]) {
       
        
        // You previously set kClientId in the "Initialize the Google+ client" step
        signIn.clientID = clientId;
        
        // Uncomment one of these two statements for the scope you chose in the previous step
        signIn.scopes = @[ kGTLAuthScopePlusLogin ];  // "https://www.googleapis.com/auth/plus.login" scope
        //signIn.scopes = @[ @"profile" ];            // "profile" scope
        
        signIn.delegate = self;
        
        self.delegate = delegate;

    }
    return self;
}


//Setters
-(void)setShouldFetchGooglePlusUser:(BOOL)shouldFetchGooglePlusUser
{
    signIn.shouldFetchGooglePlusUser = shouldFetchGooglePlusUser;
}

-(void)setShouldFetchGoogleUserEmail:(BOOL)shouldFetchGoogleUserEmail
{
    signIn.shouldFetchGoogleUserEmail = shouldFetchGoogleUserEmail;

}

-(void)setArrScopes:(NSArray *)arrScopes
{
    signIn.scopes = arrScopes;
}

-(void)setClientId:(NSString *)clientId
{
    signIn.clientID = clientId;
}



-(void)authenticateWithGoogle
{
    [signIn authenticate];

}

- (void)signOutFromGoogle {
    [signIn signOut];
}

- (void)disconnectFromGoogle {
    [signIn disconnect];
}

-(BOOL)trySilentAuthenticationFromGoogle
{
   return [signIn trySilentAuthentication];
}

//****************************************************
#pragma mark - GPPSignInDelegate Method
//****************************************************


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    
    [_delegate loginHelperDidFinishedWithAuth:auth error:error];
    
    
}

- (void)didDisconnectWithError:(NSError *)error {

    if ([_delegate respondsToSelector:@selector(loginHelperDidDisconnectWithError:)]) {
        [_delegate loginHelperDidDisconnectWithError:error];
    }
 
}





@end
