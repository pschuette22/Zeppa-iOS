//
//  ZPAAppData.m
//  Zeppa
//
//  Created by Milan Agarwal on 07/10/14.
//  Copyright (c) 2014 Milan Agarwal. All rights reserved.
//

#import "ZPAAppData.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAUserDefault.h"


static ZPAAppData *sharedData;
@interface ZPAAppData ()


@end
@implementation ZPAAppData

//****************************************************
#pragma mark - Singleton Object
//****************************************************

+(instancetype)sharedAppData
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!sharedData) {
            sharedData = [[ZPAAppData alloc]init];
        }
    });
    return sharedData;
}

//****************************************************
#pragma mark - Life Cycle
//****************************************************


-(id)init
{
    if (self = [super init]) {
        ///Do any custom intialization here
    }
    return  self;
}


-(void)dealloc
{
    
    ///Clear any strongly held object
    
}

//****************************************************
#pragma mark - Public Interface
//****************************************************
-(UIImage *)defaultUserImage
{
//    NSString *defaultUserImagePath = [[NSBundle mainBundle]pathForResource:@"default_user_image" ofType:@"png"];
//    self.defaultUserImage = [UIImage imageWithContentsOfFile:defaultUserImagePath];
//    return self.defaultUserImage;
    
    return [UIImage imageNamed:@"default_user_image.png"];
}


-(NSMutableArray *)sortArray:(NSMutableArray *)arr bySortDescriptorKey:(NSString *)key withAscendingOrder:(BOOL)value
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:value];
    //     NSSortDescriptor *sortDescriptor1 = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    
    [arr sortUsingDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    return arr;
    
}



@end
