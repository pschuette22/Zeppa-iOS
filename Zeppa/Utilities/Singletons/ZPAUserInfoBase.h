//
//  ZPAUserInfoBaseClass.h
//  Zeppa
//
//  Created by Dheeraj on 20/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPAUserInfoBase : NSObject

typedef void (^OnImageLoad) (UIImage *image, NSError*error);

@property (nonatomic,strong) GTLZeppaclientapiZeppaUserInfo *userInfo;
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSMutableArray<OnImageLoad> *imageLoadListeners;

-(id) initWithUserInfo:(GTLZeppaclientapiZeppaUserInfo*)userInfo;

-(NSString*) getDisplayName;

-(UIImage*) getDisplayImageWithCompletion:(OnImageLoad) completion;

- (void) loadImageInAsync;

- (NSNumber*) getUserId;

@end
