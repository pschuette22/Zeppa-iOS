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

#import "GTLQueryZeppaclientapi.h"

#import "GTLZeppaclientapiZeppaEvent.h"
#import "GTLServiceZeppaclientapi.h"
#import "GTLZeppaclientapiZeppaEventToUserRelationship.h"

@interface ZPADefaulZeppatEventInfo : NSObject
@property (nonatomic, strong) GTLZeppaclientapiZeppaEvent *event;
@property (nonatomic, strong) GTLZeppaclientapiZeppaEventToUserRelationship *relationship;

@property (readonly) GTLServiceZeppaclientapi *zeppaEventToUserRelationshipService;

@property (nonatomic, strong) NSMutableArray *minglerRelationships;
@property (nonatomic, strong) ZPAMyZeppaEvent *zeppaEvent;

+(ZPADefaulZeppatEventInfo *)sharedObject;

-(BOOL)isAgendaEvent;

-(BOOL)isWatching;

-(BOOL)isAttending;

-(BOOL)relationshipDoesMatch:(GTLZeppaclientapiZeppaEventToUserRelationship *)relationShip;


-(void)onWatchButtonClicked:(GTLZeppaclientapiZeppaEventToUserRelationship *)relationship;

-(void)onTextButtonClicked:(UIButton *)textButton;

-(void)onJoinButtonClicked:(GTLZeppaclientapiZeppaEventToUserRelationship *)relationship;


@end
