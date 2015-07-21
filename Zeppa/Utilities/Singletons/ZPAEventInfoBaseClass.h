//
//  ZPAEventInfoBaseClass.h
//  Zeppa
//
//  Created by Dheeraj on 28/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GTLZeppaeventendpointZeppaEvent.h"
#import "GTLZeppaeventendpointCollectionResponseZeppaEvent.h"
#import "GTLServiceZeppaeventendpoint.h"
#import "GTLQueryZeppaeventendpoint.h"


typedef void(^getZeppaEventInfoOject)(GTLZeppaeventendpointZeppaEvent * event);
typedef void(^getZeppaEventInfoOjectArray)(NSArray * events);

@interface ZPAEventInfoBaseClass : NSObject
@property (nonatomic, strong) GTLServiceZeppaeventendpoint *zeppaEventService;

-(void)executeInsertZeppaEventWithAuth:(GTLZeppaeventendpointZeppaEvent *)zeppaEvent withCompletion:(getZeppaEventInfoOject)completion;
-(void)removeZeppaEventWithIdentifier:(long long) identifier;
-(void)fetchZeppaEventWithIdentifier:(long long)identifier withCompletion:(getZeppaEventInfoOject)completion;
@end
