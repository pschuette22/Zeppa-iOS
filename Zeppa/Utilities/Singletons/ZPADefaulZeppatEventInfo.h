//
//  ZPADefaulZeppatEventInfo.h
//  Zeppa
//
//  Created by Dheeraj on 22/04/15.
//  Copyright (c) 2015 Milan Agarwal. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ZPAMyZeppaEvent.h"

#import "ZPAAuthenticatonHandler.h"

#import "GTLQueryZeppaeventtouserrelationshipendpoint.h"

#import "GTLZeppaeventendpointZeppaEvent.h"
#import "GTLServiceZeppaeventtouserrelationshipendpoint.h"
#import "GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship.h"

@interface ZPADefaulZeppatEventInfo : NSObject
@property (nonatomic, strong) GTLZeppaeventendpointZeppaEvent *event;
@property (nonatomic, strong) GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *relationship;

@property (readonly) GTLServiceZeppaeventtouserrelationshipendpoint *zeppaEventToUserRelationshipService;

@property (nonatomic, strong) NSMutableArray *minglerRelationships;
@property (nonatomic, strong) ZPAMyZeppaEvent *zeppaEvent;

+(ZPADefaulZeppatEventInfo *)sharedObject;

-(BOOL)isAgendaEvent;

-(BOOL)isWatching;

-(BOOL)isAttending;

-(BOOL)relationshipDoesMatch:(GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *)relationShip;


-(void)onWatchButtonClicked:(GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *)relationship;

-(void)onTextButtonClicked:(UIButton *)textButton;

-(void)onJoinButtonClicked:(GTLZeppaeventtouserrelationshipendpointZeppaEventToUserRelationship *)relationship;


@end
