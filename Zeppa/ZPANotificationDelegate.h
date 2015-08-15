//
//  ZPANotificationDelegate.h
//  Zeppa
//
//  Created by Peter Schuette on 8/11/15.
//  Copyright (c) 2015 Pete Schuette. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPANotificationDelegate : NSObject

@property (nonatomic, retain) NSMutableArray *pendingNotifications;
@property (nonatomic, copy) void (^completionHandler)(UIBackgroundFetchResult);
@property (atomic) NSInteger *runningTasks;
@property (atomic) NSInteger *successCount;
@property (atomic) NSInteger *failCount;


+(ZPANotificationDelegate*) sharedObject;

-(void)doNotificationPreprocessing:(NSDictionary*)info;
-(void)doNotificationPreprocessing:(NSDictionary*)info withCompletionHandler: (void (^)(UIBackgroundFetchResult))handler ;

-(void)dispatchPendingNotifications;
-(void)didFinishTaskWithSuccess:(BOOL)success;


@end
