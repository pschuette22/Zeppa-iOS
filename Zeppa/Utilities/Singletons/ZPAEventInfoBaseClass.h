//
//  ZPAEventInfoBaseClass.h
//  Zeppa
//
//  Created by Dheeraj on 28/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLZeppaclientapiCollectionResponseZeppaEvent.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLQueryZeppaclientapi.h"


typedef void(^getZeppaEventInfoOject)(GTLZeppaclientapiZeppaEvent * event);
typedef void(^getZeppaEventInfoOjectArray)(NSArray * events);

@interface ZPAEventInfoBaseClass : NSObject
@property (nonatomic, strong) GTLServiceZeppaclientapi *zeppaEventService;

-(void)executeInsertZeppaEventWithAuth:(GTLZeppaclientapiZeppaEvent *)zeppaEvent withCompletion:(getZeppaEventInfoOject)completion;
-(void)removeZeppaEventWithIdentifier:(long long) identifier;
-(void)fetchZeppaEventWithIdentifier:(long long)identifier withCompletion:(getZeppaEventInfoOject)completion;
@end
