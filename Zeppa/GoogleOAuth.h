//
//  GoogleOAuth.h
//  Zeppa
//
//  Created by Milan Agarwal on 01/09/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    httpMethod_GET,
    httpMethod_POST,
    httpMethod_DELETE,
    httpMethod_PUT
} HTTP_Method;

@protocol GoogleOAuthDelegate
-(void)authorizationWasSuccessful;
-(void)accessTokenWasRevoked;
-(void)responseFromServiceWasReceived:(NSString *)responseJSONAsString andResponseJSONAsData:(NSData *)responseJSONAsData;
-(void)errorOccuredWithShortDescription:(NSString *)errorShortDescription andErrorDetails:(NSString *)errorDetails;
-(void)errorInResponseWithBody:(NSString *)errorMessage;
@end

@interface GoogleOAuth : UIWebView<UIWebViewDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, assign) id<GoogleOAuthDelegate> gOAuthDelegate;
-(void)authorizeUserWithClienID:(NSString *)client_ID andClientSecret:(NSString *)client_Secret
                  andParentView:(UIView *)parent_View andScopes:(NSArray *)scopes;
-(void)revokeAccessToken;

/*!
 * @description Will be used to remove the saved access token and refresh token from file if exist. Which asks user to re enter username and password on tapping Google Plus button.
    @returns YES if tokens were successfully removed. 
 */
-(BOOL)clearAccessAndRefreshToken;


///Only POST request is being handled for now
-(void)callAPI:(NSString *)apiURL withHttpMethod:(HTTP_Method)httpMethod
postParameterNames:(NSArray *)params postParameterValues:(NSArray *)values;

@end
