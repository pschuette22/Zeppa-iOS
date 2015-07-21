//
//  ZPAFetchEventsForMingler.m
//  Zeppa
//
//  Created by Dheeraj on 27/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import "ZPAFetchEventsForMingler.h"
#import "ZPAAuthenticatonHandler.h"
#import "ZPAMyZeppaEvent.h"

@implementation ZPAFetchEventsForMingler{
    
    long long _minglerId;
    ZPAMyZeppaEvent *_zeppaEvent;
    NSMutableArray *_result;
    
}

-(void)executeZeppaApiWithMinglerId:(long long)mingleIdentifier{
    
    _result = [NSMutableArray array];
    
    _minglerId = mingleIdentifier;
    [self executeZeppaEventRelationshipListQueryWithCursor:nil];
}
///***********************************************
#pragma  mark - Zeppa UserToUser RelationShip Api
///***********************************************

-(void)executeZeppaEventRelationshipListQueryWithCursor:(NSString *)cursorValue{
    
    __weak typeof(self) weakSelf = self;
    GTLQueryZeppaeventtouserrelationshipendpoint *e2uRelationshipQuery = [GTLQueryZeppaeventtouserrelationshipendpoint queryForListZeppaEventToUserRelationship];
    
    //[e2uRelationshipQuery setFilter:[NSString stringWithFormat:@"eventHostId == %lld && expires > %lld",_minglerId,[ZPADateHelper currentTimeMillis]]];
    [e2uRelationshipQuery setFilter:[NSString stringWithFormat:@"eventHostId == %lld && userId == %@ && expires > %lld",_minglerId,[ZPAAppData sharedAppData].loggedInUser.endPointUser.identifier ,[ZPADateHelper currentTimeMillis]]];
    [e2uRelationshipQuery setCursor:cursorValue];
    [e2uRelationshipQuery setOrdering:@"expires desc"];
    [e2uRelationshipQuery setLimit:[[NSNumber numberWithInt:25] integerValue]];
    
    [[self zeppaUserRelationshipService] executeQuery: e2uRelationshipQuery completionHandler: ^(GTLServiceTicket *ticket,  GTLZeppaeventtouserrelationshipendpointCollectionResponseZeppaEventToUserRelationship *response, NSError *error) {
        //
        
        if(error){
            // error
        } else if(response && response.items && response.items.count > 0){
            
            for (GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *relation in response.items) {
                
               
                [weakSelf fetchZeppaEventWithIdentifier:[relation.eventId longLongValue] withCompletion:^(GTLZeppaeventendpointZeppaEvent *event) {
                   
                    ZPAMyZeppaEvent *myevent = [[ZPAMyZeppaEvent alloc]init];
                    myevent.event = event;
                    myevent.relationship = relation;
                    [[ZPAZeppaEventSingleton sharedObject] addZeppaEvents:myevent];
                    
                }];
            }
            NSString *currentCursor = response.nextPageToken;
            if (currentCursor) {
                [weakSelf executeZeppaEventRelationshipListQueryWithCursor:currentCursor];
            }else{
              // ZeppaEventSingleton.getInstance().notifyObservers();
                [weakSelf finishEventQuery];
            }
            
        } else {
           // ZeppaEventSingleton.getInstance().notifyObservers();
            [weakSelf finishEventQuery];
        }
        
    }];
    
}

-(void)finishEventQuery{
    
    NSLog(@"%@",_delegate);
    
    
    
    @try {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_delegate && [_delegate respondsToSelector:@selector(getMutualMinglerEventsList)]) {
                [_delegate getMutualMinglerEventsList];
            }
            
        });

    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }

    
}
-(GTLServiceZeppaeventtouserrelationshipendpoint *)zeppaUserRelationshipService{
    
    static GTLServiceZeppaeventtouserrelationshipendpoint *service = nil;
    
    if(!service){
        service = [[GTLServiceZeppaeventtouserrelationshipendpoint alloc] init];
        service.retryEnabled = YES;
    }
    [service setAuthorizer:[ZPAAuthenticatonHandler sharedAuth].auth];
    return service;
}
@end
