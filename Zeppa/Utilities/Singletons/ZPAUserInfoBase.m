//
//  ZPAUserInfoBaseClass.m
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAUserInfoBase.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAZeppaUserSingleton.h"

@implementation ZPAUserInfoBase {
    BOOL _isLoadingImage;
}

-(id) initWithUserInfo:(GTLZeppaclientapiZeppaUserInfo*)userInfo {
    if(self =[super init]) {
        self.userInfo = userInfo;
        self.imageLoadListeners = [[NSMutableArray alloc] init];
        
        [self loadImageInAsync];
    }
    return self;
}

- (NSNumber*) getUserId {
    return self.userInfo.key.parent.identifier;
}

-(NSString*) getDisplayName {
    return [NSString stringWithFormat:@"%@ %@", _userInfo.givenName, _userInfo.familyName];
}

-(UIImage*) getDisplayImageWithCompletion:(OnImageLoad) completion {
    
    // If another image is being loaded add the completion listener
    if(_isLoadingImage){
        [self.imageLoadListeners addObject:completion];
    }
    
    if(_image){
        // If there is a stored image for this model, return it
        return _image;
    } else {
        // If not, return the default image
        return [UIImage imageNamed:@"default_user_image"];
    }
}


/**
 *  Load the image in a thread and notify the waiting observers when completed
 */
- (void) loadImageInAsync {
    _isLoadingImage = YES;
    
    // Load the image in the background
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:_userInfo.imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSError* error = nil;
        
        // If this returned data, successfully loaded image
        if(data) {
            // If data was returned, image was loaded successfully
            self.image = [UIImage imageWithData:data];
        } else {
            // Otherwise there was an error loading the data, explore possible issues
            error=  [[NSError alloc] initWithDomain:@"com.zeppamobile.zeppaios" code:300 userInfo:nil];
        }
        
        if(self.imageLoadListeners && self.imageLoadListeners.count>0){
         
            // Iterate through objects waiting for image to load
            for(OnImageLoad onLoad in self.imageLoadListeners) {
                onLoad(self.image,error);
            }
            
        }
        
    });
}


@end
