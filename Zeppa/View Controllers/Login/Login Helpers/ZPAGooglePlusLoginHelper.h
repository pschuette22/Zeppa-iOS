//
//  ZPAGooglePlusLoginHelper.h
//  Zeppa
//
//  Created by Milan Agarwal on 30/08/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GooglePlus/GooglePlus.h>

@protocol ZPAGooglePlusLoginHelperDelegate;


@interface ZPAGooglePlusLoginHelper : NSObject<GPPSignInDelegate>

@property (nonatomic, assign) id<ZPAGooglePlusLoginHelperDelegate>delegate;

///An Array of scopes
@property (nonatomic, strong) NSArray * arrScopes;

@property (nonatomic, assign) BOOL shouldFetchGooglePlusUser;

@property (nonatomic, assign) BOOL shouldFetchGoogleUserEmail;

@property (nonatomic, strong) NSString * clientId;

//****************************************************
#pragma mark - Public Interface
//****************************************************

+ (ZPAGooglePlusLoginHelper *)sharedHelper;

//- (instancetype)initWithClientID:(NSString *)clientId andDelegate:(id<ZPAGooglePlusLoginHelperDelegate>)delegate;

- (void)authenticateWithGoogle;
- (void)signOutFromGoogle ;
- (void)disconnectFromGoogle ;
- (BOOL)trySilentAuthenticationFromGoogle;

@end


@protocol ZPAGooglePlusLoginHelperDelegate <NSObject>

- (void)loginHelperDidFinishedWithAuth: (GTMOAuth2Authentication *)auth
                        error: (NSError *) error ;
@optional

- (void)loginHelperDidDisconnectWithError:(NSError *)error;
    
@end
