//
//  ZPANotification.h
//  Zeppa
//
//  Created by Dheeraj on 13/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTLZeppaclientapiZeppaNotification.h"

@interface ZPANotificationSingleton : NSObject

@property (nonatomic,strong)GTLZeppaclientapiZeppaNotification *notification;

@property (nonatomic,strong)NSMutableArray * notificationArray;



+(ZPANotificationSingleton *)sharedObject;
+(void)resetObject;

-(void)removeNotificationForEvent:(long long)eventId;
-(void)removeNotification:(long long)notificationId;
-(NSArray *)getNotification;
-(BOOL)hasLoadedInitial;
-(void)onLoadedInitialNotification;
-(NSInteger)getNotificationTypeOrder:(NSString *)notificationType ;
-(NSString *)getNotificationTitle:(GTLZeppaclientapiZeppaNotification *)notification;
-(NSString *)getNotificationMessage:(GTLZeppaclientapiZeppaNotification *)notification;

-(void)fetchInitialNotifications:(long long)userId;
-(void)addZeppaNotification:(GTLZeppaclientapiZeppaNotification *)notification;
-(void)executeRemoveNotification:(long long)notificationId;

-(void)didReceiveNotification:(NSNumber *)notificationId;
-(void)fetchNotificationById:(NSNumber *)notificationId;

@end
